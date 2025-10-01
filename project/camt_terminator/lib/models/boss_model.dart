// project\camt_terminator\lib\models\boss_model.dart
import 'dart:math';

import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:camt_terminator/cubit/card_cubit.dart';
import 'package:flutter/material.dart' hide Card;

abstract class Boss {
  final String id;
  final String name;
  final ValueNotifier<int> hp; // reactive hp
  final int maxHp;
  final String weapon;
  final String ability;
  final int abilityPower;
  final int maxHandsPerTurn;
  final int maxPlayingCardsPerTurn;

  final ValueNotifier<List<int>> damageEvents = ValueNotifier([]);

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

  void drawCards({List<Card> exclude = const []}) {
    final toDraw = maxHandsPerTurn - currentHand.length;
    if (toDraw <= 0) return;

    final drawn = CardCubit.I.deck
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
    hp.value = max(hp.value - damage, 0);
    damageEvents.value = [...damageEvents.value, damage];

    Future.delayed(const Duration(milliseconds: 800), () {
      clearDamageEvents();
    });
  }

  void clearDamageEvents() {
    damageEvents.value = [];
  }

  void resetHp() {
    hp.value = maxHp;
  }
}
