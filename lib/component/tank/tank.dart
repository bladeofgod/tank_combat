/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/game/tank_game.dart';

class Tank extends BaseComponent{

  final TankGame game;

  Tank(this.game,{this.position});

  //出生位置
  Offset position;
  //车体角度
  double bodyAngle = 0;
  //炮塔角度
  double turretAngle = 0;

  //车体目标角度
  double targetBodyAngle;
  //炮塔目标角度
  double targetTurretAngle;

  //tank是否存活
  bool isDead = false;



  @override
  void render(Canvas canvas) {
    if(isDead) return;
    drawBody(canvas);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  void drawBody(Canvas canvas) {

  }

}





















