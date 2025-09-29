# CAMT Terminator

## Description: 
- A solo rogue-like game played in vertical.
- both player and boss will draw the cards from the deck, draw 5 for the first turn and 3 for the rest of the game.
- then choose 3 card to be use in combat.

---

## Gameplay Overview

- Both the player and bosses draw cards from a shared deck:
  - First turn: 5 cards
  - After that: draw until you have 5 cards in hand (applies to both player and bosses).
- Players select **3 cards** per combat round.
- The goal: defeat all 4 bosses by reducing their HP to 0 while keeping your own HP above 0.

**Extra note**: when boss draw consumable card, the boss will skip to card under it, leaving the consumable card on top for the player.

---

## Card Types

### 1. Main Cards
- **Attack (Atk)** and **Defense (Def)** cards are the core of combat.
- Each card has a power value that determines its effect:
  - **Attack**: deals damage equal to its power
  - **Defense**: blocks damage equal to its power

### 2. Additional / Consumable Cards (Player Only)
- **Shotgun Card**: instantly deals 7 damage
- **Med Kit Card**: restores 5 HP

### 3. Deck Composition (Total 80 Cards)
- 38 Atk cards: 
  - x10 power 1  
  - x16 power 2  
  - x12 power 3
- 38 Def cards: 
  - x10 power 1  
  - x16 power 2  
  - x12 power 3
- x1 Shotgun card
- x3 Med Kit cards  

**Note:** Bosses cannot draw consumable cards.

---

## Protagonist

**AJ.TUI**
- Equipped with Shotgun and Knife
- HP: 50
- Can use consumables before combat starts
- Draws 5 cards on the first turn, then always draw until 5 cards in hand for subsequent turns.

---

## Bosses

1. **Plub**  
   - HP: 22  
   - Weapon: Tarot cards  
   - Ability: For every 5th rounds played, Plub copies the 3 cards used by the player and plays them in addition, adding up to 6 cards per turn.

2. **Con**  
   - HP: 20  
   - Weapon: Pencil / Finger snap  
   - Ability:  
     - Phase 1 (>20% HP): randomly swaps one of the player’s selected cards before combat starts. (Don't forget to play finger snap sfx.)
     - Phase 2 (≤20% HP): swaps all of the player’s cards. (Make finger snap sfx louder with more echo for impact.)

3. **Tew**  
   - HP: 18  
   - Weapon: Bow  
   - Ability: Attacks twice when using Atk cards.

4. **Party**  
   - HP: 24  
   - Weapon: Hammer  
   - Ability: Can play 4 cards per turn instead of 3.

---

## Game Rules

- Players have **30 seconds** to choose cards each turn.
- Boss HP increases by 1 each time they are defeated.
- **Combat Mechanics:**
  - Attack cards deal damage equal to their power.
  - If both player and boss use Atk cards of equal power, attacks are nullified (parry).
  - If Atk power exceeds Def power, excess damage is applied.
- Consumables can be used **before combat starts**.

---

## Winning & Losing

- **Win:** defeat all 4 bosses  
- **Lose:** HP reaches 0

---

## Notes

- Bosses and players select cards in the same way, but only players can use consumables.
- Strategic use of Def and Atk cards is key to surviving and defeating bosses.

# Read More

## [📝 Development Plan (Deliverable)](md/deliverable.md)
> Step-by-step plan for building CAMT Terminator in 5 days.

## [🏗️ System Architecture](md/sa.md)
> Overview of Cubit/Bloc layers, data structures, and project layout.

## [✨ New Features & Integration](md/new_features.md)
> How Rive animations and just_audio integrate with Cubit, UI, and combat.

## [🎬 Feature Flow Diagram](md/sa_diagram.md)
> Visual Mermaid diagram of the game flow including new features.