# CAMT Terminator

This plan outlines a minimal, playable version of CAMT Terminator designed to be completed in 5 days.

---

## Key Components

### 1. Card System
- Draw and choose cards each turn (5 first turn, 3 after)
- Apply card effects: Attack (Atk), Defense (Def), Consumables (Shotgun, Med Kit)
- Deck management (80 cards)

### 2. Player & Boss Mechanics
- Player HP (50) and boss HP
- Boss abilities (simplified):
  - Plub: copy player cards
  - Tew: double attack
  - Party: extra card per turn
  - Con: optional simplified swap mechanic

### 3. Combat Resolution
- Atk vs Def interactions
- Nullify mechanic (equal Atk)
- Excess damage calculation
- Consumables applied before combat

### 4. UI / Input
- Card selection (3 per turn)
- HP display for player and boss
- Consumable usage

### 5. Game Flow
- Sequential boss battles
- Win: defeat all bosses
- Lose: player HP reaches 0

---

## 5-Day Timeline

| Day | Task |
|-----|------|
| 1 | Implement deck system: draw, choose, and apply card effects |
| 2 | Player mechanics: HP, consumables, basic combat logic |
| 3 | Boss framework: Plub, Tew, Party abilities; basic HP handling |
| 4 | Combat resolution: Atk/Def logic, nullify, excess damage; optional simplified Con ability |
| 5 | UI: card selection, HP display, win/lose logic; basic debugging |

---

## Notes
- Focus on **logic and playability** rather than polish or graphics.
- Consumables and card mechanics can be simplified for prototype.
- Optional: Phase 2 Con ability can be skipped or made simple to save time.

