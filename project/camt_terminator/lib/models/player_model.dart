// project\camt_terminator\lib\models\player_model.dart
import 'dart:math';

import 'package:camt_terminator/models/card_model.dart';
import 'package:flutter/material.dart' hide Card;

class Player {
  ValueNotifier<int> hp = ValueNotifier(50);
  List<Card> hand = [];
  List<Card> deck = [];
  int get maxHp => 50;

  void takeDamage(int damage) {
    hp.value = max(hp.value - damage, 0);
  }
}
