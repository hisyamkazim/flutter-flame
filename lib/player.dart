// ignore_for_file: unused_import

import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:infinite_circle/circle_rotator.dart';
import 'package:infinite_circle/color_switcher.dart';
import 'package:infinite_circle/constant/assets.dart';
import 'package:infinite_circle/constant/keys.dart';
import 'package:infinite_circle/ground.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/controller/riverpod.dart';
import 'package:infinite_circle/star_component.dart';

class Player extends PositionComponent
    with HasGameReference<MyGame>, CollisionCallbacks, RiverpodComponentMixin {
  Player({this.playerRadius = 12, required super.position})
      : super(priority: 20);

  final _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  final double playerRadius;
  final _playerPaint = Paint();

  Color _color = Colors.white;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
        radius: playerRadius,
        anchor: anchor,
        collisionType: CollisionType.active));
  }

  @override
  void onMount() {
    size = Vector2.all(playerRadius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;

    Ground ground = game.findByKeyName(groundKeyName)!;
    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      _velocity.setZero();
      position.setValues(0, ground.position.y - (height / 2));
    } else {
      _velocity.y += _gravity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      (size / 2).toOffset(),
      playerRadius,
      _playerPaint..color = _color,
    );
  }

  void jump() {
    _velocity.y = -_jumpSpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ColorSwitcher) {
      other.removeFromParent();
      _changeColorRandomly();
    } else if (other is CircleArc) {
      if (_color != other.color) {
        game.gameOver();
      }
    } else if (other is StarComponent) {
      other.showCollectEffect();
      game.increaseScore();
      FlameAudio.play(collectSoundPath);
      game.checkToGenerateNextBatch(other);
    }
  }

  void _changeColorRandomly() {
    _color = game.gameColors.random();
  }
}
