// project\camt_terminator\lib\data\boss_data.dart
import 'package:camt_terminator/cubit/card_cubit.dart';
import 'package:camt_terminator/cubit/game_cubit.dart';
import 'package:camt_terminator/models/boss_model.dart';
import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart' hide Card;

class PlubBoss extends Boss {
  PlubBoss()
    : super(
        id: "boss_plub",
        name: "Plub",
        hp: ValueNotifier(26),
        maxHp: 26,
        weapon: "Tarot cards",
        ability: "Copy player's playing cards every 5 turns and play them",
      );

  int turnCounter = 0;

  @override
  List<Card> useAbility(Player player) {
    if (++turnCounter >= 5) {
      turnCounter = 0;
      final copied = CardCubit.I.selectedCardsNotifier.value.take(3).toList();
      return copied;
    }
    return [];
  }

  @override
  List<Card> playCards() {
    useAbility(GameCubit.I.player);
    return handlePlayCard();
  }
}

class ConfirmBoss extends Boss {
  ConfirmBoss()
    : super(
        id: "boss_confirm",
        name: "Confirm",
        hp: ValueNotifier(23),
        maxHp: 23,
        weapon: "Pencil",
        ability: "Shuffle player's playing hand",
      );

  @override
  void useAbility(Player player) {
    // handled in cubit/card_cubit.dart line 123
  }
}

class TewBoss extends Boss {
  TewBoss()
    : super(
        id: "boss_tew",
        name: "Tew",
        hp: ValueNotifier(20),
        maxHp: 20,
        weapon: "Longbow",
        ability: "Play attack cards twice",
      );

  @override
  void useAbility(Player player) {
    // Handled in services/combat_resolver.dart
  }
}

class PartyBoss extends Boss {
  PartyBoss()
    : super(
        id: "boss_party",
        name: "Party",
        hp: ValueNotifier(29),
        maxHp: 29,
        weapon: "Hammer",
        ability: "Play 4 cards",
        maxPlayingCardsPerTurn: 4, // <-- Ability is here.
      );

  @override
  void useAbility(Player player) {
    // Party has no active "ability", just its 4-card playstyle
  }
}

final allBosses = [PlubBoss(), ConfirmBoss(), TewBoss(), PartyBoss()];

List<Boss> freshBosses() => [PlubBoss(), ConfirmBoss(), TewBoss(), PartyBoss()];
