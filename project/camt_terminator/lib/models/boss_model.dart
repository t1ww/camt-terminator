// project\camt_terminator\lib\models\boss_model.dart
import 'dart:math';

import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/deck_model.dart';
import 'package:camt_terminator/models/player_model.dart';

abstract class Boss {
  final String id;
  final String name;
  int hp;
  final int maxHp;
  final String weapon;
  final String ability;
  final int abilityPower;
  final int maxHandsPerTurn;
  final int maxPlayingCardsPerTurn;

  List<Card> currentHand = [];

  Boss({
    required this.id,
    required this.name,
    required this.hp,
    required this.maxHp,
    required this.weapon,
    required this.ability,
    this.abilityPower = 0,
    this.maxHandsPerTurn = 5,
    this.maxPlayingCardsPerTurn = 3,
  });

  void drawCards(Deck deck) {
    currentHand = deck.draw(maxHandsPerTurn, includeConsumables: false);
  }

  /// Boss plays up to [maxPlayingCardsPerTurn] cards from its hand.
  /// AI logic will be just random for simplicity.
  List<Card> playCards() {
    final rng = Random();

    // how many cards to play this turn
    final playCount = currentHand.length < maxPlayingCardsPerTurn
        ? currentHand.length
        : maxPlayingCardsPerTurn;

    // pick random cards
    final playedCards = <Card>[];
    for (var i = 0; i < playCount; i++) {
      final index = rng.nextInt(currentHand.length);
      playedCards.add(currentHand.removeAt(index));
    }

    return playedCards;
  }

  /// Must be implemented by each specific boss
  void useAbility(Player player);

  void takeDamage(int damage) {
    hp -= damage;
    if (hp < 0) hp = 0;
  }

  void resetHp() {
    hp = maxHp;
  }
}
