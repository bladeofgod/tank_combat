/*
* Author : LiJiqqi
* Date : 2020/7/31
*/

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flutter/cupertino.dart';
import 'package:tankcombat/component/explosion/decoration_theater.dart';
import 'package:tankcombat/game/tank_game.dart';

///游戏裁判
/// * 用于观测[Sprite]之间的交互，并触发衍生交互，
/// * 如：是否击中、[OrangeExplosion]的触发等.
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




















