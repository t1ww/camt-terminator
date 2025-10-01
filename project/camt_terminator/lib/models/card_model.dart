// project\camt_terminator\lib\models\card.dart
import 'package:camt_terminator/models/boss_model.dart';
import 'package:camt_terminator/models/player_model.dart';

abstract class Card {
  final String id;       // Unique identifier
  final String name;     // e.g., "Atk 2", "Shotgun"
  final int? power;      // nullable, only attack/defense cards have power

  Card({required this.id, required this.name, this.power});
}

class AttackCard extends Card {
  final int power;

  AttackCard({required super.id, required super.name, required this.power});
}

class DefenseCard extends Card {
  final int power;

  DefenseCard({required super.id, required super.name, required this.power});
}

class ConsumableCard extends Card {
  ConsumableCard({
    required super.id,
    required super.name,
  });
}

class MedkitCard extends ConsumableCard {
  final int healAmount = 5;

  MedkitCard({
    required super.id,
    required super.name,
  });

  void use(Player player) {
    player.hp.value += healAmount;
    if (player.hp.value > player.maxHp) {
      player.hp.value = player.maxHp;
    }
  }
}

class ShotgunCard extends ConsumableCard {
  final int damagePower = 5;

  ShotgunCard({
    required super.id,
    required super.name,
  });

  void use(Player player, Boss boss) {
    boss.takeDamage(damagePower);
  }
}
