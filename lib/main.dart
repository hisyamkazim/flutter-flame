// Project: infinite_circle
// File: lib/main.dart
// Created by: Hisyam Kazim
// Created on: 2025

import 'dart:async';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:color_flip_go/constant/game_over.dart';
import 'package:color_flip_go/constant/keys.dart';
import 'package:color_flip_go/db/db_helper.dart';
import 'package:color_flip_go/my_game.dart';
import 'package:color_flip_go/overlays/countdown_overlay.dart';
import 'package:color_flip_go/overlays/gameover_menu.dart';
import 'package:color_flip_go/overlays/main_menu.dart';
import 'package:color_flip_go/overlays/pause_menu.dart';
import 'package:color_flip_go/overlays/record_menu.dart';
import 'package:color_flip_go/controller/riverpod.dart';
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

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

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
      onStateChange: (state) => _myGame.handleAppState(state),
    );
    _createInterstitialAd();
    _createRewardedInterstitialAd();
  }

  @override
  void dispose() {
    _listener.dispose();
    _interstitialAd?.dispose();
    _rewardedInterstitialAd?.dispose();
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
                    gameOverMenuRoute: (_, MyGame game) => GameOverMenu(
                            game: game, ({required VoidCallback onAdClosed}) {
                          _showInterstitialAd(onAdClosed);
                        },
                            () => _showRewardedInterstitialAd(() =>
                                _myGame.resetGame(action: GameOver.resumed))),
                    recordMenuRoute: (_, MyGame game) => RecordMenu(game: game),
                    countdownRoute: (_, MyGame game) => CountdownOverlay(
                        onCountdownComplete: game.onCountdownComplete),
                  })),
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
                      onPressed: () =>
                          _myGame.resetGame(action: GameOver.start),
                      icon: const Icon(Pixel.home))),
            ),
          )
        ],
      ),
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-9441774521479150/2856834219',
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

  void _showInterstitialAd(VoidCallback onAdClosed) {
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
        onAdClosed();
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

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: 'ca-app-pub-9441774521479150/6042412516',
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd(VoidCallback onRewarded) {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      onRewarded();
    });
    _rewardedInterstitialAd = null;
  }
}
