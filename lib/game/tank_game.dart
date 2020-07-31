/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tankcombat/component/background/background.dart';
import 'package:tankcombat/component/tank/bullet.dart';
import 'package:tankcombat/component/tank/enemy/green_tank.dart';
import 'package:tankcombat/component/tank/enemy/sand_tank.dart';
import 'package:tankcombat/component/tank/tank.dart';

class TankGame extends Game{
  Size screenSize;

  BattleBackground bg;

  //玩家
  Tank tank;

  //炮弹
  List<Bullet> bullets;

  //敌方tank
  //分开，也许需要特殊处理
  List<GreenTank> gTanks = [];
  List<SandTank> sTanks = [];


  TankGame(){

  }

  @override
  void render(Canvas canvas) {
    if(screenSize == null)return;
    //绘制草坪
    bg.render(canvas);
    //tank
    tank.render(canvas);
    //bullet
    bullets.forEach((element) {
      element.render(canvas);
    });
  }

  @override
  void update(double t) {
    if(screenSize == null)return;
    tank.update(t);
    bullets.forEach((element) {
      element.update(t);
    });
    //移除飞出屏幕的
    bullets.removeWhere((element) => element.isOffScreen);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    if(bg == null){
      bg = BattleBackground(this);
    }
    if(tank == null){
      tank = Tank(
        this,position: Offset(screenSize.width/2,screenSize.height/2),
      );
    }
    if(bullets == null){
      bullets = List();
    }

  }

  void onLeftJoypadChange(Offset offset){
    if(offset == Offset.zero){
      tank.targetBodyAngle = null;
    }else{
      tank.targetBodyAngle = offset.direction;//范围（pi,-pi）
    }
  }

  void onRightJoypadChange(Offset offset) {
    if (offset == Offset.zero) {
      tank.targetTurretAngle = null;
    } else {
      tank.targetTurretAngle = offset.direction;
    }
  }

  void onFireButtonTap(){
    bullets.add(Bullet(this,BulletColor.BLUE,position: tank.getBulletOffset(),angle: tank.getBulletAngle()));
  }

}























