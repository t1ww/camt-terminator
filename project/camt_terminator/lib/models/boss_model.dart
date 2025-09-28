// project\camt_terminator\lib\models\boss_model.dart
import 'package:camt_terminator/models/card.dart';
import 'package:camt_terminator/models/deck.dart';
import 'package:camt_terminator/models/player_model.dart';

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