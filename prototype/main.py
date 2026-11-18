#!/usr/bin/env python3
"""
Prototype Zimut v2 - Combat tour par tour
Corrections :
- Panneau des sorts déplacé à droite
- Personnage actif surligné en jaune
- Bug des PA corrigé (utilise spell.cost_pa/cost_pm)
- Structure pour les points de compétences
- Chemin des CSV corrigé pour fonctionner depuis le dossier prototype
Mode Cartes tactiques (--cards, ou --simulate N sans affichage) : duel héros
contre héros adverse, piloté par un deck de 20 cartes (décisions Q1-Q5 de
prototype/zimut/MODE_CARTES_TACTIQUE.md).
"""

import pygame
import sys
import csv
import os
import random
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple

# ==================== CONFIGURATION ====================
SCREEN_WIDTH = 1200  # Augmenté pour le panneau des sorts
SCREEN_HEIGHT = 700
GRID_SIZE = 10
CELL_SIZE = 50
MARGIN = 50

# Mode Cartes tactiques (décisions Q1-Q5, voir prototype/zimut/MODE_CARTES_TACTIQUE.md)
DECK_SIZE = 20        # Q3 : taille du deck
HAND_START = 5        # Q3 : main de départ
HAND_MAX = 7          # Q3 : main max (au-delà, la carte piochée est défaussée)
SUMMON_MAX = 3        # règle existante : max 3 invocations actives par camp
SUMMON_RANGE = 2      # portée de pose d'une carte Invocation
HAND_Y = SCREEN_HEIGHT - 160


def dist(a, b) -> int:
    return abs(a.x - b.x) + abs(a.y - b.y)

# Couleurs
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
GRAY = (200, 200, 200)
LIGHT_GRAY = (220, 220, 220)
DARK_GRAY = (100, 100, 100)
RED = (255, 50, 50)
GREEN = (50, 255, 50)
BLUE = (50, 50, 255)
YELLOW = (255, 255, 0)
ORANGE = (255, 165, 0)
PURPLE = (128, 0, 128)

# ==================== DATA CLASSES ====================
@dataclass
class Spell:
    name: str
    classe: str
    cost_pa: int
    cost_pm: int
    range: int
    effect: str
    level_required: int
    spell_type: str

    def can_cast(self, entity) -> bool:
        return (entity.current_pa >= self.cost_pa and
                entity.current_pm >= self.cost_pm and
                entity.level >= self.level_required)

@dataclass
class Card:
    """Carte du mode Cartes tactiques : Q1, la carte coûte les PA/PM du héros."""
    name: str
    card_type: str          # "Invocation" ou "Sort"
    ref: str                # nom dans invocations.csv ou sorts.csv
    cost_pa: int
    cost_pm: int
    range: int
    effect: str
    level_required: int = 1

    def can_play(self, pa: int, pm: int, level: int) -> bool:
        return pa >= self.cost_pa and pm >= self.cost_pm and level >= self.level_required

