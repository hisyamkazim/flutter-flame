import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:color_flip_go/constant/assets.dart';
import 'package:color_flip_go/constant/keys.dart';

class Ground extends PositionComponent with RiverpodComponentMixin {
  Ground({required super.position})
      : super(
            size: Vector2(200, 4),
            anchor: Anchor.center,
            key: ComponentKey.named(groundKeyName));

  late Sprite fingerSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    fingerSprite = await Sprite.load(groundPath);
  }

  @override
  void render(Canvas canvas) {
    fingerSprite.render(canvas,
        size: Vector2.all(100), position: Vector2(50, -10));
  }
}
