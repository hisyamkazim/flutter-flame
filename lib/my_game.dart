// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_circle/circle_rotator.dart';
import 'package:infinite_circle/color_switcher.dart';
import 'package:infinite_circle/ground.dart';
import 'package:infinite_circle/overlays/hud.dart';
import 'package:infinite_circle/player.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:infinite_circle/riverpod.dart';
import 'package:infinite_circle/star_component.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await Flame.images
        .loadAll(['star_icon_white.png', '315851_finger_tap_icon.png']);
    await FlameAudio.audioCache.loadAll(['collect.wav', 'soundtrack.mp3']);
  }

  @override
  void onMount() {
    _initializeGame();

    super.onMount();
  }

  bool isGameOverTriggered = false;

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = myPlayer.position.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = myPlayer.position;
    } else if (playerY > (cameraY + camera.visibleWorldRect.height) &&
        overlays.activeOverlays.isEmpty &&
        !isGameOverTriggered) {
      isGameOverTriggered = true; // Prevent multiple triggers
      gameOver();
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    myPlayer.jump();
    super.onTapDown(event);
  }

  void _initializeGame() {
    overlays.add('MainMenu', priority: 1);
    camera.viewport.add(Hud());
    (decorator as PaintDecorator).addBlur(10);
    ref.read(scoreProvider.notifier).reset();
    world.add(ground);
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2.zero());
    _generateGameComponents(Vector2(0, 20));

    FlameAudio.bgm.play('soundtrack.mp3');
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
    final currentScore = ref.watch(scoreProvider);
    final highestScore = ref.watch(highestScoreProvider);

    if (highestScore < currentScore) {
      ref
          .read(highestScoreProvider.notifier)
          .setHighestScore(value: currentScore);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      overlays.add('GameOverMenu');
    });
  }

  void pauseGame() {
    ref.read(pauseStateProvider.notifier).toggle();
    FlameAudio.bgm.pause();
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0.0;
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pauseStateProvider.notifier).toggle();
      FlameAudio.bgm.resume();
      (decorator as PaintDecorator).addBlur(0);
      timeScale = 1.0;
      overlays.remove('PauseMenu');
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
    ref.read(pauseStateProvider.notifier).toggle();
    if (!(ref.watch(pauseStateProvider))) {
      overlays.remove('MainMenu');
      (decorator as PaintDecorator).addBlur(0);
    }
  }

  void resetGame() {
    ref.read(pauseStateProvider.notifier).toggle();
    FlameAudio.bgm.stop();
    for (var child in world.children) {
      child.removeFromParent();
    }
    _gameComponents.clear();
    overlays.remove('GameOverMenu');
    _initializeGame();
  }

  List<CircleRotator> makeMultiRotator(int n, Vector2 position, Vector2 size) {
    final List<CircleRotator> multiRotator = [];
    for (int i = 1; i <= n; i++) {
      multiRotator.add(CircleRotator(position: position, size: size));
      size.sub(Vector2.all(30));
    }
    return multiRotator;
  }
}
