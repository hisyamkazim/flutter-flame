import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_circle/constant/game_over.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/controller/riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelarticons/pixel.dart';

class GameOverMenu extends ConsumerWidget {
  final MyGame game;
  final Function({required VoidCallback onAdClosed}) _showInterstitialAd;
  final VoidCallback _showRewardedInterstitialAd;

  const GameOverMenu(this._showInterstitialAd, this._showRewardedInterstitialAd,
      {super.key, required this.game});

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
                      _showInterstitialAd(onAdClosed: () => game.resetGame(action: GameOver.start));
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
                      _showInterstitialAd(onAdClosed: () => game.goToRecordMenu());
                    },
                    icon: const Icon(Pixel.chartbar),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    )),
                ElevatedButton.icon(
                  label: Text(
                    'Restart',
                    style: GoogleFonts.pixelifySans(
                      fontSize: 20,
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black)
                      ],
                    ),
                  ),
                  onPressed: () => _showTryAgainModal(context, ref),
                  icon: const Icon(Pixel.undo, weight: 20),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTryAgainModal(BuildContext context, WidgetRef ref) {
    final attempts = ref.read(attemptCounterProvider);
    const maxAttempts = 3;
    final remainingAttempts = maxAttempts - attempts;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.cyan, width: 2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 30),
            Text(
              'Continue?',
              style: GoogleFonts.pressStart2p(
                fontSize: 24,
                color: Colors.cyan,
                shadows: const [
                  Shadow(
                    color: Colors.cyanAccent,
                    blurRadius: 15,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Hearts or Ad Watch message
            if (remainingAttempts > 0) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hearts Left: ',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ...List.generate(
                      remainingAttempts,
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Pixel.heart,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Pixel.play,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Watch Ad to Continue',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 8,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  text: 'NO',
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    
                    _showInterstitialAd(onAdClosed: () => game.resetGame(action: GameOver.restarted));
                  },
                ),
                _buildActionButton(
                  text: 'YES',
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pop(context);
                    if (remainingAttempts > 0) {
                      ref
                          .read(attemptCounterProvider.notifier)
                          .incrementAttemptCount();
                      game.resetGame(action: GameOver.resumed);
                    } else {
                      _showRewardedInterstitialAd();
                      // game.resetGame(action: GameOver.resumed);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 18,
            shadows: const [
              Shadow(
                color: Colors.black54,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
