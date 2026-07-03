# Zimut ZOE Roadmap

---

## Current Project Status

### Functional and Validated

- Keyboard movement: OK (1 press = 1 movement, blocked by obstacles)
- Character centering: OK (Exact positioning on tiles)
- Resource collection: OK (Berries/water collected after landing on tile)
- State management: OK (can_move, game_over centralized in world.gd)
- Godot 4 typing: OK (Explicit types Vector2i, String, casts)
- Node paths: OK (Direct access + injected references)
- Base UI: OK (Hunger/thirst/turns display + debug)
- Game Over panel: OK (Modal with Restart/Quit buttons)
- Signals: OK (Communication between scripts)
- Touch PC: OK (Mouse emulation activated)

### Known Accepted

- Touch mobile: Double-touch needed - To be revisited later

---

## Next Priority Steps

### 1. Quest System
Objective: Guide player with clear objectives.

To implement:
- Quest structure (title, description, objectives, rewards)
- Progress tracking (3/5 berries collected)
- Auto-validation
- Dedicated UI panel

Files:
- scripts/QuestManager.gd (new)
- scripts/Quest.gd (new)
- Integration in world.gd

### 2. Save Load System
Objective: Save and resume game progress.

To implement:
- New Game: Complete reset
- Save: Store stats, position, quests (JSON or Resource)
- Load: Restore saved data
- UI: Buttons in menu

Files:
- scripts/SaveManager.gd (new)
- scripts/menu.gd (new)
- Integration in game_manager.gd

---

## Architecture

prototype/zoe
- scenes
  - world.tscn
  - menu.tscn (new)
- scripts
  - world.gd (done)
  - player.gd (done)
  - game_manager.gd (done)
  - QuestManager.gd (TODO)
  - SaveManager.gd (TODO)
  - menu.gd (TODO)
- ROADMAP.md (done)

---

## Best Practices

1. Strong typing: Always type variables
2. Direct access: node.property over node.get()
3. Signals: can_move = false BEFORE emit_signal()
4. Coordinates: to_local() + int(floor()) for touch

---

## Timeline

- Quests: 2-3 days - Basic system + 1-2 test quests
- Save/Load: 2-3 days - Functional + menu UI
- Testing: 1-2 days - Full validation

---

Last updated: 02-07-2026