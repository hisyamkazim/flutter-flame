import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/my_game.dart';
import 'package:flutter_flame/overlays/pause_menu.dart';

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
        GameWidget(game: _myGame, overlayBuilderMap: {
          'PauseMenu': (_, MyGame game) => PauseMenu(game: game),
          'GameOverMenu': (BuildContext context, MyGame game) {
            return Text('A secondary menu');
          }
        }),
        ValueListenableBuilder(
            valueListenable: _myGame.isGamePaused,
            builder: (context, _, child) {
              if (!_myGame.isGamePaused.value) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _myGame.pauseGame();
                          });
                        },
                        icon: const Icon(Icons.pause)),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: ValueListenableBuilder(
                valueListenable: _myGame.currentScore,
                builder: (context, int value, child) {
                  return Text(
                    'Score: ${value.toString()}',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black)]),
                  );
                }),
          ),
        ),
      ]),
    );
  }
}
