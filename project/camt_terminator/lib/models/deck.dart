import 'package:camt_terminator/models/card.dart';

class Deck {
  List<Card> cards = [];
  List<Card> discardPile = [];

  Deck({required this.cards});

  int totalCards() => cards.length;

  void shuffle() {
    cards.shuffle();
  }

  List<Card> draw(int count, {bool includeConsumables = true}) {
    List<Card> drawPool = includeConsumables
        ? cards
        : cards.where((c) => c is! ConsumableCard).toList();

    final drawn = drawPool.take(count).toList();
    for (var card in drawn) {
      cards.remove(card);
    }
    return drawn;
  }

  void discard(List<Card> usedCards) {
    discardPile.addAll(usedCards);
  }

  void resetDeck() {
    cards.addAll(discardPile);
    discardPile.clear();
    shuffle();
  }
}