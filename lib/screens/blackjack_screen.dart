import 'package:flutter/material.dart' hide Card;
import '../models/card.dart';
import '../utils/deck.dart';
import '../widgets/playing_card.dart';

class BlackjackScreen extends StatefulWidget {
  const BlackjackScreen({super.key});

  @override
  State<BlackjackScreen> createState() => _BlackjackScreenState();
}

class _BlackjackScreenState extends State<BlackjackScreen> {
  List<Card> deck = [];
  List<Card> playerHand = [];
  List<Card> dealerHand = [];
  String message = "Presiona 'Nueva partida'";
  bool gameOver = true;
  bool dealerTurn = false;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    setState(() {
      deck = createDeck();
      playerHand = [deck.removeLast(), deck.removeLast()];
      dealerHand = [deck.removeLast(), deck.removeLast()];
      gameOver = false;
      dealerTurn = false;
      message = "Tu turno • ¿Pedir o Plantarte?";
    });

    if (isBlackjack(playerHand)) {
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          dealerTurn = true;
          message = "¡Blackjack! Ganaste";
          gameOver = true;
        });
      });
    }
  }

  void _hit() {
    if (gameOver || dealerTurn) return;

    setState(() {
      playerHand.add(deck.removeLast());
    });

    final value = calculateHandValue(playerHand);
    if (value > 21) {
      Future.delayed(const Duration(milliseconds: 700), () {
        setState(() {
          message = "Te pasaste • Perdiste";
          gameOver = true;
        });
      });
    }
  }

  void _stand() {
    if (gameOver || dealerTurn) return;

    setState(() {
      dealerTurn = true;
      message = "Turno del crupier...";
    });

    _playDealer();
  }

  void _playDealer() {
    Future.delayed(const Duration(milliseconds: 900), () {
      while (true) {
        final value = calculateHandValue(dealerHand);
        if (value >= 17) break;

        setState(() {
          dealerHand.add(deck.removeLast());
        });

        // Pequeño delay visual
        Future.delayed(const Duration(milliseconds: 800));
      }

      _determineWinner();
    });
  }

  void _determineWinner() {
    final playerVal = calculateHandValue(playerHand);
    final dealerVal = calculateHandValue(dealerHand);

    String result;
    if (dealerVal > 21) {
      result = "Crupier se pasó • Ganaste";
    } else if (playerVal > dealerVal) {
      result = "Ganaste • $playerVal vs $dealerVal";
    } else if (playerVal < dealerVal) {
      result = "Perdiste • $playerVal vs $dealerVal";
    } else {
      result = "Empate";
    }

    setState(() {
      message = result;
      gameOver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerValue = calculateHandValue(playerHand);
    final dealerValue = dealerTurn ? calculateHandValue(dealerHand) : "?";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blackjack 21'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _newGame,
            tooltip: 'Nueva partida',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Área del crupier
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Crupier', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dealerHand.asMap().entries.map((e) {
                      final idx = e.key;
                      final card = e.value;
                      final animateFlip = idx == 1 && dealerTurn;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PlayingCard(
                          card: card,
                          width: 100,
                          faceUp: idx == 0 || dealerTurn,
                          animateFlip: animateFlip,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Valor: $dealerValue',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            // Mensaje central
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Área del jugador
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tu', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: playerHand.map((card) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PlayingCard(
                          card: card,
                          width: 100,
                          faceUp: true,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Valor: $playerValue',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            // Botones
            if (!gameOver)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _hit,
                      icon: const Icon(Icons.add_card),
                      label: const Text('Pedir'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _stand,
                      icon: const Icon(Icons.pan_tool),
                      label: const Text('Plantarse'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: _newGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                  ),
                  child: const Text('Nueva Partida', style: TextStyle(fontSize: 20)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}