// project\camt_terminator\lib\data\boss_data.dart
import 'package:camt_terminator/models/boss_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:flutter/material.dart';

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

  @override
  void useAbility(Player player) {
    // Ability: Copy the 3 playing cards from player's hand
    final copied = player.hand.take(3).toList();
    currentHand.addAll(copied);
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
    // Shuffle player's playing hand when play
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
    // Example ability: just heals itself a bit
    hp.value += 5;
    if (hp.value > maxHp) hp.value = maxHp;
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
    // maybe Party has no active "ability", just its 4-card playstyle
  }
}


final allBosses = [
  PlubBoss(),
  ConfirmBoss(),
  TewBoss(),
  PartyBoss(),
];