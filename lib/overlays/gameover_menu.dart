import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/riverpod.dart';

class GameOverMenu extends ConsumerWidget {
  final MyGame game;

  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => game.resetGame(),
      child: Material(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score: ${ref.watch(scoreProvider).toString()}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
              ),
              const SizedBox(width: 10), // Add spacing between the children
              Text(
                'Highest Score: ${game.highestScore!.toString()}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
              ),
              const SizedBox(width: 10), // Add spacing between the children
              const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
