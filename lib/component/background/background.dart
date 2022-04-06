
/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:tankcombat/component/base_component.dart';
import 'package:vector_math/vector_math_64.dart';

///游戏背景
class BattleBackground extends WindowComponent {

  BattleBackground() {
    init();
  }

  Sprite? bgSprite;
  Rect? bgRect;

  void init() async {
    bgSprite = await Sprite.load('new_map.webp');
  }

  @override
  void render(Canvas canvas) {
    bgSprite?.renderRect(canvas, bgRect ?? Rect.zero);
  }

  @override
  void update(double t) {}

  @override
  void onGameResize(Vector2 canvasSize) {
    bgRect = Rect.fromLTWH(0, 0, canvasSize.storage.first, canvasSize.storage.last);
    super.onGameResize(canvasSize);
  }
}

