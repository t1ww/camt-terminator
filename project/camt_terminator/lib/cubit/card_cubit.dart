// project\camt_terminator\lib\cubit\card_cubit.dart
import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:camt_terminator/models/boss_model.dart';

class CardCubit {
  void resolveCard(Card card, {Player? player, Boss? boss}) {
    if (card is AttackCard && player != null) {
      player.takeDamage(card.power);
    } else if (card is DefenseCard && boss != null) {
      // Example: reduce damage taken by boss or other logic
    } else if (card is MedkitCard && player != null) {
      card.use(player);
    } else if (card is ShotgunCard && boss != null && player != null) {
      card.use(player, boss);
    }
  }

  /// Helper to play multiple cards
  void playCards(List<Card> cards, {Player? player, Boss? boss}) {
    for (final card in cards) {
      resolveCard(card, player: player, boss: boss);
    }
  }
}
