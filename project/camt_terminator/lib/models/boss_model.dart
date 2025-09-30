// project\camt_terminator\lib\models\boss_model.dart
import 'dart:math';

import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:camt_terminator/cubit/card_cubit.dart';

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

  void drawCards(CardCubit cardCubit, {List<Card> exclude = const []}) {
    final toDraw = maxHandsPerTurn - currentHand.length;
    if (toDraw <= 0) return;

    final drawn = cardCubit.deck
        .draw(toDraw, includeConsumables: false)
        .where((c) => !exclude.contains(c))
        .toList();

    currentHand.addAll(drawn);
  }

  List<Card> playCards() {
    final rng = Random();
    final playCount = currentHand.length < maxPlayingCardsPerTurn
        ? currentHand.length
        : maxPlayingCardsPerTurn;

    final playedCards = <Card>[];
    // Play and remove cards from hand [playCount] times
    for (var i = 0; i < playCount; i++) {
      final index = rng.nextInt(currentHand.length);
      playedCards.add(currentHand.removeAt(index));
    }

    // Boss cards should also go to discard pile
    CardCubit.I.deck.discard(playedCards);

    return playedCards;
  }

  void useAbility(Player player);

  void takeDamage(int damage) {
    hp -= damage;
    if (hp < 0) hp = 0;
  }

  void resetHp() {
    hp = maxHp;
  }
}
