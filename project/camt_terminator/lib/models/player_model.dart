// project\camt_terminator\lib\models\player_model.dart
import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/cubit/game_cubit.dart';
import 'package:flutter/material.dart' hide Card;

class Player {
  ValueNotifier<int> hp = ValueNotifier(50);
  final ValueNotifier<List<int>> damageEvents = ValueNotifier([]);

  List<Card> hand = [];
  List<Card> deck = [];
  int get maxHp => 50;

  void takeDamage(int damage) {
    // Calculate new hp with clamp
    final newHp = (hp.value - damage).clamp(0, maxHp);
    hp.value = newHp;

    // Record damage events
    damageEvents.value = [...damageEvents.value, damage];
    Future.delayed(const Duration(milliseconds: 800), clearDamageEvents);

    // === Check defeat ===
    if (newHp <= 0) {
      GameCubit.I.onPlayerDefeated();
    }
  }

  void clearDamageEvents() {
    damageEvents.value = [];
  }
}
