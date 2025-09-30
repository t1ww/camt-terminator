# CAMT Terminator – Project Structure & File Responsibilities

This document outlines the **project structure** and the role of each file in the CAMT Terminator game. The architecture follows a **clean separation** between UI, models, services, and data.

---

## Project Resource Tree

```

camt_terminator/
│
├─ lib/
│  ├─ main.dart                  # App entry point, route configuration
│  │
│  ├─ ui/
│  │  ├─ screens/
│  │  │  ├─ menu_screen.dart     # Main menu (start, rules, exit)
│  │  │  ├─ combat_screen.dart   # Core battle screen
│  │  │  ├─ gameover_screen.dart # Shown when player loses/wins
│  │  │  ├─ rules_screen.dart    # Game instructions
│  │  │  └─ dev_screen.dart      # Debug/dev testing entry
│  │  └─ widgets/
│  │     ├─ card_widget.dart       # Card display component
│  │     ├─ hpBar_widget.dart      # HP bar widget for player or boss
│  │     ├─ player_widget.dart     # Player widget (includes HP bar)
│  │     ├─ boss_widget.dart       # Boss widget (includes HP bar)
│  │     └─ deck_widget.dart       # Deck display widget
│  │
│  ├─ cubit/
│  │  ├─ game_cubit.dart         # Manages turn flow & game states
│  │  └─ card_cubit.dart         # Handles deck, draw, discard
│  │
│  ├─ models/
│  │  ├─ card.dart               # Base Card, AttackCard, DefenseCard, ConsumableCard
│  │  ├─ deck.dart               # Deck + discard pile, shuffle/draw logic
│  │  ├─ player_model.dart       # Player state: HP, hand, deck
│  │  └─ boss_model.dart         # Boss state: HP, ability, AI draw
│  │
│  ├─ services/
│  │  └─ combat_resolver.dart    # Resolves battle results (Atk/Def/Nullify)
│  │
│  └─ data/
│     ├─ deck_data.dart          # Deck initialization, card pools
│     └─ boss_data.dart          # Boss definitions, stats, abilities
│
├─ assets/
│  ├─ images/
│  │  ├─ cards/                  # Card sprites
│  │  └─ bosses/                 # Boss sprites
│  └─ sounds/                    # SFX: attack, heal, etc.
│
└─ README.md

```

---

## File Responsibilities

### **lib/main.dart**
- Entry point of the Flutter app.  
- Sets up routes (`/menu`, `/game`, `/rules`, `/gameover`, `/dev`).  
- Configures global app theme.  

---

### **lib/models/card.dart**
- Defines the **base Card class** and three subclasses:
  - `AttackCard`: Has attack power.  
  - `DefenseCard`: Has defense power.  
  - `ConsumableCard`: Has type (`Heal` or `Damage`), effect value, and quantity.  
- `ConsumableCard.use()` applies healing directly to `Player`; damage type is resolved in `CombatResolver`.  

---

### **lib/models/deck.dart**
- Represents the deck system for both player and bosses.  
- Tracks:  
  - `cards`: active draw pile.  
  - `discardPile`: used cards.  
- Provides:  
  - `shuffle()`  
  - `draw(count, includeConsumables)`  
  - `discard()`  
  - `resetDeck()`  

---

### **lib/models/player_model.dart**
- Defines **Player state**:  
  - `hp` (default 50), `maxHp`.  
  - `hand` (cards in play).  
  - `deck` (personal deck instance).  
- Can be extended for consumables, buffs, debuffs, or special attributes.  

---

### **lib/models/boss_model.dart**
- Defines **Boss state**:  
  - `id`, `name`, `hp`, `maxHp`.  
  - `weapon`, `ability`, `abilityPower`.  
  - `maxCardsPerTurn`.  
  - `currentHand`.  
- Provides:  
  - `drawCards(Deck)` → fills boss hand without consumables.  
  - `useAbility(Player)` → custom boss logic.  
  - `takeDamage()` and `resetHp()`.  

---

### **lib/ui/screens/menu_screen.dart**
- Displays **main menu**:  
  - Title with neon-styled text and weapon icons.  
  - Buttons: Start, Rules, Exit.  
  - Footer (version & credits).  
- Visual style:  
  - Neon glow text.  
  - Glassmorphic card panel.  
  - Gradient + starfield background.  

---

### **lib/ui/screens/combat_screen.dart**
- Displays the **combat background** and navigation back button.  
- Future expansion: integrate player/boss HP bars, hands, and card play area.  

---

### **lib/ui/screens/gameover_screen.dart**
- Shown when the game ends (win or lose).  
- Displays result and offers actions: retry, return to menu.  

---

### **lib/ui/screens/rules_screen.dart**
- Provides **instructions and rules** of the game.  
- Static or scrollable text layout.  

---

### **lib/ui/screens/dev_screen.dart**
- Development/debug screen.  
- Can be used to test decks, boss AI, or specific UI components.  

---

### **lib/cubit/game_cubit.dart**
- Manages the **overall game loop**.  
- States: `GameInitial`, `PlayerTurn`, `BossTurn`, `CombatResult`, `GameOver`.  
- Responsibilities:  
  - Handle player actions (card select, consumables).  
  - Trigger boss AI logic.  
  - Call `CombatResolver`.  
  - Emit new states for UI updates.  

---

### **lib/cubit/card_cubit.dart**
- Manages **deck and card state**.  
- States: `CardsDrawn`, `CardsSelected`, `CardsPlayed`.  
- Responsibilities:  
  - Shuffle, draw, and discard cards.  
  - Validate selected cards.  

---

### **lib/services/combat_resolver.dart**
- Core battle resolution logic:  
  - Attack vs defense card comparison.  
  - Apply consumable effects.  
  - Handle nullify mechanics and excess damage.  
- Independent from UI; testable as a pure logic service.  

---

### **lib/data/deck_data.dart**
- Defines **default deck composition**: attack, defense, and consumables.  
- Provides helper functions for deck initialization.  

---

### **lib/data/boss_data.dart**
- Contains **all boss definitions**:  
  - Base stats (HP, weapon).  
  - Abilities (e.g., copy cards, special skills).  
  - AI parameters like draw count or attack patterns.  