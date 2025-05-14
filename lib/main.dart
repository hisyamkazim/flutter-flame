// Project: infinite_circle
// File: lib/main.dart
// Created by: Hisyam Kazim
// Created on: 2025

import 'dart:async';

import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_circle/constant/keys.dart';
import 'package:infinite_circle/db/db_helper.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/overlays/gameover_menu.dart';
import 'package:infinite_circle/overlays/main_menu.dart';
import 'package:infinite_circle/overlays/pause_menu.dart';
import 'package:infinite_circle/overlays/record_menu.dart';
import 'package:infinite_circle/controller/riverpod.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // Get the instance of shared preferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize the database
  await DatabaseHelper.instance.database;

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
const int maxFailedLoadAttempts = 3;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final AppLifecycleListener _listener;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    super.initState();
    // Initialize the AppLifecycleListener
    _listener = AppLifecycleListener(
      onHide: () => _myGame.pauseGame(),
      onPause: () => _myGame.pauseGame(),
    );
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _listener.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: RiverpodAwareGameWidget(
              key: gameWidgetKey,
              game: _myGame,
              overlayBuilderMap: {
                mainMenuRoute: (_, MyGame game) => MainMenu(game: game),
                pauseMenuRoute: (_, MyGame game) => PauseMenu(game: game),
                gameOverMenuRoute: (_, MyGame game) =>
                    GameOverMenu(game: game, () => _showInterstitialAd()),
                recordMenuRoute: (_, MyGame game) => RecordMenu(game: game),
              },
            ),
          ),
          Visibility(
            visible: !ref.watch(pauseStateProvider),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                      tooltip: 'Pause',
                      onPressed: () => _myGame.pauseGame(),
                      icon: const Icon(Pixel.pause))),
            ),
          ),
          Visibility(
            visible: !ref.watch(pauseStateProvider),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                      onPressed: () => _myGame.resetGame(isRestarting: false),
                      icon: const Icon(Pixel.home))),
            ),
          )
        ],
      ),
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');

            setState(() {
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
            });
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            setState(() {
              _numInterstitialLoadAttempts += 1;
              _interstitialAd = null;
            });
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
