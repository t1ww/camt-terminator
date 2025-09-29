// project\camt_terminator\lib\models\deck.dart
import 'package:camt_terminator/models/card_model.dart';

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

  void insertOnTop(Card card) {
    cards.insert(0, card);
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