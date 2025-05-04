import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_circle/my_game.dart';

class PauseMenu extends ConsumerWidget {
  final MyGame game;
  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        color: Colors.black45,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PAUSED!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height: 140,
                width: 140,
                child: IconButton(
                    onPressed: () {
                      game.resumeGame();
                    },
                    icon: const Icon(Icons.play_arrow, size: 140)))
          ],
        )),
      ),
    );
  }
}
