import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelarticons/pixel.dart';

class MainMenu extends StatelessWidget {
  final MyGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/main_menu.json',
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10),
              Text(
                'Infinite Color Switch Game',
                textAlign: TextAlign.center,
                style: GoogleFonts.pixelifySans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  game.startGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(
                  Pixel.play,
                  size: 20.0,
                  color: Colors.black,
                ),
                label: Text(
                  'Play',
                  style: GoogleFonts.pixelifySans(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
