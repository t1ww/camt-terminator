import 'package:flutter/material.dart';
import '../../models/deck_model.dart';
import '../../models/card_model.dart' as game;      // ✅ correct file & alias
import '../../data/deck_data.dart';           // uses AttackCard/DefenseCard

class CombatScreen extends StatefulWidget {
  const CombatScreen({super.key});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  late Deck deck;
  int turn = 0;
  List<game.Card> hand = [];

  @override
  void initState() {
    super.initState();
    deck = createShuffledCoreDeck(); // 76 cards (ATK/DEF), shuffled
  }

  void _draw() {
    final n = (turn == 0) ? 5 : 3;
    final drawn = deck.draw(n, includeConsumables: false); // draw only ATK/DEF
    if (drawn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deck is empty — press Reset')),
      );
      return;
    }
    setState(() {
      turn++;
      hand = drawn;
    });
  }

  void _reset() {
    setState(() {
      deck = createShuffledCoreDeck();
      turn = 0;
      hand = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/combat_background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // back
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),

          // show current hand as rectangles with ATK/DEF + power
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: hand.map((c) => _CardRect(label: _labelFor(c))).toList(),
              ),
            ),
          ),

          // controls
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _draw,
                        child: Text(turn == 0 ? 'Draw 5' : 'Draw 3'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _reset,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _labelFor(game.Card c) {
    if (c is game.AttackCard) return 'ATK ${c.power}';
    if (c is game.DefenseCard) return 'DEF ${c.power}';
    // fallback for any future type
    try {
      final dynamic dyn = c;
      if (dyn.name is String) return dyn.name as String;
    } catch (_) {}
    return 'Card';
  }
}

class _CardRect extends StatelessWidget {
  final String label;
  const _CardRect({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
