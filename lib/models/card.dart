import 'dart:ui';

import 'package:flutter/material.dart';

enum Suit {
  hearts,
  diamonds,
  clubs,
  spades;

  String get symbol {
    switch (this) {
      case Suit.hearts:   return '♥';
      case Suit.diamonds: return '♦';
      case Suit.clubs:    return '♣';
      case Suit.spades:   return '♠';
    }
  }

  Color get color {
    switch (this) {
      case Suit.hearts:
      case Suit.diamonds:
        return Colors.red;
      case Suit.clubs:
      case Suit.spades:
        return Colors.black;
    }
  }
}

class Card {
  final Suit suit;
  final String rank; // "A", "2".."10", "J", "Q", "K"

  Card(this.suit, this.rank);

  int get value {
    if (rank == 'A') return 11;
    if (rank == 'J' || rank == 'Q' || rank == 'K' || rank == '10') return 10;
    return int.tryParse(rank) ?? 0;
  }

  String get displayRank => rank;
}