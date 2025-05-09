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

  // Get the instance of shared preferences
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      // Override the unimplemented provider with the value gotten from the plugin
      sharedPreferencesProvider.overrideWithValue(prefs),
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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isPaused = ref.watch(pauseStateProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: RiverpodAwareGameWidget(
        key: gameWidgetKey,
        game: _myGame,
        overlayBuilderMap: {
          'MainMenu': (_, MyGame game) => MainMenu(game: game),
          'PauseMenu': (_, MyGame game) => PauseMenu(game: game),
          'GameOverMenu': (_, MyGame game) => GameOverMenu(game: game),
        },
      ),
    );
  }
}
