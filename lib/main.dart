import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/overlays/gameover_menu.dart';
import 'package:infinite_circle/overlays/main_menu.dart';
import 'package:infinite_circle/overlays/pause_menu.dart';

void main() {
  runApp(MaterialApp(
    home: const HomePage(),
    theme: ThemeData.dark(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MyGame _myGame;
  @override
  void initState() {
    _myGame = MyGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GameWidget(
          game: _myGame,
          overlayBuilderMap: {
            'MainMenu': (_, MyGame game) => MainMenu(game: game),
            'PauseMenu': (_, MyGame game) => PauseMenu(game: game),
            'GameOverMenu': (_, MyGame game) => GameOverMenu(game: game),
          },
        ),
        ValueListenableBuilder(
            valueListenable: _myGame.isGamePaused,
            builder: (context, _, child) {
              if (!_myGame.isGamePaused.value) {
                return SafeArea(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _myGame.pauseGame();
                              });
                            },
                            icon: const Icon(Icons.pause)),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ValueListenableBuilder(
                            valueListenable: _myGame.currentScore,
                            builder: (context, int value, child) {
                              return Text(
                                'Score: ${value.toString()}',
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(blurRadius: 4, color: Colors.black)
                                    ]),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
      ]),
    );
  }
}
