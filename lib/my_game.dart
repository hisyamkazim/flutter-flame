import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/player.dart';
import 'package:flame/game.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Player myPlayer;

  MyGame()
      : super(
            camera:
                CameraComponent.withFixedResolution(width: 600, height: 1000));

  @override
  Color backgroundColor() => const Color(0xff222222);

  @override
  void onMount() {
    world.add(myPlayer = Player());

    world.add(RectangleComponent(
        position: Vector2(-100, -100), size: Vector2.all(20)));
    world.add(
        RectangleComponent(position: Vector2(-200, 0), size: Vector2.all(20)));
    world.add(RectangleComponent(
        position: Vector2(-300, 100), size: Vector2.all(20)));
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
}
