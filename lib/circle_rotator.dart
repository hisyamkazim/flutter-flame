import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:infinite_circle/my_game.dart';
import 'dart:math' as math;

class CircleRotator extends PositionComponent with HasGameReference<MyGame> {
  CircleRotator(
      {required super.position,
      required super.size,
      this.thickness = 8,
      this.rotationSpeed = 2})
      : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  final double thickness;
  final double rotationSpeed;
  final _arcPaint = Paint();

  @override
  void onLoad() {
    super.onLoad();
    const circle = math.pi * 2;
    final sweep = circle / game.gameColors.length;
    for (int i = 0; i < game.gameColors.length; i++) {
      add(CircleArc(
          color: game.gameColors[i], startAngle: i * sweep, sweepAngle: sweep));
    }
    add(RotateEffect.to(
        circle, EffectController(speed: rotationSpeed, infinite: true)));
  }
}

class CircleArc extends PositionComponent with ParentIsA<CircleRotator> {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  CircleArc(
      {required this.color, required this.startAngle, required this.sweepAngle})
      : super(anchor: Anchor.center);

  @override
  void onMount() {
    size = parent.size;
    position = size / 2;
    _addHitbox();
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
        size.toRect().deflate(parent.thickness / 2),
        startAngle,
        sweepAngle,
        false,
        parent._arcPaint
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = parent.thickness);
  }

  void _addHitbox() {
    final center = size / 2;
    const precision = 8;
    final segment = sweepAngle / (precision - 1);
    List<Vector2> vertices = [];
    final radius = size.x / 2;

    for (int i = 0; i < precision; i++) {
      final thisSegment = startAngle + segment * i;
      vertices.add(center +
          Vector2(math.cos(thisSegment), math.sin(thisSegment)) * radius);
    }
    for (int i = precision - 1; i >= 0; i--) {
      final thisSegment = startAngle + segment * i;
      vertices.add(center +
          Vector2(math.cos(thisSegment), math.sin(thisSegment)) *
              (radius - parent.thickness));
    }
    add(PolygonHitbox(vertices, collisionType: CollisionType.passive));
  }
}
