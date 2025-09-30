// project\camt_terminator\lib\cubit\card_cubit.dart
import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/deck_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:camt_terminator/models/boss_model.dart';
import '../../data/deck_data.dart';
import '../services/combat_resolver.dart';

/// CardCubit manages combat state:
/// - Deck & hand
/// - Turn count
/// - Selected cards (up to 3 for player)
/// - Drawing, resetting, and playing cards
class CardCubit {
  // Active deck (shuffled)
  late Deck deck;

  // Tracks round number
  int turn = 0;

  // Current hand of drawn cards
  List<Card> hand = [];

  // Currently selected cards (max 3)
  List<Card> selectedCards = [];

  CardCubit() {
    _resetDeck();
  }

  // Draw cards until hand has 5
  void drawCards() {
    const maxHandSize = 5;
    final toDraw = maxHandSize - hand.length;
    if (toDraw <= 0) return; // Already full

    final drawn = deck.draw(toDraw, includeConsumables: false);
    if (drawn.isEmpty) return; // Deck empty

    hand.addAll(drawn);
    selectedCards = []; // Clear selection on new draw
    turn++;
  }

  // Reset deck and hand
  void reset() {
    _resetDeck();
    turn = 0;
    hand = [];
    selectedCards = [];
  }

  void _resetDeck() {
    deck = createShuffledCoreDeck();
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
  /// Delegates combat logic to CombatResolver
  void playSelectedCards({required Player player, required Boss boss}) {
    // Boss selects cards to play this turn
    final bossPlayedCards = boss.playCards();

    // Resolve the round
    CombatResolver.resolveRound(
      playerCards: selectedCards,
      bossCards: bossPlayedCards,
      player: player,
      boss: boss,
    );

    // Remove played cards from player's hand
    hand.removeWhere((c) => selectedCards.contains(c));
    selectedCards = [];
  }
}
