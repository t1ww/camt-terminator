// project\camt_terminator\lib\models\boss_model.dart
import 'dart:math';

import 'package:camt_terminator/cubit/game_cubit.dart';
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

  // Base behavior
  void useAbility(Player player);

  List<Card> handlePlayCard() {
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

  void _handleTakeDamage(int damage) {
    // Set hp
    final newHp = (hp.value - damage).clamp(0, maxHp);
    hp.value = newHp;

    // Set damage events
    damageEvents.value = [...damageEvents.value, damage];
    Future.delayed(const Duration(milliseconds: 800), () {
      clearDamageEvents();
    });

    // === Check defeat ===
    if (newHp <= 0) {
      GameCubit.I.onBossDefeated();
    }
  }

  void _handleDrawCards({List<Card> exclude = const []}) {
    final toDraw = maxHandsPerTurn - currentHand.length;
    if (toDraw <= 0) return;

    var drawn = CardCubit.I.deck
        .draw(toDraw, includeConsumables: false)
        .where((c) => !exclude.contains(c))
        .toList();

    // If nothing drawn but discard has cards → recycle deck
    if (drawn.isEmpty && CardCubit.I.deck.discardPile.isNotEmpty) {
      CardCubit.I.deck.resetDeck();
      drawn = CardCubit.I.deck
          .draw(toDraw, includeConsumables: false)
          .where((c) => !exclude.contains(c))
          .toList();
    }

    if (drawn.isEmpty) return;

    currentHand.addAll(drawn);
  }

  // Public
  // To be overwritten for each bosses
  List<Card> playCards() {
    return handlePlayCard();
  }

  void takeDamage(int damage) {
    _handleTakeDamage(damage);
  }

  void drawCards({List<Card> exclude = const []}) {
    _handleDrawCards(exclude: exclude);
  }

  void clearDamageEvents() {
    damageEvents.value = [];
  }

  void resetHp() {
    hp.value = maxHp;
  }
}
