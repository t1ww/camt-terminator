# CAMT Terminator - System Architecture & Project Structure

This document describes the **project structure**, **data layer**, and **Cubit/Bloc architecture** for CAMT Terminator.

---

## Project Resource Tree

```
CAMT_Terminator/
│
├─ lib/
│  ├─ main.dart <-------------------- # Entry point
│  │
│  ├─ ui/
│  │  ├─ screens/
│  │  │  ├─ game_screen.dart
│  │  │  └─ combat_screen.dart
│  │  └─ widgets/
│  │     ├─ card_widget.dart
│  │     ├─ hp_bar.dart
│  │     └─ consumable_widget.dart
│  │
│  ├─ cubit/
│  │  ├─ game_cubit.dart
│  │  └─ card_cubit.dart
│  │
│  ├─ models/
│  │  ├─ card.dart <------------------ # Base Card + AttackCard, DefenseCard, ConsumableCard
│  │  ├─ player_model.dart
│  │  └─ boss_model.dart
│  │
│  ├─ services/
│  │  └─ combat_resolver.dart <------- # Resolves combat logic
│  │
│  └─ data/
│     ├─ deck_data.dart <------------- # Contains deck initialization, shuffle, draw, discard
│     └─ boss_data.dart <------------- # Contains all boss definitions and abilities
│
├─ assets/
│  ├─ images/
│  │  ├─ cards/
│  │  └─ bosses/
│  └─ sounds/
│
└─ README.md

```

---

## Data Layer

The **data layer** centralizes all game data, keeping the game logic, UI, and state management separate and organized.

* **deck_data.dart**

  * Contains the full deck composition (Atk, Def, and Consumable cards)
  * Handles shuffle, draw, discard, and reset logic
  * Consumable cards are only available to the player

* **boss_data.dart**

  * Contains all boss definitions, including HP, weapons, abilities
  * Can include AI parameters like attack patterns

**Benefits:**

* Easy to modify decks, bosses, and consumables without touching game logic
* Makes testing simpler
* Clean separation for UI/Cubit

---

### **card.dart**

```dart
abstract class Card {
  final String id;       // Unique identifier
  final String name;     // e.g., "Atk 2", "Shotgun"
  
  Card({required this.id, required this.name});
}

class AttackCard extends Card {
  final int power;

  AttackCard({required String id, required String name, required this.power})
      : super(id: id, name: name);
}

class DefenseCard extends Card {
  final int power;

  DefenseCard({required String id, required String name, required this.power})
      : super(id: id, name: name);
}

class ConsumableCard extends Card {
  final String type;    // 'Heal' or 'Damage'
  final int effectValue;
  int quantity;

  ConsumableCard({
    required String id,
    required String name,
    required this.type,
    required this.effectValue,
    this.quantity = 1,
  }) : super(id: id, name: name);

  bool isAvailable() => quantity > 0;

  void use(Player player) {
    if (quantity <= 0) return;

    if (type == 'Heal') {
      player.hp += effectValue;
      if (player.hp > player.maxHp) player.hp = player.maxHp;
    }
    // For 'Damage' type, handled in CombatResolver

    quantity -= 1;
  }
}
```

---

### **deck.dart**

```dart
class Deck {
  List<Card> cards = [];
  List<Card> discardPile = [];

  Deck({required this.cards});

  int totalCards() => cards.length;

  void shuffle() {
    cards.shuffle();
  }

  List<Card> draw(int count, {bool includeConsumables = true}) {
    List<Card> drawPool = includeConsumables
        ? cards
        : cards.where((c) => c is! ConsumableCard).toList();

    final drawn = drawPool.take(count).toList();
    for (var card in drawn) {
      cards.remove(card);
    }
    return drawn;
  }

  void discard(List<Card> usedCards) {
    discardPile.addAll(usedCards);
  }

  void resetDeck() {
    cards.addAll(discardPile);
    discardPile.clear();
    shuffle();
  }
}
```

**Notes:**

* Consumable cards are now part of the deck, but bosses ignore them.
* Cards can include extra fields like `description` or `imagePath` for UI.

---

### **boss_data.dart**

```dart
class Boss {
  final String id;
  final String name;
  int hp;
  final int maxHp;
  final String weapon;
  final String ability;
  final int abilityPower;       // Optional numeric parameter
  final int maxCardsPerTurn;    // e.g., Party plays 4 cards
  List<Card> currentHand = [];

  Boss({
    required this.id,
    required this.name,
    required this.hp,
    required this.maxHp,
    required this.weapon,
    required this.ability,
    this.abilityPower = 0,
    this.maxCardsPerTurn = 3,
  });

  void drawCards(Deck deck) {
    currentHand = deck.draw(maxCardsPerTurn, includeConsumables: false);
  }

  void useAbility(Player player) {
    // Custom logic per boss type
    // e.g., Plub copies last 3 player cards
  }

  void takeDamage(int damage) {
    hp -= damage;
    if (hp < 0) hp = 0;
  }

  void resetHp() {
    hp = maxHp;
  }
}
```

**Notes:**

* `useAbility()` can be overridden for each boss type.
* `maxCardsPerTurn` allows flexibility for bosses like Party.

---

## Cubit / Bloc Architecture

### Core Layers

#### 1. UI Layer
- Displays:
  - Player and boss HP
  - Card hands
  - Combat results
  - Consumable usage
- Reacts to **Cubit/Bloc state changes**

#### 2. State Management Layer

**GameCubit**
- States:
  - `GameInitial`
  - `PlayerTurn`
  - `BossTurn`
  - `CombatResult`
  - `GameOver`
- Responsibilities:
  - Handle player actions: card selection, consumable usage
  - Trigger boss AI logic
  - Resolve combat via `CombatResolver`
  - Update HP and card hands
  - Emit new states for UI

**CardCubit**
- States:
  - `CardsDrawn`
  - `CardsSelected`
  - `CardsPlayed`
- Responsibilities:
  - Manage deck: shuffle, draw, discard
  - Track remaining cards
  - Validate selected cards

#### 3. Domain / Logic Layer
- **Player**: HP, consumables, selected cards
- **Boss**: HP, abilities, selected cards
- **CombatResolver**: Resolves Atk/Def, nullify mechanic, excess damage
- **DeckManager**: Handles draw/discard, separate player consumables

#### 4. Data Layer
- `deck_data.dart`, `boss_data.dart`, `consumables_data.dart`
- Centralizes all static and dynamic game data

---

## Flow Example

```

UI Event (player chooses cards)
↓
GameCubit emits PlayerTurn state
↓
Player actions processed by Player / DeckManager
↓
CombatResolver calculates damage / effects
↓
Boss AI chooses cards (Boss class)
↓
CombatResolver resolves boss actions
↓
GameCubit emits CombatResult state
↓
UI updates to show results
↓
Check Win/Lose → emit GameOver or next PlayerTurn

```

---

### Notes
- Using **Cubit** is simpler for linear game flow; **Bloc** can be used if event-driven logic is preferred
- Data layer keeps the project modular and maintainable
- UI layer listens to Cubit states, never mutates game logic directly