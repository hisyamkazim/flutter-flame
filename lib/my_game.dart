// ignore_for_file: unused_import

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/circle_rotator.dart';
import 'package:flutter_flame/color_switcher.dart';
import 'package:flutter_flame/ground.dart';
import 'package:flutter_flame/player.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter_flame/star_component.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  late Player myPlayer;
  final Ground ground = Ground(position: Vector2(0, 400));
  final ValueNotifier<int> currentScore = ValueNotifier(0);
  final ValueNotifier<bool> isGamePaused = ValueNotifier(false);
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
                CameraComponent.withFixedResolution(width: 600, height: 1000));

  @override
  Color backgroundColor() => const Color(0xff222222);

  @override
  Future<void> onLoad() async {
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

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = myPlayer.position.y;
    if (playerY < cameraY) {
      camera.viewfinder.position = myPlayer.position;
    } else if (playerY > (cameraY + camera.visibleWorldRect.height)) {
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
    overlays.add('MainMenu');
    (decorator as PaintDecorator).addBlur(10);
    currentScore.value = 0;
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
    _addComponentToTheGame(
        ColorSwitcher(position: generateFromPosition + Vector2(0, 180)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2.zero(),
        size: Vector2.all(200)));
    _addComponentToTheGame(
        StarComponent(position: generateFromPosition + Vector2.zero()));

    generateFromPosition -= Vector2(0, 370);
    _addComponentToTheGame(
        ColorSwitcher(position: generateFromPosition + Vector2(0, 180)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2.zero(),
        size: Vector2.all(200)));
    _addComponentToTheGame(
        StarComponent(position: generateFromPosition + Vector2.zero()));

    generateFromPosition -= Vector2(0, 240);
    _addComponentToTheGame(
        ColorSwitcher(position: generateFromPosition + Vector2(0, -200)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, -400),
        size: Vector2.all(150)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, -400),
        size: Vector2.all(180)));
    _addComponentToTheGame(
        StarComponent(position: generateFromPosition + Vector2(0, -400)));
  }

  void gameOver() {
    FlameAudio.bgm.stop();
    for (var child in world.children) {
      child.removeFromParent();
    }
    _gameComponents.clear();
    overlays.clear();
    isGamePaused.value = false;
    _initializeGame();
  }

  void pauseGame() {
    isGamePaused.value = true;
    FlameAudio.bgm.pause();
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0.0;
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    isGamePaused.value = false;
    FlameAudio.bgm.resume();
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1.0;
    overlays.remove('PauseMenu');
  }

  void increaseScore() {
    currentScore.value++;
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
    overlays.remove('MainMenu');
    (decorator as PaintDecorator).addBlur(0);
  }
}
