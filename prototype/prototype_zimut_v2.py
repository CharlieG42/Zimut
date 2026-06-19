#!/usr/bin/env python3
"""
Prototype Zimut v2 - Combat tour par tour
Corrections :
- Panneau des sorts déplacé à droite
- Personnage actif surligné en jaune
- Bug des PA corrigé (utilise spell.cost_pa/cost_pm)
- Structure pour les points de compétences
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
    def __init__(self):
        pygame.init()
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

        self.init_entities()

    def load_csv(self, filename: str) -> List[Dict]:
        filepath = os.path.join("data", filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            return [row for row in reader]

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
        self.current_player_index = (self.current_player_index + 1) % len(self.players)
        self.selected_entity = None
        self.show_spells = False
        self.selected_cell = None
        if self.current_player_index == 0:
            self.enemy_turn()

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

        border_color = BLUE if entity.entity_type == "Player" else RED
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
            self.draw_spells()

            if self.game_over:
                self.draw_game_over()

            pygame.display.flip()
            self.clock.tick(60)

        pygame.quit()
        sys.exit()

if __name__ == "__main__":
    game = Game()
    game.run()