@dataclass
class Entity:
    name: str
    entity_type: str
    classe: str
    level: int
    max_pv: int
    current_pv: int
    force: int
    intelligence: int
    agility: int
    wisdom: int
    defense: int
    max_pa: int
    current_pa: int
    max_pm: int
    current_pm: int
    x: int = 0
    y: int = 0
    spells: List[Spell] = field(default_factory=list)
    is_active: bool = False

    @property
    def is_alive(self) -> bool:
        return self.current_pv > 0

    def reset_turn(self):
        self.current_pa = self.max_pa
        self.current_pm = self.max_pm
        self.is_active = False

    def take_damage(self, amount: int) -> int:
        actual_damage = max(1, amount - self.defense // 2)
        self.current_pv -= actual_damage
        return actual_damage

    def heal(self, amount: int):
        self.current_pv = min(self.max_pv, self.current_pv + amount)

    def move(self, dx: int, dy: int, grid_size: int) -> bool:
        new_x = self.x + dx
        new_y = self.y + dy
        if (0 <= new_x < grid_size and 0 <= new_y < grid_size and
            self.current_pm >= 1):
            self.x = new_x
            self.y = new_y
            self.current_pm -= 1
            return True
        return False

    def get_color(self) -> Tuple[int, int, int]:
        CLASS_COLORS = {
            "Tank": (0, 100, 200),
            "Assassin": (200, 0, 0),
            "Chasseur": (0, 200, 0),
            "Mage": (150, 0, 200),
            "Support": (255, 200, 0),
            "Heal": (0, 200, 200),
        }
        return CLASS_COLORS.get(self.classe, (100, 100, 100))

@dataclass
class Player(Entity):
    experience: int = 0
    skill_points: int = 0
    stat_points: int = 0

    def attack(self, target: Entity) -> int:
        if self.current_pa < 1:
            return 0
        self.current_pa -= 1
        damage = self.force + random.randint(-2, 2)
        return target.take_damage(damage)

    def cast_spell(self, spell: Spell, target: Entity) -> Optional[str]:
        if not spell.can_cast(self):
            return None

        # CORRECTION : Utilise le coût réel du sort
        self.current_pa -= spell.cost_pa
        self.current_pm -= spell.cost_pm

        if "dégâts" in spell.effect.lower():
            damage_str = spell.effect.split()[0]
            try:
                damage = int(damage_str)
            except:
                damage = 10
            target.take_damage(damage)
            return f"{self.name} lance {spell.name} : {damage} dégâts !"
        elif "restaure" in spell.effect.lower() or "soin" in spell.effect.lower():
            heal_str = spell.effect.split()[1]
            try:
                heal = int(heal_str)
            except:
                heal = 15
            target.heal(heal)
            return f"{self.name} lance {spell.name} : {heal} PV restaurés !"
        else:
            return f"{self.name} lance {spell.name} !"

@dataclass
class Enemy(Entity):
    biome: str = ""
    special_effects: str = ""

    def ai_turn(self, players: List[Player], grid: List[List[Optional[Entity]]]) -> str:
        alive_players = [p for p in players if p.is_alive]
        if not alive_players:
            return f"{self.name} ne peut pas agir."

        if random.random() < 0.7 and self.current_pa >= 1:
            target = random.choice(alive_players)
            damage = self.force + random.randint(-2, 2)
            actual_damage = target.take_damage(damage)
            self.current_pa -= 1
            return f"{self.name} attaque {target.name} : {actual_damage} dégâts !"
        elif self.current_pm >= 1:
            target = random.choice(alive_players)
            dx = 1 if target.x > self.x else -1 if target.x < self.x else 0
            dy = 1 if target.y > self.y else -1 if target.y < self.y else 0
            if dx != 0 or dy != 0:
                self.move(dx, dy, len(grid))
                return f"{self.name} se déplace."
        return f"{self.name} ne fait rien."

class Game:
    def __init__(self, cards_mode: bool = False, headless: bool = False, seed: int = 42):
        pygame.init()
        if headless:
            self.screen = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
        else:
            self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
            pygame.display.set_caption("Prototype Zimut v2 - Combat Tour par Tour")
        self.font = pygame.font.SysFont('Arial', 16)
        self.font_large = pygame.font.SysFont('Arial', 20)
        self.font_title = pygame.font.SysFont('Arial', 28, bold=True)
        self.clock = pygame.time.Clock()

        self.classes_data = self.load_csv("classes.csv")
        self.spells_data = self.load_csv("sorts.csv")
        self.enemies_data = self.load_csv("ennemis.csv")
        self.stuff_data = self.load_csv("stuff.csv")
        self.invocations_data = self.load_csv("invocations.csv")

        self.cards_mode = cards_mode
        self.grid: List[List[Optional[Entity]]] = [[None for _ in range(GRID_SIZE)] for _ in range(GRID_SIZE)]
        self.players: List[Player] = []
        self.enemies: List[Enemy] = []
        self.current_turn = 0
        self.current_player_index = 0
        self.selected_entity: Optional[Entity] = None
        self.selected_spell: Optional[Spell] = None
        self.show_spells = False
        self.game_over = False
        self.victory = False
        self.selected_cell = None

        # État du mode Cartes tactiques
        self.deck: List[Card] = []
        self.hand: List[Card] = []
        self.discard: List[Card] = []
        self.enemy_deck: List[Card] = []
        self.enemy_hand: List[Card] = []
        self.enemy_discard: List[Card] = []
        self.summons: List[Enemy] = []
        self.enemy_summons: List[Enemy] = []
        self.selected_card: Optional[int] = None
        self.summon_control: Optional[Enemy] = None
        self.round_count = 1

        if cards_mode:
            self.init_cards_duel(seed)
        else:
            self.init_entities()

    def load_csv(self, filename: str) -> List[Dict]:
        # Chemin corrigé : remonte d'un niveau pour accéder au dossier data
        script_dir = os.path.dirname(os.path.abspath(__file__))
        data_dir = os.path.join(script_dir, "..", "data")
        filepath = os.path.join(data_dir, filename)
        with open(filepath, 'rb') as f:
            raw = f.read()
        try:
            text = raw.decode('utf-8')
        except UnicodeDecodeError:
            # encodage mixte (ex. invocations.csv : en-tête UTF-8, corps latin-1)
            text = raw.decode('utf-8', errors='replace')
        return [row for row in csv.DictReader(text.splitlines())]

    def init_entities(self):
        player_classes = ["Tank", "Assassin", "Mage"]
        player_positions = [(1, 1), (1, 2), (2, 1)]

        for i, (classe, pos) in enumerate(zip(player_classes, player_positions)):
            class_data = [d for d in self.classes_data if d["Classe"] == classe and d["Niveau"] == "10"]
            if class_data:
                data = class_data[0]
                player = Player(
                    name=f"{classe} Lv10",
                    entity_type="Player",
                    classe=classe,
                    level=10,
                    max_pv=int(data["Vita (PV)"]),
                    current_pv=int(data["Vita (PV)"]),
                    force=int(data["Force (CAC)"]),
                    intelligence=int(data["Intelligence (Magie)"]),
                    agility=int(data["Agilité (Vit. Atk)"]),
                    wisdom=int(data["Sagesse (Précision)"]),
                    defense=int(data["Défense"]),
                    max_pa=int(data["PA"]),
                    current_pa=int(data["PA"]),
                    max_pm=int(data["PM"]),
                    current_pm=int(data["PM"]),
                    x=pos[0],
                    y=pos[1]
                )

                player.spells = []
                for spell_data in self.spells_data:
                    if spell_data["Classe"] == classe and int(spell_data["Niveau requis"]) <= 10:
                        player.spells.append(Spell(
                            name=spell_data["Nom"],
                            classe=spell_data["Classe"],
                            cost_pa=int(spell_data["Coût PA"]),
                            cost_pm=int(spell_data["Coût PM"]),
                            range=int(spell_data["Portée"]),
                            effect=spell_data["Effet"],
                            level_required=int(spell_data["Niveau requis"]),
                            spell_type=spell_data["Type"]
                        ))

                self.players.append(player)
                self.grid[pos[1]][pos[0]] = player

        enemy_types = ["Gobelin", "Squelette", "Loup"]
        enemy_levels = [10, 10, 10]
        enemy_positions = [(8, 8), (8, 7), (7, 8)]

        for i, (enemy_type, level, pos) in enumerate(zip(enemy_types, enemy_levels, enemy_positions)):
            enemy_data = [d for d in self.enemies_data if d["Type"] == enemy_type and d["Niveau"] == str(level)]
            if enemy_data:
                data = enemy_data[0]
                enemy = Enemy(
                    name=f"{enemy_type} Lv{level}",
                    entity_type="Enemy",
                    classe=enemy_type,
                    level=level,
                    max_pv=int(data["PV"]),
                    current_pv=int(data["PV"]),
                    force=int(data["Attaque"]),
                    intelligence=0,
                    agility=int(data["Attaque"]) // 2,
                    wisdom=0,
                    defense=int(data["Défense"]),
                    max_pa=int(data["PA"]),
                    current_pa=int(data["PA"]),
                    max_pm=int(data["PM"]),
                    current_pm=int(data["PM"]),
                    x=pos[0],
                    y=pos[1],
                    biome=data["Biome"],
                    special_effects=data["Effets spéciaux"]
                )
                self.enemies.append(enemy)
                self.grid[pos[1]][pos[0]] = enemy

    def handle_click(self, pos: Tuple[int, int]):
        if self.cards_mode:
            self.handle_click_cards(pos)
            return
        x, y = pos
        col = (x - MARGIN) // CELL_SIZE
        row = (y - MARGIN) // CELL_SIZE

        if not (0 <= col < GRID_SIZE and 0 <= row < GRID_SIZE):
            return

        self.selected_cell = (col, row)
        entity = self.grid[row][col]

        if self.current_turn == 0:
            current_player = self.players[self.current_player_index]

            if entity and entity.entity_type == "Player" and entity == current_player:
                self.selected_entity = entity
                self.show_spells = True
                for p in self.players:
                    p.is_active = False
                current_player.is_active = True
                return

            if (self.selected_entity == current_player and
                not entity and
                current_player.current_pm > 0):
                dx = col - current_player.x
                dy = row - current_player.y
                if abs(dx) + abs(dy) == 1:
                    if current_player.move(dx, dy, GRID_SIZE):
                        self.grid[current_player.y][current_player.x] = current_player
                        self.grid[row][col] = None
                        self.selected_entity = None
                        self.show_spells = False
                return

            if (self.selected_entity == current_player and
                entity and entity.entity_type == "Enemy" and
                current_player.current_pa > 0):
                damage = current_player.attack(entity)
                print(f"{current_player.name} attaque {entity.name} : {damage} dégâts !")
                if not entity.is_alive:
                    self.grid[entity.y][entity.x] = None
                    self.enemies.remove(entity)
                self.selected_entity = None
                self.show_spells = False
                return

            if self.selected_spell and self.selected_entity == current_player:
                if entity and entity.is_alive:
                    result = current_player.cast_spell(self.selected_spell, entity)
                    if result:
                        print(result)
                        if not entity.is_alive and entity.entity_type == "Enemy":
                            self.grid[entity.y][entity.x] = None
                            self.enemies.remove(entity)
                    self.selected_spell = None
                    self.show_spells = False
                    self.selected_entity = None
                return

        self.selected_entity = None
        self.show_spells = False

    def handle_spell_selection(self, spell_index: int):
        current_player = self.players[self.current_player_index]
        if spell_index < len(current_player.spells):
            self.selected_spell = current_player.spells[spell_index]

    def next_turn(self):
        if self.current_turn == 0:
            self.current_turn = 1
            for enemy in self.enemies:
                enemy.reset_turn()
            print("Tour des ennemis...")
        else:
            self.current_turn = 0
            self.current_player_index = 0
            for player in self.players:
                player.reset_turn()
            print("Tour des joueurs...")
            if all(not e.is_alive for e in self.enemies):
                self.victory = True
                self.game_over = True
            elif all(not p.is_alive for p in self.players):
                self.game_over = True

    def enemy_turn(self):
        for enemy in self.enemies:
            if enemy.is_alive:
                result = enemy.ai_turn(self.players, self.grid)
                print(result)
                if not any(p.is_alive for p in self.players):
                    break
        self.next_turn()

    def next_player(self):
        if self.cards_mode:
            self.cards_end_turn()
            return
        self.current_player_index = (self.current_player_index + 1) % len(self.players)
        self.selected_entity = None
        self.show_spells = False
        self.selected_cell = None
        if self.current_player_index == 0:
            self.enemy_turn()

    # ==================== MODE CARTES TACTIQUES ====================

    def build_card_pool(self, classe: str) -> List[Card]:
        cards: List[Card] = []
        for row in self.invocations_data:
            if int(row["Niveau requis"]) <= 10:
                cost = max(2, min(5, int(row["PA"])))
                cards.append(Card(
                    name=f"Invoquer {row['Nom']}", card_type="Invocation", ref=row["Nom"],
                    cost_pa=cost, cost_pm=0, range=SUMMON_RANGE,
                    effect=f"Invoque {row['Nom']}", level_required=int(row["Niveau requis"])
                ))
        for row in self.spells_data:
            if row["Classe"] == classe and int(row["Niveau requis"]) <= 10:
                cards.append(Card(
                    name=row["Nom"], card_type="Sort", ref=row["Nom"],
                    cost_pa=int(row["Coût PA"]), cost_pm=int(row["Coût PM"]),
                    range=int(row["Portée"]), effect=row["Effet"],
                    level_required=int(row["Niveau requis"])
                ))
        return cards

    def build_deck(self, classe: str, rng: random.Random) -> List[Card]:
        pool = self.build_card_pool(classe)
        invocations = [c for c in pool if c.card_type == "Invocation"]
        sorts = [c for c in pool if c.card_type == "Sort"]
        deck: List[Card] = []
        for i in range(6):
            deck.append(invocations[i % len(invocations)])
        for i in range(DECK_SIZE - len(deck)):
            deck.append(sorts[i % len(sorts)])
        rng.shuffle(deck)
        return deck

    def init_cards_duel(self, seed: int = 42):
        rng = random.Random(seed)
        data = next(d for d in self.classes_data if d["Classe"] == "Tank" and d["Niveau"] == "10")
        hero = Player(
            name="Héros (Tank Lv10)", entity_type="Player", classe="Tank", level=10,
            max_pv=int(data["Vita (PV)"]), current_pv=int(data["Vita (PV)"]),
            force=int(data["Force (CAC)"]), intelligence=int(data["Intelligence (Magie)"]),
            agility=int(data["Agilité (Vit. Atk)"]), wisdom=int(data["Sagesse (Précision)"]),
            defense=int(data["Défense"]), max_pa=int(data["PA"]), current_pa=int(data["PA"]),
            max_pm=int(data["PM"]), current_pm=int(data["PM"]), x=1, y=4
        )
        hero.spells = []  # Q2 : la barre de sorts de classe est remplacée par la main de cartes
        self.players.append(hero)
        self.grid[4][1] = hero

        edata = next(d for d in self.enemies_data if d["Type"] == "Gobelin" and d["Niveau"] == "50")
        foe = Enemy(
            name="Héros adverse", entity_type="Enemy", classe="Gobelin", level=50,
            max_pv=int(edata["PV"]), current_pv=int(edata["PV"]), force=int(edata["Attaque"]),
            intelligence=0, agility=0, wisdom=0, defense=int(edata["Défense"]),
            max_pa=int(edata["PA"]), current_pa=int(edata["PA"]), max_pm=int(edata["PM"]),
            current_pm=int(edata["PM"]), x=8, y=4, biome=edata["Biome"], special_effects="-"
        )
        self.enemies.append(foe)
        self.grid[4][8] = foe

        self.deck = self.build_deck("Tank", rng)
        self.enemy_deck = self.build_deck("Mage", rng)
        self.hand = [self.deck.pop() for _ in range(HAND_START)]      # Q3 : main de départ 5
        self.enemy_hand = [self.enemy_deck.pop() for _ in range(HAND_START)]
        self.round_count = 1
        hero.reset_turn()

    def side_state(self, side: str):
        if side == "hero":
            return self.players[0], self.hand, self.discard, self.summons
        return self.enemies[0], self.enemy_hand, self.enemy_discard, self.enemy_summons

    def draw_card(self, side: str) -> Optional[Card]:
        # Q3 : pioche 1 carte par tour ; main max 7, sinon la carte est défaussée
        deck = self.deck if side == "hero" else self.enemy_deck
        hand = self.hand if side == "hero" else self.enemy_hand
        discard = self.discard if side == "hero" else self.enemy_discard
        if not deck:
            print(f"[{side}] Pioche vide !")
            return None
        card = deck.pop()
        if len(hand) >= HAND_MAX:
            discard.append(card)
            print(f"[{side}] Main pleine ({HAND_MAX}) : {card.name} défaussée.")
        else:
            hand.append(card)
        return card

    def make_summon(self, ref: str, owner: Entity, x: int, y: int) -> Enemy:
        row = next(r for r in self.invocations_data if r["Nom"] == ref)
        s = Enemy(
            name=ref, entity_type="Summon", classe="Invocation", level=int(row["Niveau requis"]),
            max_pv=int(row["PV"]), current_pv=int(row["PV"]), force=int(row["Attaque"]),
            intelligence=0, agility=0, wisdom=0, defense=int(row["Défense"]),
            max_pa=int(row["PA"]), current_pa=0, max_pm=int(row["PM"]), current_pm=0,
            x=x, y=y, biome=row["Biome"], special_effects=""
        )
        s.owner = owner
        return s

    def remove_dead(self, entity: Entity):
        for lst in (self.enemies, self.summons, self.enemy_summons):
            if entity in lst:
                lst.remove(entity)
        if 0 <= entity.y < GRID_SIZE and 0 <= entity.x < GRID_SIZE and self.grid[entity.y][entity.x] is entity:
            self.grid[entity.y][entity.x] = None

    def play_card(self, side: str, card_index: int, target=None) -> Optional[str]:
        # Q1 : la carte coûte les PA/PM du héros du camp concerné
        hero, hand, discard, summons = self.side_state(side)
        if card_index >= len(hand):
            return None
        card = hand[card_index]
        if not card.can_play(hero.current_pa, hero.current_pm, hero.level):
            return f"{card.name} : PA/PM ou niveau insuffisant."
        if card.card_type == "Sort" and target is not None and hasattr(target, "x"):
            if ("dégâts" in card.effect.lower() or "dégats" in card.effect.lower()) and dist(hero, target) > card.range:
                return f"{card.name} : cible hors de portée ({card.range})."
        hand.pop(card_index)
        hero.current_pa -= card.cost_pa
        hero.current_pm -= card.cost_pm
        discard.append(card)
        if card.card_type == "Invocation":
            return self.resolve_summon_card(side, card, target)
        return self.resolve_sort_card(side, card, target)

    def resolve_summon_card(self, side: str, card: Card, cell) -> str:
        hero, hand, discard, summons = self.side_state(side)
        if len(summons) >= SUMMON_MAX:
            return f"Maximum de {SUMMON_MAX} invocations actives."
        if cell is None:
            return "Case de pose invalide."
        cx, cy = cell
        if not (0 <= cx < GRID_SIZE and 0 <= cy < GRID_SIZE):
            return "Case hors de la grille."
        if self.grid[cy][cx] is not None:
            return "Case occupée."
        if abs(cx - hero.x) + abs(cy - hero.y) > card.range:
            return f"Case hors de portée ({card.range})."
        s = self.make_summon(card.ref, hero, cx, cy)
        summons.append(s)
        self.grid[cy][cx] = s
        if side == "hero":
            self.summon_control = s  # Q4 : l'invocation agit immédiatement
        return f"{hero.name} invoque {s.name} en ({cx},{cy}) !"

    def resolve_sort_card(self, side: str, card: Card, target) -> str:
        hero = self.players[0] if side == "hero" else self.enemies[0]
        eff = card.effect.lower()
        if ("dégâts" in eff or "dégats" in eff) and target is not None:
            try:
                dmg = int(card.effect.split()[0])
            except (ValueError, IndexError):
                dmg = 10
            actual = target.take_damage(dmg)
            if not target.is_alive:
                self.remove_dead(target)
            self.check_game_over()
            return f"{hero.name} lance {card.name} sur {target.name} : {actual} dégâts !"
        if ("restaure" in eff or "soin" in eff) and target is not None:
            try:
                heal = int(card.effect.split()[1])
            except (ValueError, IndexError):
                heal = 15
            target.heal(heal)
            return f"{hero.name} lance {card.name} : {heal} PV restaurés sur {target.name}."
        return f"{hero.name} lance {card.name} (effet non simulé : {card.effect})."

    def move_entity(self, e: Entity, dx: int, dy: int, pool: Optional[Entity] = None) -> bool:
        pool = pool or e
        nx, ny = e.x + dx, e.y + dy
        if 0 <= nx < GRID_SIZE and 0 <= ny < GRID_SIZE and self.grid[ny][nx] is None and pool.current_pm >= 1:
            self.grid[e.y][e.x] = None
            e.x, e.y = nx, ny
            self.grid[ny][nx] = e
            pool.current_pm -= 1
            return True
        return False

    def summon_attack(self, target: Entity) -> str:
        # Q4 : l'invocation dépense les PA restants du héros
        s = self.summon_control
        hero = self.players[0]
        if not s or not s.is_alive or hero.current_pa < 1 or dist(s, target) != 1:
            return "Attaque d'invocation impossible."
        hero.current_pa -= 1
        actual = target.take_damage(s.force + random.randint(-2, 2))
        if not target.is_alive:
            self.remove_dead(target)
        return f"{s.name} attaque {target.name} : {actual} dégâts (PA restants du héros : {hero.current_pa})."

    def summon_move(self, col: int, row: int) -> str:
        # Q4 : le déplacement de l'invocation dépense les PM restants du héros
        s = self.summon_control
        hero = self.players[0]
        if not s or not s.is_alive:
            return "Aucune invocation contrôlée."
        if abs(col - s.x) + abs(row - s.y) != 1:
            return "Case non adjacente à l'invocation."
        if self.move_entity(s, col - s.x, row - s.y, pool=hero):
            return f"{s.name} se déplace en ({col},{row}) (PM restants du héros : {hero.current_pm})."
        return "Déplacement d'invocation impossible."

    def check_game_over(self) -> bool:
        if not self.cards_mode:
            return False
        hero = self.players[0] if self.players else None
        foe = self.enemies[0] if self.enemies else None
        if foe is None or not foe.is_alive:
            self.game_over = True
            self.victory = True
        elif hero is None or not hero.is_alive:
            self.game_over = True
            self.victory = False
        return self.game_over

    def free_cell_near(self, e: Entity, rng: int):
        cells = [(cx, cy) for cy in range(GRID_SIZE) for cx in range(GRID_SIZE)
                 if self.grid[cy][cx] is None and abs(cx - e.x) + abs(cy - e.y) <= rng]
        return random.choice(cells) if cells else None

    def nearest_in_range(self, e: Entity, targets: List[Entity], rng: int):
        best, best_d = None, 999
        for t in targets:
            d = abs(t.x - e.x) + abs(t.y - e.y)
            if d < best_d:
                best, best_d = t, d
        return best if best is not None and best_d <= rng else None

    def summon_strike(self, side: str) -> List[str]:
        # Q4 : les invocations du camp attaquent avec les PA restants du héros du camp
        hero, hand, discard, summons = self.side_state(side)
        foes = ([e for e in self.enemies if e.is_alive] + [s for s in self.enemy_summons if s.is_alive]) \
            if side == "hero" else ([p for p in self.players if p.is_alive] + [s for s in self.summons if s.is_alive])
        logs: List[str] = []
        for s in list(summons):
            if not s.is_alive:
                continue
            for t in foes:
                if t.is_alive and dist(s, t) == 1 and hero.current_pa >= 1:
                    hero.current_pa -= 1
                    actual = t.take_damage(s.force + random.randint(-2, 2))
                    if not t.is_alive:
                        self.remove_dead(t)
                    logs.append(f"{s.name} attaque {t.name} : {actual} dégâts.")
                    break
        return logs

    def auto_play_side(self, side: str) -> List[str]:
        hero, hand, discard, summons = self.side_state(side)
        foes = ([e for e in self.enemies if e.is_alive] + [s for s in self.enemy_summons if s.is_alive]) \
            if side == "hero" else ([p for p in self.players if p.is_alive] + [s for s in self.summons if s.is_alive])
        logs: List[str] = []
        if not hero.is_alive:
            return logs
        for _ in range(8):
            if hero.current_pa <= 0:
                break
            choice = None
            for i, card in enumerate(hand):
                if not card.can_play(hero.current_pa, hero.current_pm, hero.level):
                    continue
                eff = card.effect.lower()
                if card.card_type == "Invocation" and len(summons) < SUMMON_MAX:
                    cell = self.free_cell_near(hero, card.range)
                    if cell:
                        choice = (i, card, cell)
                        break
                if "dégâts" in eff or "dégats" in eff:
                    tgt = self.nearest_in_range(hero, foes, card.range)
                    if tgt:
                        choice = (i, card, tgt)
                        break
                if "restaure" in eff and hero.current_pv < hero.max_pv * 0.7:
                    choice = (i, card, hero)
                    break
            if choice is None:
                break
            i, card, tgt = choice
            msg = self.play_card(side, i, tgt)
            if msg:
                logs.append(msg)
            if card.card_type == "Invocation":
                logs += self.summon_strike(side)
        logs += self.summon_strike(side)
        if hero.current_pm > 0 and foes:
            tgt = min(foes, key=lambda t: abs(t.x - hero.x) + abs(t.y - hero.y))
            dx = 1 if tgt.x > hero.x else -1 if tgt.x < hero.x else 0
            dy = 1 if tgt.y > hero.y else -1 if tgt.y < hero.y else 0
            if self.move_entity(hero, dx, 0) if dx else self.move_entity(hero, 0, dy):
                logs.append(f"{hero.name} se rapproche en ({hero.x},{hero.y}).")
        return logs

    def enemy_cards_turn(self):
        foe = self.enemies[0]
        if not foe.is_alive:
            return
        foe.reset_turn()
        self.draw_card("enemy")  # Q3 : pioche 1 carte par tour
        for msg in self.auto_play_side("enemy"):
            print(f"   [adverse] {msg}")
        self.check_game_over()

    def cards_end_turn(self):
        if self.game_over:
            return
        self.enemy_cards_turn()
        if self.check_game_over():
            return
        self.round_count += 1
        hero = self.players[0]
        hero.reset_turn()
        if self.round_count > 1:
            self.draw_card("hero")  # Q3 : pioche 1 carte au début du tour du héros
        self.summon_control = None
        self.selected_card = None

    def simulate(self, rounds: int = 30) -> int:
        print(f"=== Simulation mode Cartes tactiques : {rounds} manches max ===")
        for r in range(1, rounds + 1):
            if self.check_game_over():
                break
            self.round_count = r
            hero = self.players[0]
            hero.reset_turn()
            if r > 1:
                self.draw_card("hero")
            print(f"--- Manche {r} : héros PV {hero.current_pv}/{hero.max_pv} PA {hero.current_pa} PM {hero.current_pm} "
                  f"| main {len(self.hand)} pioche {len(self.deck)} défausse {len(self.discard)}")
            for msg in self.auto_play_side("hero"):
                print("   ", msg)
            if self.check_game_over():
                break
            self.enemy_cards_turn()
        for side, deck, hand, disc in (("hero", self.deck, self.hand, self.discard),
                                       ("enemy", self.enemy_deck, self.enemy_hand, self.enemy_discard)):
            assert len(hand) <= HAND_MAX, f"main > {HAND_MAX} ({side})"
            assert len(deck) + len(hand) + len(disc) == DECK_SIZE, f"cartes perdues ({side})"
        hero, foe = self.players[0], self.enemies[0]
        result = "VICTOIRE" if self.victory else "DÉFAITE" if self.game_over else "INACHEVÉ"
        print(f"=== Résultat : {result} — héros PV {hero.current_pv}/{hero.max_pv}, "
              f"adverse PV {foe.current_pv}/{foe.max_pv}, manches {self.round_count}, "
              f"main {len(self.hand)}, défausse {len(self.discard)} ===")
        print("Invariants OK : main <= 7, 20 cartes conservées par deck.")
        return 0

    def handle_card_key(self, k: int):
        if 1 <= k <= len(self.hand):
            self.selected_card = None if self.selected_card == k - 1 else k - 1

    def hand_card_rect(self, i: int) -> pygame.Rect:
        w, h = 150, 80
        return pygame.Rect(MARGIN + i * (w + 8), HAND_Y, w, h)

    def handle_click_cards(self, pos: Tuple[int, int]):
        x, y = pos
        if y >= HAND_Y:
            for i in range(len(self.hand)):
                if self.hand_card_rect(i).collidepoint(pos):
                    self.handle_card_key(i + 1)
                    return
            return
        col = (x - MARGIN) // CELL_SIZE
        row = (y - MARGIN) // CELL_SIZE
        if not (0 <= col < GRID_SIZE and 0 <= row < GRID_SIZE):
            return
        self.selected_cell = (col, row)
        cell_entity = self.grid[row][col]
        hero = self.players[0]

        # Q4 : contrôle de l'invocation invoquée (PA/PM restants du héros)
        if self.summon_control and self.summon_control.is_alive:
            s = self.summon_control
            if cell_entity is not None and cell_entity.entity_type == "Enemy" and dist(s, cell_entity) == 1:
                print(self.summon_attack(cell_entity))
                self.check_game_over()
                return
            if cell_entity is None and abs(col - s.x) + abs(row - s.y) == 1:
                print(self.summon_move(col, row))
                return
            self.summon_control = None

        if self.selected_card is not None and self.selected_card < len(self.hand):
            card = self.hand[self.selected_card]
            if card.card_type == "Invocation":
                if cell_entity is None:
                    msg = self.play_card("hero", self.selected_card, (col, row))
                    print(msg)
                    if msg and "invoque" in msg.lower() and self.summons:
                        self.summon_control = self.summons[-1]
                    self.check_game_over()
                    self.selected_card = None
                return
            if cell_entity is not None and cell_entity.is_alive:
                msg = self.play_card("hero", self.selected_card, cell_entity)
                print(msg)
                self.check_game_over()
                self.selected_card = None
            return

        # Déplacement du héros avec ses PM
        if cell_entity is None and hero.current_pm > 0:
            dx = col - hero.x
            dy = row - hero.y
            if abs(dx) + abs(dy) == 1:
                self.move_entity(hero, dx, dy)

    def draw_ui_cards(self):
        hero = self.players[0]
        mode_text = f"Mode Cartes tactiques — Manche {self.round_count}"
        self.screen.blit(self.font_large.render(mode_text, True, PURPLE), (SCREEN_WIDTH - 340, 20))
        info = f"Héros: {hero.name} | PV {hero.current_pv}/{hero.max_pv} | PA {hero.current_pa}/{hero.max_pa} | PM {hero.current_pm}/{hero.max_pm}"
        self.screen.blit(self.font.render(info, True, BLACK), (MARGIN, SCREEN_HEIGHT - 70))
        counts = f"Pioche {len(self.deck)} | Main {len(self.hand)}/{HAND_MAX} | Défausse {len(self.discard)}"
        self.screen.blit(self.font.render(counts, True, DARK_GRAY), (MARGIN, SCREEN_HEIGHT - 48))
        if self.summon_control and self.summon_control.is_alive:
            hint = f"Invocation {self.summon_control.name} : ennemi adjacent = 1 PA, case adjacente = 1 PM (pool du héros)."
            self.screen.blit(self.font.render(hint, True, GREEN), (MARGIN, SCREEN_HEIGHT - 26))
        next_button = pygame.Rect(SCREEN_WIDTH - 150, SCREEN_HEIGHT - 45, 120, 40)
        pygame.draw.rect(self.screen, GREEN, next_button)
        pygame.draw.rect(self.screen, BLACK, next_button, 2)
        self.screen.blit(self.font.render("Fin de tour", True, BLACK), (next_button.x + 10, next_button.y + 12))
        return next_button

    def draw_hand(self):
        hero = self.players[0]
        title = self.font.render("Main (touches 1-7, puis clique une cible sur la grille)", True, BLACK)
        self.screen.blit(title, (MARGIN, HAND_Y - 20))
        for i, card in enumerate(self.hand):
            r = self.hand_card_rect(i)
            playable = card.can_play(hero.current_pa, hero.current_pm, hero.level)
            bg = (255, 255, 220) if playable else (210, 210, 210)
            pygame.draw.rect(self.screen, bg, r)
            border = YELLOW if self.selected_card == i else BLACK
            pygame.draw.rect(self.screen, border, r, 2 if self.selected_card == i else 1)
            color = BLACK if playable else DARK_GRAY
            self.screen.blit(self.font.render(f"{i+1}. {card.name[:18]}", True, color), (r.x + 4, r.y + 4))
            self.screen.blit(self.font.render(f"{card.card_type[:4]} PA:{card.cost_pa} PM:{card.cost_pm} por:{card.range}", True, color), (r.x + 4, r.y + 24))
            self.screen.blit(self.font.render(card.effect[:26], True, DARK_GRAY), (r.x + 4, r.y + 44))

    def draw_grid(self):
        for row in range(GRID_SIZE):
            for col in range(GRID_SIZE):
                rect = pygame.Rect(
                    MARGIN + col * CELL_SIZE,
                    MARGIN + row * CELL_SIZE,
                    CELL_SIZE,
                    CELL_SIZE
                )
                color = LIGHT_GRAY if (row + col) % 2 == 0 else GRAY
                pygame.draw.rect(self.screen, color, rect)
                pygame.draw.rect(self.screen, BLACK, rect, 1)

                if self.selected_cell == (col, row):
                    pygame.draw.rect(self.screen, YELLOW, rect, 2)

                entity = self.grid[row][col]
                if entity:
                    self.draw_entity(entity, rect)

    def draw_entity(self, entity: Entity, rect: pygame.Rect):
        color = entity.get_color()
        center_x = rect.centerx
        center_y = rect.centery
        radius = CELL_SIZE // 3

        pygame.draw.circle(self.screen, color, (center_x, center_y), radius)

        border_color = BLUE if entity.entity_type == "Player" else GREEN if entity.entity_type == "Summon" else RED
        pygame.draw.circle(self.screen, border_color, (center_x, center_y), radius, 2)

        # Surligner le personnage actif
        if (entity == self.players[self.current_player_index] and 
            self.current_turn == 0 and 
            entity.entity_type == "Player"):
            pygame.draw.circle(self.screen, YELLOW, (center_x, center_y), radius + 8, 3)

        # Barre de PV
        pv_percentage = entity.current_pv / entity.max_pv
        bar_width = CELL_SIZE - 10
        bar_height = 5
        pygame.draw.rect(self.screen, DARK_GRAY, (rect.x + 5, rect.y + 5, bar_width, bar_height))
        bar_color = GREEN if pv_percentage > 0.5 else ORANGE if pv_percentage > 0.25 else RED
        pygame.draw.rect(self.screen, bar_color, (rect.x + 5, rect.y + 5, bar_width * pv_percentage, bar_height))

        # Afficher le niveau
        level_text = self.font.render(str(entity.level), True, BLACK)
        self.screen.blit(level_text, (center_x - 5, center_y - 10))

        # Afficher PA/PM pour le personnage actif
        if (entity == self.players[self.current_player_index] and 
            self.current_turn == 0 and 
            entity.entity_type == "Player"):
            pa_text = self.font.render(f"PA:{entity.current_pa}/{entity.max_pa}", True, BLACK)
            pm_text = self.font.render(f"PM:{entity.current_pm}/{entity.max_pm}", True, BLACK)
            self.screen.blit(pa_text, (center_x - 25, center_y + radius + 10))
            self.screen.blit(pm_text, (center_x - 25, center_y + radius + 30))

    def draw_ui(self):
        if self.cards_mode:
            return self.draw_ui_cards()
        turn_text = "Tour des joueurs" if self.current_turn == 0 else "Tour des ennemis"
        turn_color = BLUE if self.current_turn == 0 else RED
        turn_surface = self.font_large.render(turn_text, True, turn_color)
        self.screen.blit(turn_surface, (SCREEN_WIDTH - 200, 20))

        if self.current_turn == 0:
            current_player = self.players[self.current_player_index]
            player_info = f"Joueur: {current_player.name} | PV: {current_player.current_pv}/{current_player.max_pv}"
            player_surface = self.font.render(player_info, True, BLACK)
            self.screen.blit(player_surface, (MARGIN, SCREEN_HEIGHT - 80))

            instructions = "Sélectionne ton personnage pour voir ses actions."
            instr_surface = self.font.render(instructions, True, DARK_GRAY)
            self.screen.blit(instr_surface, (MARGIN, SCREEN_HEIGHT - 50))

            next_button = pygame.Rect(SCREEN_WIDTH - 150, SCREEN_HEIGHT - 50, 120, 40)
            pygame.draw.rect(self.screen, GREEN, next_button)
            pygame.draw.rect(self.screen, BLACK, next_button, 2)
            button_text = self.font.render("Fin de tour", True, BLACK)
            self.screen.blit(button_text, (next_button.x + 10, next_button.y + 10))
            return next_button
        return None

    def draw_spells(self):
        if not self.show_spells or not self.selected_entity:
            return

        current_player = self.players[self.current_player_index]
        if self.selected_entity != current_player:
            return

        # Position à DROITE de la grille
        spell_panel_width = 300
        spell_panel = pygame.Rect(
            SCREEN_WIDTH - spell_panel_width - 20,
            MARGIN,
            spell_panel_width,
            SCREEN_HEIGHT - 2 * MARGIN
        )

        pygame.draw.rect(self.screen, (255, 255, 255, 220), spell_panel)
        pygame.draw.rect(self.screen, BLACK, spell_panel, 2)

        title = self.font_large.render("Sorts disponibles", True, BLACK)
        self.screen.blit(title, (spell_panel.x + 10, spell_panel.y + 10))

        y_offset = spell_panel.y + 40
        for i, spell in enumerate(current_player.spells[:10]):
            can_cast = spell.can_cast(current_player)
            color = BLACK if can_cast else DARK_GRAY
            spell_text = self.font.render(
                f"{i+1}. {spell.name} (PA:{spell.cost_pa}, PM:{spell.cost_pm})",
                True,
                color
            )
            self.screen.blit(spell_text, (spell_panel.x + 10, y_offset))
            y_offset += 25

    def draw_game_over(self):
        overlay = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT), pygame.SRCALPHA)
        overlay.fill((0, 0, 0, 180))
        self.screen.blit(overlay, (0, 0))

        if self.victory:
            text = "VICTOIRE !"
            color = GREEN
        else:
            text = "DÉFAITE..."
            color = RED

        game_over_text = self.font_title.render(text, True, color)
        text_rect = game_over_text.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2))
        self.screen.blit(game_over_text, text_rect)

        restart_text = self.font_large.render("Appuyez sur R pour recommencer", True, WHITE)
        restart_rect = restart_text.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2 + 60))
        self.screen.blit(restart_text, restart_rect)

    def reset_game(self):
        self.grid = [[None for _ in range(GRID_SIZE)] for _ in range(GRID_SIZE)]
        self.players = []
        self.enemies = []
        self.current_turn = 0
        self.current_player_index = 0
        self.selected_entity = None
        self.selected_spell = None
        self.show_spells = False
        self.game_over = False
        self.victory = False
        self.selected_cell = None
        self.deck = []; self.hand = []; self.discard = []
        self.enemy_deck = []; self.enemy_hand = []; self.enemy_discard = []
        self.summons = []; self.enemy_summons = []
        self.selected_card = None; self.summon_control = None; self.round_count = 1
        if self.cards_mode:
            self.init_cards_duel()
        else:
            self.init_entities()

    def run(self):
        running = True
        next_button = None

        while running:
            self.screen.fill(WHITE)

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False

                elif event.type == pygame.MOUSEBUTTONDOWN:
                    if event.button == 1:
                        pos = pygame.mouse.get_pos()
                        if next_button and next_button.collidepoint(pos):
                            self.next_player()
                        else:
                            self.handle_click(pos)

                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        running = False
                    elif event.key == pygame.K_r and self.game_over:
                        self.reset_game()
                    elif self.cards_mode and pygame.K_1 <= event.key <= pygame.K_7:
                        self.handle_card_key(event.key - pygame.K_0)
                    elif event.key == pygame.K_1 and self.show_spells:
                        self.handle_spell_selection(0)
                    elif event.key == pygame.K_2 and self.show_spells:
                        self.handle_spell_selection(1)
                    elif event.key == pygame.K_3 and self.show_spells:
                        self.handle_spell_selection(2)
                    elif event.key == pygame.K_4 and self.show_spells:
                        self.handle_spell_selection(3)
                    elif event.key == pygame.K_5 and self.show_spells:
                        self.handle_spell_selection(4)
                    elif event.key == pygame.K_SPACE:
                        self.next_player()

            self.draw_grid()
            next_button = self.draw_ui()
            if self.cards_mode:
                self.draw_hand()
            else:
                self.draw_spells()

            if self.game_over:
                self.draw_game_over()

            pygame.display.flip()
            self.clock.tick(60)

        pygame.quit()
        sys.exit()

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Prototype Zimut v2")
    parser.add_argument("--cards", action="store_true",
                        help="mode Cartes tactiques : duel héros contre héros adverse piloté par des decks")
    parser.add_argument("--simulate", type=int, default=0, metavar="N",
                        help="simule N manches du mode Cartes tactiques sans affichage (test headless)")
    args = parser.parse_args()
    if args.simulate:
        os.environ.setdefault("SDL_VIDEODRIVER", "dummy")
        os.environ.setdefault("SDL_AUDIODRIVER", "dummy")
        game = Game(cards_mode=True, headless=True)
        sys.exit(game.simulate(args.simulate))
    game = Game(cards_mode=args.cards)
    game.run()