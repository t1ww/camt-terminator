// lib/widgets/deck_widget.dart
import 'package:camt_terminator/models/deck_model.dart';
import 'package:flutter/material.dart';

class DeckWidget extends StatelessWidget {
  final Deck deck;
  final VoidCallback? onTap; // <-- callback when deck is tapped
  const DeckWidget({super.key, required this.deck, this.onTap});

  final double deckWidth = 72.0;
  final double deckHeight = 128.0;
  final String deckAsset = 'assets/images/deck.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Deck', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap, // <-- call when tapped
          child: Container(
            width: deckWidth,
            height: deckHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Deck background image
                Image.asset(deckAsset, fit: BoxFit.cover),
                // Card count overlay
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${deck.cards.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
