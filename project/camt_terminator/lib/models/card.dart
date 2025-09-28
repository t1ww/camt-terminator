// project\camt_terminator\lib\models\card.dart
import 'package:camt_terminator/models/player_model.dart';

abstract class Card {
  final String id;       // Unique identifier
  final String name;     // e.g., "Atk 2", "Shotgun"
  
  Card({required this.id, required this.name});
}

class AttackCard extends Card {
  final int power;

  AttackCard({required String id, required String name, required this.power})
      : super(id: id, name: name);
}

class DefenseCard extends Card {
  final int power;

  DefenseCard({required String id, required String name, required this.power})
      : super(id: id, name: name);
}

class ConsumableCard extends Card {
  final String type;    // 'Heal' or 'Damage'
  final int effectValue;
  int quantity;

  ConsumableCard({
    required String id,
    required String name,
    required this.type,
    required this.effectValue,
    this.quantity = 1,
  }) : super(id: id, name: name);

  bool isAvailable() => quantity > 0;

  void use(Player player) {
    if (quantity <= 0) return;

    if (type == 'Heal') {
      player.hp += effectValue;
      if (player.hp > player.maxHp) player.hp = player.maxHp;
    }
    // For 'Damage' type, handled in CombatResolver

    quantity -= 1;
  }
}