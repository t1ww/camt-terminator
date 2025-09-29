import '../models/card_model.dart' as game;
import '../models/deck_model.dart';

/// Build a deck of 38 ATK + 38 DEF
List<game.Card> buildCoreDeck() {
  final cards = <game.Card>[];

  void addAtk(int power, int count) {
    for (var i = 0; i < count; i++) {
      cards.add(
        game.AttackCard(
          id: 'ATK_${power}_$i',
          name: 'ATK $power',
          power: power,
        ),
      );
    }
  }

  void addDef(int power, int count) {
    for (var i = 0; i < count; i++) {
      cards.add(
        game.DefenseCard(
          id: 'DEF_${power}_$i',
          name: 'DEF $power',
          power: power,
        ),
      );
    }
  }

  // ATK
  addAtk(1, 10);
  addAtk(2, 16);
  addAtk(3, 12);

  // DEF
  addDef(1, 10);
  addDef(2, 16);
  addDef(3, 12);

  return cards;
}

Deck createShuffledCoreDeck() {
  final deck = Deck(cards: buildCoreDeck());
  deck.shuffle();
  return deck;
}
