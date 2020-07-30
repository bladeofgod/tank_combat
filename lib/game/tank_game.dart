/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tankcombat/component/background/background.dart';

class TankGame extends Game{

  Size screenSize;

  //背景
  BattleBackground bg ;


  @override
  void render(Canvas canvas) {
    if(screenSize == null) return;
    //绘制背景
    bg.render(canvas);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  @override
  void resize(Size size) {
    screenSize = size;
    if(bg == null){
      bg = BattleBackground(this);
    }
  }

}























