// Project: infinite_circle
// File: lib/my_game.dart
// Created by: Hisyam Kazim
// Created on: 2025

import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:color_flip_go/circle_rotator.dart';
import 'package:color_flip_go/color_switcher.dart';
import 'package:color_flip_go/constant/assets.dart';
import 'package:color_flip_go/constant/game_over.dart';
import 'package:color_flip_go/constant/keys.dart';
import 'package:color_flip_go/constant/timescale.dart';
import 'package:color_flip_go/db/models/scores.dart';
import 'package:color_flip_go/ground.dart';
import 'package:color_flip_go/overlays/hud.dart';
import 'package:color_flip_go/player.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:color_flip_go/controller/riverpod.dart';
import 'package:color_flip_go/star_component.dart';

class MyGame extends FlameGame
    with
        TapCallbacks,
        HasCollisionDetection,
        HasDecorator,
        HasTimeScale,
        RiverpodGameMixin {
  late Player myPlayer;
  final Ground ground = Ground(position: Vector2(0, 400));
  final List<Color> gameColors;
  final List<PositionComponent> _gameComponents = [];

  MyGame(
      {this.gameColors = const [
        Colors.redAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.yellowAccent,
      ]})
      : super(
            camera:
                CameraComponent.withFixedResolution(width: 600, height: 1200));

  @override
  Color backgroundColor() => const Color(0xff222222);

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setPortraitUpOnly();
    debugMode = kDebugMode; //enables debug mode only when building on debug

    await super.onLoad();

    decorator = PaintDecorator.blur(0);
    FlameAudio.bgm.initialize();
    await Flame.images.loadAll([starPath, groundPath]);
    await FlameAudio.audioCache.loadAll([collectSoundPath, soundtrackPath]);
  }

  @override
  void onMount() {
    _initializeGame(action: GameOver.start);
    super.onMount();
  }

  bool isGameOverTriggered = false;

  @override
  void update(double dt) {
    if (!isGameOverTriggered && overlays.activeOverlays.isEmpty) {
      final cameraY = camera.viewfinder.position.y;
      final playerY = myPlayer.position.y;
      final screenHeight = camera.visibleWorldRect.height;
      final bottomEdge = (cameraY + screenHeight) / 2;

      if (playerY < cameraY) {
        camera.viewfinder.position = Vector2(0, playerY);
      }

      // Check if player has fallen below screen
      if (playerY > bottomEdge - 100) {
        // Added buffer of 100 to ensure player is fully off screen
        gameOver();
      }
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    myPlayer.jump();
    super.onTapDown(event);
  }

  void _initializeGame({required GameOver action}) {
    final lastValue = ref.watch(scoreProvider);
    overlays.toggle(
      action == GameOver.start ? mainMenuRoute : countdownRoute,
      priority: 1,
    );
    (decorator as PaintDecorator).addBlur(10);

    if (action != GameOver.resumed) {
      ref.read(scoreProvider.notifier).reset();
      camera.viewport.add(Hud(lastValue: null));
    } else {
      ref.read(scoreProvider.notifier).resume(value: lastValue);
      camera.viewport.add(Hud(lastValue: lastValue));
    }
    world.add(ground);
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2.zero());
    _generateGameComponents(Vector2(0, 20));
    ref.read(pauseStateProvider.notifier).hide();
    FlameAudio.bgm.play(soundtrackPath);
  }

  void _addComponentToTheGame(PositionComponent component) {
    _gameComponents.add(component);
    world.add(component);
  }

  void _generateGameComponents(Vector2 generateFromPosition) {
    final random = Random();

    // Generate random offsets for positioning
    final colorSwitcherOffset = Vector2(
        0,
        random.nextInt(100).toDouble() +
            100); // Random Y offset between 100 and 200
    final circleRotatorOffset = Vector2(
        0,
        random.nextInt(200).toDouble() +
            300); // Random Y offset between 300 and 500
    final multiRotatorCount = random.nextInt(3) + 1;
    final bufferOffset = Vector2(0, -150);

    // Add ColorSwitcher
    _addComponentToTheGame(ColorSwitcher(
        position: generateFromPosition + colorSwitcherOffset * -1));

    // // Add CircleRotator (first one)
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + circleRotatorOffset * -1,
        size: Vector2.all(200)));

    // // Add StarComponent (in the middle of CircleRotator)
    _addComponentToTheGame(StarComponent(
        position: generateFromPosition + circleRotatorOffset * -1));

    makeMultiRotator(
            multiRotatorCount,
            generateFromPosition +
                circleRotatorOffset * -1 +
                Vector2(0, -(multiRotatorCount * 200).toDouble()) +
                bufferOffset,
            Vector2.all((multiRotatorCount * 200).toDouble()))
        .forEach(_addComponentToTheGame);

    _addComponentToTheGame(StarComponent(
        position: generateFromPosition +
            circleRotatorOffset * -1 +
            Vector2(0, -(multiRotatorCount * 200).toDouble()) +
            bufferOffset));

    // // Adjust the next generation position
    generateFromPosition -= Vector2(0,
        (400 + random.nextInt(200).toDouble())); // Random gap between batches
  }

  void gameOver() {
    if (isGameOverTriggered) return; // Early return if already triggered
    isGameOverTriggered = true;

    final currentScore = ref.watch(scoreProvider);
    final highestScore = ref.watch(highestScoreProvider);

    if (highestScore < currentScore) {
      ref
          .read(highestScoreProvider.notifier)
          .setHighestScore(value: currentScore);
    }

    ref.read(scoreHistoryProvider.notifier).addScore(Scores(
          score: currentScore,
          date: DateTime.now(),
        ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pauseStateProvider.notifier).hide();
      overlays.add(gameOverMenuRoute);
    });
  }

  void pauseGame() {
    ref.read(pauseStateProvider.notifier).hide();
    FlameAudio.bgm.pause();
    (decorator as PaintDecorator).addBlur(10);
    timeScale = Timescale.pause.value;
    overlays.toggle(pauseMenuRoute);
  }

  void resumeGame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pauseStateProvider.notifier).show();
      FlameAudio.bgm.resume();
      (decorator as PaintDecorator).addBlur(0);
      timeScale = Timescale.normal.value;
      overlays.toggle(pauseMenuRoute);
    });
  }

  void increaseScore() {
    ref.read(scoreProvider.notifier).increment();
  }

  void checkToGenerateNextBatch(StarComponent starComponent) {
    final allStarComponents =
        _gameComponents.whereType<StarComponent>().toList();
    final length = allStarComponents.length;
    for (int i = 0; i < length; i++) {
      if (starComponent == allStarComponents[i] && i >= length - 2) {
        _generateGameComponents(
            allStarComponents.last.position - Vector2(0, 400));
        _tryToGarbageCollect(starComponent);
      }
    }
  }

  void _tryToGarbageCollect(StarComponent starComponent) {
    final allComponents = _gameComponents.toList();
    final length = allComponents.length;
    for (int i = 0; i < length; i++) {
      if (starComponent == allComponents[i] && i >= 15) {
        _removeComponentsFromGame(i - 7);
        break;
      }
    }
  }

  void _removeComponentsFromGame(int n) {
    for (int i = n - 1; i >= 0; i--) {
      _gameComponents[i].removeFromParent();
      _gameComponents.removeAt(i);
    }
  }

  void startGame() {
    overlays.remove(mainMenuRoute);

    // Add countdown overlay instead of immediately starting
    timeScale = Timescale.pause.value; // Pause the game during countdown
    overlays.add(countdownRoute);
  }

  // Add this method to handle countdown completion
  void onCountdownComplete() {
    overlays.remove(countdownRoute);
    (decorator as PaintDecorator).addBlur(0);
    timeScale = Timescale.normal.value;
    ref.read(pauseStateProvider.notifier).show();
  }

  void resetGame({required GameOver action}) {
    FlameAudio.bgm.stop();
    for (var child in world.children) {
      child.removeFromParent();
    }
    _gameComponents.clear();
    overlays.removeAll([
      mainMenuRoute,
      pauseMenuRoute,
      gameOverMenuRoute,
      recordMenuRoute,
      countdownRoute
    ]);
    isGameOverTriggered = false;
    _initializeGame(action: action);
  }

  List<CircleRotator> makeMultiRotator(int n, Vector2 position, Vector2 size) {
    final List<CircleRotator> multiRotator = [];
    for (int i = 1; i <= n; i++) {
      multiRotator.add(CircleRotator(position: position, size: size));
      size.sub(Vector2.all(30));
    }
    return multiRotator;
  }

  void goToRecordMenu() {
    FlameAudio.bgm.stop();
    for (var child in world.children) {
      child.removeFromParent();
    }
    print(ref.read(scoreHistoryProvider));
    _gameComponents.clear();
    overlays.remove(gameOverMenuRoute);
    overlays.add(recordMenuRoute);
  }

  void clearScoreHistory() {
    ref.read(scoreHistoryProvider.notifier).deleteAllScores();
    ref.read(highestScoreProvider.notifier).setHighestScore(value: 0);
  }

  void handleAppState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (overlays.activeOverlays.isEmpty) {
          resumeGame();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        if (overlays.activeOverlays.isEmpty) {
          pauseGame();
        }
        break;
      default:
        break;
    }
  }
}
