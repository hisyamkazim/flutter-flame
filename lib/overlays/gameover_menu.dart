import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/riverpod.dart';

class GameOverMenu extends ConsumerWidget {
  final MyGame game;
  final VoidCallback _showInterstitialAd;

  const GameOverMenu(this._showInterstitialAd, {super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        game.resetGame();
        _showInterstitialAd();
      },
      child: Material(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Add spacing between the children
              Text(
                'Score: ${ref.watch(scoreProvider).toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 10), // Add spacing between the children
              Text(
                'Highest Score: ${ref.watch(highestScoreProvider).toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
