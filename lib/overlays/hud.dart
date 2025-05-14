import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_circle/my_game.dart';
import 'package:infinite_circle/controller/riverpod.dart';
import 'package:infinite_circle/star_component.dart';

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
  late StarComponent _starComponent;
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
        _scoreTextComponent.text = 'x ${currentValue.toString()}';
      });
    });
    super.onMount();

    _scoreTextComponent = TextComponent(
      text: 'x ${currentValue.toString()}',
      textRenderer: TextPaint(
        style: GoogleFonts.pixelifySans(
          letterSpacing: 2,
          fontSize: 32,
          color: Colors.white,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, 20),
    );

    _starComponent = StarComponent(
      position: Vector2(positionOf(_scoreTextComponent.position).x - 50, 20),
    );

    addAll([_scoreTextComponent, _starComponent]);
  }
}
