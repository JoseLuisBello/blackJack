// screens/menu_screen.dart (nueva pantalla de menú)
import 'package:flutter/material.dart';
import 'blackjack_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Instrucciones de Blackjack 21'),
        content: const Text(
          'Objetivo: Acercarte a 21 puntos sin pasarte.\n'
          '- Cartas 2-10: valor facial.\n'
          '- J, Q, K: 10 puntos.\n'
          '- As: 1 o 11 puntos.\n'
          'Reglas:\n'
          '- Inicias pidiendo cartas.\n'
          '- Puedes "Pedir" o "Plantarte".\n'
          '- Crupier pide hasta ≥17.\n'
          '- Ganas si tienes más que el crupier sin pasarte, o si él se pasa.\n'
          '- Blackjack (21 inicial): gana automático.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade900],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Black Jack 21',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black45,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BlackjackScreen()),
                  );
                },
                icon: const Icon(Icons.play_arrow, size: 32),
                label: const Text('Iniciar Partida', style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => _showInstructions(context),
                icon: const Icon(Icons.info_outline, size: 32),
                label: const Text('Instrucciones', style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.blue.shade300,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}