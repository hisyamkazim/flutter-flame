import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/overlays/gameover_menu.dart';
import 'package:infinite_circle/overlays/main_menu.dart';
import 'package:infinite_circle/overlays/pause_menu.dart';
import 'package:infinite_circle/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MaterialApp(
      home: const HomePage(),
      theme: ThemeData.dark(),
    ),
  ));
}

final GlobalKey<RiverpodAwareGameWidgetState<MyGame>> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState<MyGame>>();
final _myGame = MyGame();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        RiverpodAwareGameWidget(
          key: gameWidgetKey,
          game: _myGame,
          overlayBuilderMap: {
            'MainMenu': (_, MyGame game) => MainMenu(game: game),
            'PauseMenu': (_, MyGame game) => PauseMenu(game: game),
            'GameOverMenu': (_, MyGame game) => GameOverMenu(game: game),
          },
        ),
        const StatusBar(),
      ]),
    );
  }
}

class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(pauseStateProvider)) {
      return SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () => _myGame.pauseGame(),
                  icon: const Icon(Icons.pause)),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Score: ${ref.watch(scoreProvider).toString()}',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)]),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
