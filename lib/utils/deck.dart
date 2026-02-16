import '../models/card.dart';

List<Card> createDeck() {
  final List<Card> deck = [];
  for (var suit in Suit.values) {
    for (var rank in ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']) {
      deck.add(Card(suit, rank));
    }
  }
  deck.shuffle();
  return deck;
}

int calculateHandValue(List<Card> hand) {
  int sum = 0;
  int aces = 0;

  for (var card in hand) {
    sum += card.value;
    if (card.rank == 'A') aces++;
  }

  while (sum > 21 && aces > 0) {
    sum -= 10;
    aces--;
  }

  return sum;
}

bool isBlackjack(List<Card> hand) {
  return hand.length == 1 && calculateHandValue(hand) == 21;
}