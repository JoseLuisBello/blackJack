import 'package:flutter/material.dart' hide Card;
import '../models/card.dart';

class PlayingCard extends StatefulWidget {
  final Card card;
  final double width;
  final bool faceUp;
  final bool animateFlip;
  final VoidCallback? onFlipComplete;

  const PlayingCard({
    super.key,
    required this.card,
    this.width = 100,
    this.faceUp = true,
    this.animateFlip = false,
    this.onFlipComplete,
  });

  @override
  State<PlayingCard> createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnim;

  bool _showingFront = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _flipAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _showingFront = widget.faceUp;

    if (widget.animateFlip) {
      _controller.forward().then((_) {
        setState(() => _showingFront = true);
        widget.onFlipComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final angle = _flipAnim.value * 3.1416; // 180 grados
        final showFront = _showingFront || _flipAnim.value > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspectiva
            ..rotateY(angle),
          child: Container(
            width: widget.width,
            height: widget.width * 1.39,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 1.2),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: showFront
                ? _buildFrontFace()
                : _buildBackFace(),
          ),
        );
      },
    );
  }

  Widget _buildFrontFace() {
    final color = widget.card.suit.color;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.card.displayRank}\n${widget.card.suit.symbol}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
                height: 0.9,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            widget.card.suit.symbol,
            style: TextStyle(
              fontSize: 60,
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Transform.rotate(
              angle: 3.1416,
              child: Text(
                '${widget.card.displayRank}\n${widget.card.suit.symbol}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 0.9,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackFace() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade800, Colors.blue.shade900],
        ),
      ),
      child: Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 72,
            color: Colors.white.withOpacity(0.35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}