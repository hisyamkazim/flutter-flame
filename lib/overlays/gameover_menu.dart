import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelarticons/pixel.dart';

class GameOverMenu extends ConsumerWidget {
  final MyGame game;
  final VoidCallback _showInterstitialAd;

  const GameOverMenu(this._showInterstitialAd, {super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/game_over.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 10), // Add spacing between the children
            Text(
              'Your Score: ${ref.watch(scoreProvider).toString()}',
              style: GoogleFonts.pixelifySans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
              ),
            ),
            const SizedBox(height: 10), // Add spacing between the children
            Text(
              'High Score: ${ref.watch(highestScoreProvider).toString()}',
              style: GoogleFonts.pixelifySans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
              ),
            ),
            const SizedBox(height: 20), // Add spacing between the children
            OverflowBar(
              spacing: 10,
              children: [
                IconButton(
                    onPressed: () {
                      game.resetGame(isRestarting: false);
                      _showInterstitialAd();
                    },
                    icon: const Icon(Pixel.home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    )),
                IconButton(
                    onPressed: () {
                      game.goToRecordMenu();
                      _showInterstitialAd();
                    },
                    icon: const Icon(Pixel.chartbar),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    )),
                ElevatedButton.icon(
                    label: Text('Restart',
                        style: GoogleFonts.pixelifySans(
                          fontSize: 20,
                          shadows: const [
                            Shadow(blurRadius: 4, color: Colors.black)
                          ],
                        )),
                    onPressed: () {
                      game.resetGame(isRestarting: true);
                      _showInterstitialAd();
                    },
                    icon: const Icon(
                      Pixel.undo,
                      weight: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
