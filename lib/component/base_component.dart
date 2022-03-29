/*
* Author : LiJiqqi
* Date : 2020/7/30
*/


import 'package:flame/components.dart';
import 'package:flutter/material.dart';

//todo 替代为 PositionComponent
abstract class BaseComponent{

  void render(Canvas canvas);

  void update(double t);

}


abstract class WindowComponent extends BaseComponent{

  void onGameResize(Vector2 canvasSize);

}
