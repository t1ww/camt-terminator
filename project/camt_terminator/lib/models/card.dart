enum CardType { atk, def, shotgun, medkit }

class GameCard {
  final String id;
  final CardType type;
  final int power;

  const GameCard({required this.id, required this.type, this.power = 0});
}
