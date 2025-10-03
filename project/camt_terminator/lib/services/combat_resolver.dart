// project\camt_terminator\lib\services\combat_resolver.dart
import 'dart:math';

import '../models/card_model.dart';
import '../models/player_model.dart';
import '../models/boss_model.dart';

/// Handles combat logic between player and boss cards
class CombatResolver {
  /// Resolves a round of selected cards from player and boss
  /// - playerCards: the player's selected cards (up to 3)
  /// - bossCards: boss's cards (can be more than 3)
  static void resolveRound({
    required List<Card> playerCards,
    required List<Card> bossCards,
    required Player player,
    required Boss boss,
    required bool isTewBoss,
  }) {
    final maxLen = max(playerCards.length, bossCards.length);

    for (int i = 0; i < maxLen; i++) {
      final playerCard = i < playerCards.length ? playerCards[i] : null;
      final bossCard = i < bossCards.length ? bossCards[i] : null;

      // Both played an attack
      if (playerCard is AttackCard && bossCard is AttackCard) {
        if (playerCard.power == bossCard.power) {
          // Parry: no damage
          continue;
        } else {
          boss.takeDamage(playerCard.power);
          // If Tew, attack twice
          player.takeDamage(bossCard.power);
          if (isTewBoss) player.takeDamage(bossCard.power);
        }
      }
      // Player attack, boss defense
      else if (playerCard is AttackCard && bossCard is DefenseCard) {
        final damage = max(playerCard.power - bossCard.power, 1);
        boss.takeDamage(damage);
      }
      // Boss attack, player defense
      else if (playerCard is DefenseCard && bossCard is AttackCard) {
        var damage = max(bossCard.power - playerCard.power, 1);
        player.takeDamage(damage);
        // If Tew, attack twice
        if (isTewBoss) player.takeDamage(damage);
      }
      // Specials or one-sided plays
      else {
        if (bossCard is AttackCard) {
          player.takeDamage(bossCard.power);
          // If Tew, attack twice
          if (isTewBoss) player.takeDamage(bossCard.power);
        }
        if (playerCard is AttackCard) boss.takeDamage(playerCard.power);
        if (playerCard != null) _resolveSpecial(playerCard, player, boss);
        if (bossCard != null) _resolveSpecial(bossCard, player, boss);
      }
    }
  }

  static void _resolveSpecial(Card card, Player player, Boss boss) {
    if (card is MedkitCard) {
      card.use(player);
    } else if (card is ShotgunCard) {
      card.use(player, boss);
    }
    // Extend for other special cards here
  }
}
