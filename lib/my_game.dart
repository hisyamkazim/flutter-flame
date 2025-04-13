import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/circle_rotator.dart';
import 'package:flutter_flame/color_switcher.dart';
import 'package:flutter_flame/ground.dart';
import 'package:flutter_flame/player.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Player myPlayer;

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
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    myPlayer.jump();
    super.onTapDown(event);
  }

  void _initializeGame() {
    camera.moveTo(Vector2.zero());
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer = Player(position: Vector2(0, 250)));
    _generateGameComponents();
  }

  void _generateGameComponents() {
    world.add(ColorSwitcher(position: Vector2(0, 180)));
    world.add(CircleRotator(position: Vector2.zero(), size: Vector2.all(200)));
    world.add(ColorSwitcher(position: Vector2(0, -200)));
    world
        .add(CircleRotator(position: Vector2(0, -400), size: Vector2.all(150)));
  }

  void gameOver() {
    for (var child in world.children) {
      child.removeFromParent();
    }
    _initializeGame();
  }
}
