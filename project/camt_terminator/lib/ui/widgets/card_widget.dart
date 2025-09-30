// lib/widgets/card_widget.dart
import 'package:flutter/material.dart' hide Card;
import 'package:camt_terminator/models/card_model.dart';

class CardWidget extends StatelessWidget {
  final Card card;
  const CardWidget({super.key, required this.card});
  final double cardWidth = 90.0;
  final double cardHeight = 160.0;

  @override
  Widget build(BuildContext context) {
    String itemAsset = '', cardAsset = 'assets/images/cardEmpty.png';
    if (card.power != null) {
      cardAsset = 'assets/images/card${card.power}.png';
    }
    if (card is AttackCard) itemAsset = 'assets/images/knife.png';
    if (card is DefenseCard) itemAsset = 'assets/images/shield.png';
    if (card is MedkitCard) itemAsset = 'assets/images/medkit.png';
    if (card is ShotgunCard) itemAsset = 'assets/images/shotgun.png';

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Card background
          Image.asset(cardAsset, fit: BoxFit.cover),
          // Item sprite on top
          Image.asset(itemAsset, fit: BoxFit.cover),
        ],
      ),
    );
  }
}
