import 'dart:ui';

import 'package:flame/components.dart';

import '../component/base_component.dart';

/// 作者：李佳奇
/// 日期：2022/3/31
/// 备注：


extension GameExtension<T extends WindowComponent> on List<T>{

  void onGameResize(Vector2 canvasSize) {
    forEach((element) => element.onGameResize(canvasSize));
  }

  void render(Canvas canvas) {
    forEach((element) => element.render(canvas));
  }

  void update(double dt) {
    forEach((element) => element.update(dt));
  }


}













