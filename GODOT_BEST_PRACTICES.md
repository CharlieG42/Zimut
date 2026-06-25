# Godot Best Practices - Guide Complet
Basé sur l'analyse comparative Claude vs Vibe - Projet WildZimut
Dernière mise à jour : 25 juin 2026

---

## Table des Matières
1. [Architecture Logicielle](#architecture-logicielle)
2. [Détection de Clic & Géométrie](#détection-de-clic--géométrie)
3. [Typage & Qualité de Code](#typage--qualité-de-code)
4. [Gestion des Signaux](#gestion-des-signaux)
5. [Gameplay & Logique Métier](#gameplay--logique-métier)
6. [Rendu Visuel & UX](#rendu-visuel--ux)

---

## Architecture Logicielle

### Règle d'Or : 1 Fichier = 1 Responsabilité

A ÉVITER : Tout dans un seul fichier GameManager.gd (600+ lignes)

RECOMMANDÉ : Architecture modulaire avec 8 fichiers spécialisés

scripts/
- GameManager.gd    # Logique métier principale
- GridManager.gd    # Gestion de la grille
- TurnManager.gd    # Gestion des tours
- EntityManager.gd  # Gestion des entités
- SpellManager.gd   # Gestion des sorts
- UIManager.gd      # Interface utilisateur
- Cell.gd           # Rendu et logique cellule
- Main.gd           # Point d'entrée

Quand séparer ?
- Plus de 200 lignes de code
- Plus de 1 responsabilité distincte
- Code réutilisable

---

## Détection de Clic & Géométrie

### CRITIQUE : Cellules Isométriques (Losanges)

FAUX (erreur fréquente) :
func _input(event):
    if Rect2(Vector2.ZERO, Vector2(CELL_SIZE, CELL_SIZE)).has_point(local_pos):
        emit_signal("cell_clicked", grid_position.x, grid_position.y)

Ne fonctionne PAS pour des losanges !

CORRECT :
func _is_point_in_diamond(point: Vector2) -> bool:
    var cx := CELL_SIZE.x / 2.0
    var cy := CELL_SIZE.y / 2.0
    var hw := CELL_SIZE.x / 2.0
    var hh := CELL_SIZE.y / 2.0
    return (absf(point.x - cx) / hw) + (absf(point.y - cy) / hh) <= 1.0

func _input(event):
    if event is InputEventMouseButton and event.pressed:
        var local_pos = to_local(get_global_mouse_position())
        if _is_point_in_diamond(local_pos):
            emit_signal("cell_clicked", grid_position.x, grid_position.y)

---

## Typage & Qualité de Code

### Règle d'Or : Toujours typer explicitement

A ÉVITER :
func handle_cell_selected(cell_pos):
    var x = cell_pos.x

RECOMMANDÉ :
func handle_cell_selected(x: int, y: int) -> void:
    var target_pos: Vector2i = Vector2i(x, y)
    var target_entity: Dictionary = grid[y][x]

Types à toujours spécifier :
- Vector2i pour les coordonnées
- Dictionary pour les entités
- Array pour les listes
- int / float pour les nombres
- bool pour les booléens
- Color pour les couleurs

---

## Gestion des Signaux

### Règle d'Or : Signature = Émission

ERREUR FRÉQUENTE : Incompatibilité entre signal et méthode

CORRECT :
# Signature compatible avec cell_clicked(x: int, y: int)
func handle_cell_selected(x: int, y: int) -> void:
    var pos: Vector2i = Vector2i(x, y)

### Gestion des connexions

DANGEREUX :
some_signal.disconnect(Callable(self, "some_method"))

SÛR :
# Méthode 1 : Vérifier avant
if some_signal.is_connected(Callable(self, "some_method")):
    some_signal.disconnect(Callable(self, "some_method"))

# Méthode 2 : connect est idempotent
some_signal.connect(Callable(self, "some_method"))

---

## Gameplay & Logique Métier

### Déplacement Multi-cases

RECOMMANDÉ :
func _try_move(player: Dictionary, target_pos: Vector2i) -> void:
    var from_pos: Vector2i = Vector2i(player["x"], player["y"])
    var dist: int = abs(target_pos.x - from_pos.x) + abs(target_pos.y - from_pos.y)
    
    if dist > int(player["current_pm"]):
        message_requested.emit("Pas assez de PM !")
        return
    
    if not _is_valid(target_pos) or grid[target_pos.y][target_pos.x] != null:
        message_requested.emit("Case inaccessible.")
        return
    
    grid[from_pos.y][from_pos.x] = null
    player["x"] = target_pos.x
    player["y"] = target_pos.y
    player["current_pm"] -= dist
    grid[target_pos.y][target_pos.x] = player
    entity_moved.emit(player, from_pos, target_pos)

### Utilisation de match

MODERNE :
match spell_type:
    "CAC":
        var damage: int = calculate_damage(caster, target)
        return "%s attaque : %d dégâts !"
    "Magie":
        var damage: int = caster["intelligence"] + (randi() % 5 - 2)
        return "%s lance un sort : %d dégâts !"
    "Défense":
        target["defense"] = int(float(int(target["defense"]) * 3) / 2.0)
        return "%s se protège !"
    "Soin":
        var heal: int = caster["intelligence"] + (randi() % 5 - 2)
        target["current_pv"] = min(int(target["max_pv"]), int(target["current_pv"]) + heal)
        return "%s soigne : +%d PV !"
    _:
        return "Sort inconnu"

---

## Rendu Visuel & UX

### Barre de Vie avec Code Couleur

func _draw_health_bar(center: Vector2) -> void:
    var max_pv: float = float(entity.get("max_pv", entity.get("current_pv", 1)))
    var cur_pv: float = float(entity.get("current_pv", 0))
    if max_pv <= 0:
        return
    
    var ratio: float = clampf(cur_pv / max_pv, 0.0, 1.0)
    var bar_w: float = 32.0
    var bar_pos: Vector2 = center + Vector2(-bar_w * 0.5, 20.0)
    
    draw_rect(Rect2(bar_pos, Vector2(bar_w, 5)), Color(0, 0, 0, 0.7), true)
    
    var fill_color: Color = Color(0.2, 0.9, 0.2)
    if ratio < 0.5:
        fill_color = Color(0.95, 0.75, 0.1)
    if ratio < 0.25:
        fill_color = Color(0.95, 0.15, 0.1)
    
    draw_rect(Rect2(bar_pos, Vector2(bar_w * ratio, 5)), fill_color, true)

### Indicateur de Tour Actif

if entity_type == "Player" and (highlighted or entity.get("is_active", false)):
    var tip: Vector2 = center + Vector2(0, -32)
    draw_line(tip + Vector2(-7, 8), tip, Color(1.0, 1.0, 0.3), 2.5)
    draw_line(tip + Vector2(7, 8), tip, Color(1.0, 1.0, 0.3), 2.5)

---

## Checklist avant Commit

### Critique (Bloquant)
- [ ] Détection de clic utilise la bonne géométrie
- [ ] Signatures des méthodes correspondent aux signaux
- [ ] Pas de disconnect sans vérification is_connected
- [ ] Pas de variables non typées dans les fonctions publiques
- [ ] Le jeu ne crash pas au démarrage

### Important (Amélioration)
- [ ] Architecture modulaire
- [ ] Typage explicite partout
- [ ] Feedback visuel pour toutes les actions
- [ ] Gestion des erreurs
- [ ] Code commenté

### Bonus (Qualité)
- [ ] Utilisation de match au lieu de if/elif
- [ ] Fonctions helper pour le code répété
- [ ] Constantes pour les valeurs magiques
- [ ] Signaux bien nommés

---

Document créé le 25 juin 2026 - Projet WildZimut