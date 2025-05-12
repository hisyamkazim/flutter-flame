import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/riverpod.dart';
import 'package:lottie/lottie.dart';

// TODO: Make table with score records and time
class RecordMenu extends ConsumerWidget {
  final MyGame game;

  const RecordMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          ],
        ),
      ),
    );
  }
}
