// Project: infinite_circle
// File: lib/main.dart
// Created by: Hisyam Kazim
// Created on: 2025

import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_circle/constant/keys.dart';
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
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    // Initialize the AppLifecycleListener
    _listener = AppLifecycleListener(
      onHide: () => _myGame.pauseGame(),
      onPause: () => _myGame.pauseGame(),
      onInactive: () => _myGame.pauseGame(),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: RiverpodAwareGameWidget(
        key: gameWidgetKey,
        game: _myGame,
        overlayBuilderMap: {
          mainMenuRoute: (_, MyGame game) => MainMenu(game: game),
          pauseMenuRoute: (_, MyGame game) => PauseMenu(game: game),
          gameOverMenuRoute: (_, MyGame game) => GameOverMenu(game: game),
        },
      ),
    );
  }
}
