// project\camt_terminator\lib\cubit\card_cubit.dart
import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/deck_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:camt_terminator/models/boss_model.dart';
import '../../data/deck_data.dart';
import '../services/combat_resolver.dart';

/// CardCubit manages combat state:
/// - Deck, hand, discard
/// - Turn count
/// - Selected cards (up to 3 for player)
/// - Drawing, resetting, and playing cards
class CardCubit {
  // Singleton
  CardCubit._();
  static final CardCubit I = CardCubit._();

  // Active deck (shuffled)
  late Deck deck;

  // Tracks round number
  int turn = 1;

  // Current hand of drawn cards
  List<Card> hand = [];

  // Currently selected cards (max 3)
  List<Card> selectedCards = [];

  /// Init
  void init() {
    _resetDeck();
    turn = 1;
    hand = [];
    selectedCards = [];
  }

  /// Draw cards until hand has 5
  void drawCards({List<Card> exclude = const []}) {
    const maxHandSize = 5;
    final toDraw = maxHandSize - hand.length;
    if (toDraw <= 0) return;

    var drawn = deck
        .draw(toDraw, includeConsumables: false)
        .where((c) => !exclude.contains(c))
        .toList();

    // If deck is empty but discard pile has cards, recycle
    if (drawn.isEmpty && deck.discardPile.isNotEmpty) {
      deck.resetDeck();
      drawn = deck
          .draw(toDraw, includeConsumables: false)
          .where((c) => !exclude.contains(c))
          .toList();
    }

    if (drawn.isEmpty) return;

    hand.addAll(drawn);
    selectedCards = [];
    turn++;
  }

  /// Reset deck and hand
  void reset() {
    _resetDeck();
    turn = 1;
    hand = [];
    selectedCards = [];
  }

  void _resetDeck() {
    deck = initializeDeck();
  }

  /// Toggle card selection (adds if <3, removes if already selected)
  void toggleCardSelection(Card card) {
    if (selectedCards.contains(card)) {
      selectedCards.remove(card);
    } else if (selectedCards.length < 3) {
      selectedCards.add(card);
    }
  }

  /// Play selected cards against boss and clear selection
  void playSelectedCards({required Player player, required Boss boss}) {
    final bossPlayedCards = boss.playCards();

    CombatResolver.resolveRound(
      playerCards: selectedCards,
      bossCards: bossPlayedCards,
      player: player,
      boss: boss,
    );

    // Move played cards into discard pile
    deck.discard(selectedCards);

    // Remove played cards from hand
    hand.removeWhere((c) => selectedCards.contains(c));
    selectedCards = [];
  }
}
