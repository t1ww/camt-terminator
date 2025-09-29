// project\camt_terminator\lib\models\player_model.dart
import 'package:camt_terminator/models/card_model.dart';

class Player {
  num hp = 50;
  List<Card> hand = [];
  List<Card> deck = [];

  num get maxHp => 50;
  // etc.
}
