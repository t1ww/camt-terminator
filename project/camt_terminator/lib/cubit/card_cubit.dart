// lib/cubit/card_cubit.dart
import 'package:camt_terminator/models/card_model.dart';
import 'package:camt_terminator/models/deck_model.dart';
import 'package:camt_terminator/models/player_model.dart';
import 'package:camt_terminator/models/boss_model.dart';
import 'package:flutter/material.dart' hide Card;
import '../../data/deck_data.dart';
import '../services/combat_resolver.dart';

/// CardCubit manages combat state:
/// - Deck, hand, discard
/// - Turn count
/// - Selected cards (up to 3 for player)
/// - Drawing, resetting, and playing cards
///
/// Fully reactive using ValueNotifier for UI updates
class CardCubit {
  // Singleton pattern
  CardCubit._();
  static final CardCubit I = CardCubit._();

  // ===== Reactive State =====
  /// Current hand of drawn cards
  final ValueNotifier<List<Card>> handNotifier = ValueNotifier([]);

  /// Currently selected cards (max 3)
  final ValueNotifier<List<Card>> selectedCardsNotifier = ValueNotifier([]);

  /// Active deck (shuffled)
  final ValueNotifier<Deck> deckNotifier = ValueNotifier(initializeDeck());

  /// Tracks current turn number
  final ValueNotifier<int> turnNotifier = ValueNotifier(1);

  // Track boss cards being played
  final ValueNotifier<List<Card>> bossPlayedNotifier = ValueNotifier([]);

  // ===== Internal State =====
  late Deck deck;
  bool shuffledByConfirm = false;

  /// Initialize deck and hand
  void init() {
    _resetDeck();
    handNotifier.value = [];
    selectedCardsNotifier.value = [];
    turnNotifier.value = 0;
  }

  /// Draw cards until hand has 5
  /// Optional exclusion of certain cards
  void drawCards({List<Card> exclude = const []}) {
    const maxHandSize = 5;
    final toDraw = maxHandSize - handNotifier.value.length;
    if (toDraw <= 0) return;

    var drawn = deck
        .draw(toDraw, includeConsumables: false)
        .where((c) => !exclude.contains(c))
        .toList();

    // If deck is empty but discard has cards, recycle
    if (drawn.isEmpty && deck.discardPile.isNotEmpty) {
      deck.resetDeck();
      drawn = deck
          .draw(toDraw, includeConsumables: false)
          .where((c) => !exclude.contains(c))
          .toList();
    }

    if (drawn.isEmpty) return;

    // Update hand and turn
    final updatedHand = [...handNotifier.value, ...drawn];
    handNotifier.value = updatedHand;
    selectedCardsNotifier.value = [];
    turnNotifier.value += 1;

    // Reassign new Deck for UI update
    deckNotifier.value = Deck(cards: [...deck.cards])
      ..discardPile.addAll(deck.discardPile);
  }

  /// Toggle selection of a card (max 3)
  void toggleCardSelection(Card card) {
    final selected = [...selectedCardsNotifier.value];
    if (selected.contains(card)) {
      selected.remove(card);
    } else if (selected.length < 3) {
      selected.add(card);
    }
    selectedCardsNotifier.value = selected;
  }

  /// Play selected cards against boss and clear selection
  Future<void> playSelectedCards({
    required Player player,
    required Boss boss,
  }) async {
    final selected = [...selectedCardsNotifier.value];

    // Boss draws first
    boss.drawCards();

    // Boss plays cards (remove from hand, prepare for UI)
    final bossCards = boss.playCards();
    bossPlayedNotifier.value = bossCards;

    // Wait 1–2 seconds for animation/preview
    await Future.delayed(const Duration(seconds: 1));

    // Resolve combat round
    CombatResolver.resolveRound(
      playerCards: selected,
      bossCards: bossCards,
      player: player,
      boss: boss,
    );

    // Move played cards to discard pile
    deck.discard(selected);

    // Remove played cards from hand
    final updatedHand = handNotifier.value
        .where((c) => !selected.contains(c))
        .toList();
    handNotifier.value = updatedHand;

    // Clear selected cards
    selectedCardsNotifier.value = [];

    // Clear boss preview after combat
    bossPlayedNotifier.value = [];

    // Update deck for UI
    deckNotifier.value = deck;
  }

  /// Reset deck to initial state
  void _resetDeck() {
    deck = initializeDeck();
    deckNotifier.value = deck;
  }

  /// Fully reset all state
  void reset() {
    _resetDeck();
    handNotifier.value = [];
    selectedCardsNotifier.value = [];
    turnNotifier.value = 0;
  }
}
