import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:color_flip_go/my_game.dart';
import 'package:pixelarticons/pixel.dart';

class PauseMenu extends ConsumerWidget {
  final MyGame game;
  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PAUSED!',
            style: GoogleFonts.pixelifySans(
                color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(
              height: 140,
              width: 140,
              child: IconButton(
                  onPressed: () {
                    game.resumeGame();
                  },
                  icon: const Icon(Pixel.play, size: 140))),
        ],
      ),
    );
  }
}
