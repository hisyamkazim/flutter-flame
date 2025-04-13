import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter_flame/my_game.dart';

class ColorSwitcher extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double radius;

  ColorSwitcher({
    required super.position,
    this.radius = 20,
  }) : super(size: Vector2.all(radius * 2), anchor: Anchor.center);

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
        radius: radius,
        anchor: anchor,
        position: size / 2,
        collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    const circle = math.pi * 2;
    final sweepAngle = circle / gameRef.gameColors.length;
    for (int i = 0; i < gameRef.gameColors.length; i++) {
      canvas.drawArc(
          size.toRect(),
          i * sweepAngle,
          sweepAngle,
          true,
          Paint()
            ..color = gameRef.gameColors[i]
            ..style = PaintingStyle.fill);
    }
  }
}
