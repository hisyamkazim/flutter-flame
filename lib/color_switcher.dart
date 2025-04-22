import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'package:infinite_circle/my_game.dart';

class ColorSwitcher extends PositionComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final double radius;
  final _arcPaint = Paint();

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
    final sweepAngle = circle / game.gameColors.length;
    for (int i = 0; i < game.gameColors.length; i++) {
      canvas.drawArc(
          size.toRect(),
          i * sweepAngle,
          sweepAngle,
          true,
          _arcPaint
            ..color = game.gameColors[i]
            ..style = PaintingStyle.fill);
    }
  }
}
