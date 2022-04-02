/*
* Author : LiJiqqi
* Date : 2020/7/31
*/

import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'package:flutter/cupertino.dart';
import 'package:tankcombat/component/explosion/decoration_theater.dart';
import 'package:tankcombat/game/tank_game.dart';

enum TankCate{
  GreenTank,SandTank
}

mixin GameObserver on FlameGame, TankTheater, DecorationTheater{

  @override
  void update(double dt) {
    super.update(dt);
    watching(dt);
  }

  void watching(double t) async {
    if(computers.length < 4) {
      randomSpanTank();
    }
    ///check hit
    checkHit();
  }

  ///命中距离
  /// * 车身位置和炮弹位置小于10 算命中
  final double hitDistance = 10;

  ///检查是否有tank被击中
  void checkHit() {
    playerBullets.forEach((bullet) {
      computers.forEach((c) {
        final Offset hitZone = c.position - bullet.position;
        if(hitZone.distance < hitDistance) {
          c.isDead = true;
          bullet.hit();
          addExplosions(c.position);
        }
      });
    });
    //todo 玩家无敌
    //computerBullets.forEach((element) { });
  }

}




















