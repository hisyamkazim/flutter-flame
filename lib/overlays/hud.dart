import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/riverpod.dart';

class Hud extends PositionComponent
    with HasGameReference<MyGame>, RiverpodComponentMixin {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;
  int currentValue = 0;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() {
      ref.listen(scoreProvider, (p0, p1) {
        currentValue = p1;
        _scoreTextComponent.text = 'Score: ${currentValue.toString()}';
      });
    });
    super.onMount();

    _scoreTextComponent = TextComponent(
      text: 'Score: ${currentValue.toString()}',
      textRenderer: TextPaint(
        style: const TextStyle(
            backgroundColor: Colors.black,
            fontSize: 32,
            color: Colors.white,
            overflow: TextOverflow.visible),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, 20),
    );

    add(_scoreTextComponent);
  }
}
