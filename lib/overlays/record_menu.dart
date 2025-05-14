import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/controller/riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class RecordMenu extends ConsumerWidget {
  final MyGame game;

  const RecordMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(scoreHistoryProvider);

    return Material(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/record_menu.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            Text(
              'HIGH SCORES',
              style: GoogleFonts.pressStart2p(
                fontSize: 24,
                color: Colors.cyan,
                shadows: const [
                  Shadow(
                    color: Colors.cyanAccent,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: scoresAsync.when(
                data: (scores) => scores.isEmpty
                    ? Center(
                        child: Text(
                          'NO RECORDS',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: scores.length,
                        itemBuilder: (context, index) {
                          final score = scores[index];
                          final rank = index + 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _getRankSuffix(rank),
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 14,
                                    color: _getRankColor(rank),
                                  ),
                                ),
                                const SizedBox(width: 32),
                                Text(
                                  score.score.toString(),
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 14,
                                    color: _getRankColor(rank),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _formatDate(score.date),
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 14,
                                    color: _getRankColor(rank),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                loading: () => const CircularProgressIndicator(
                  color: Colors.cyan,
                ),
                error: (err, stack) => Text(
                  'ERROR: $err',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            OverflowBar(
              spacing: 10,
              children: [
                IconButton(
                  onPressed: () => game.resetGame(isRestarting: false),
                  icon: const Icon(Pixel.home),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (await confirm(context)) {
                      game.clearScoreHistory();
                    }
                    return;
                  },
                  icon: const Icon(Pixel.trash, size: 20, color: Colors.white),
                  label: Text(
                    'Clear Data',
                    style: GoogleFonts.pixelifySans(
                      fontSize: 20,
                      color: Colors.white,
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.white;
      case 2:
        return Colors.red;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.yellow;
      default:
        return Colors.cyan;
    }
  }

  String _getRankSuffix(int rank) {
    switch (rank) {
      case 1:
        return '${rank}ST';
      case 2:
        return '${rank}ND';
      case 3:
        return '${rank}RD';
      default:
        return '${rank}TH';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
