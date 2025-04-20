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
  final ValueNotifier<int> currentScore = ValueNotifier(0);

  final List<Color> gameColors;

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
    // camera.viewfinder.position = myPlayer.position;
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
    currentScore.value = 0;
    camera.moveTo(Vector2.zero());
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    _generateGameComponents();
    FlameAudio.bgm.play('soundtrack.mp3');
  }

  void _generateGameComponents() {
    world.add(ColorSwitcher(position: Vector2(0, 180)));
    world.add(CircleRotator(position: Vector2.zero(), size: Vector2.all(200)));
    world.add(StarComponent(position: Vector2.zero()));
    world.add(ColorSwitcher(position: Vector2(0, -200)));
    world
        .add(CircleRotator(position: Vector2(0, -400), size: Vector2.all(150)));
    world
        .add(CircleRotator(position: Vector2(0, -400), size: Vector2.all(180)));
    world.add(StarComponent(position: Vector2(0, -400)));
  }

  void gameOver() {
    FlameAudio.bgm.stop();
    for (var child in world.children) {
      child.removeFromParent();
    }
    _initializeGame();
  }

  bool get isGamePaused => timeScale == 0.0;
  bool get isGamePlaying => !isGamePaused;

  void pauseGame() {
    FlameAudio.bgm.pause();
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0.0;
  }

  void resumeGame() {
    FlameAudio.bgm.resume();
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1.0;
  }

  void increaseScore() {
    currentScore.value++;
  }
}
