/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:tankcombat/component/background/background.dart';
import 'package:tankcombat/component/tank/bullet.dart';
import 'package:tankcombat/component/tank/enemy/green_tank.dart';
import 'package:tankcombat/component/tank/enemy/sand_tank.dart';
import 'package:tankcombat/component/tank/tank.dart';
import 'package:tankcombat/observer/game_observer.dart';

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

  GameObserver observer;

  TankGame(){
    observer = GameObserver(this);

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
    //enemy
    gTanks.forEach((element) {
      element.render(canvas);
    });
    sTanks.forEach((element) {
      element.render(canvas);
    });
  }

  @override
  void update(double t) {
    if(screenSize == null)return;
    tank.update(t);
    gTanks.forEach((element) {
      element.update(t);
    });
    sTanks.forEach((element) {
      element.update(t);
    });
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
    initEnemyTank();

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

  void initEnemyTank() {
    var turretSprite = Sprite('tank/t_turret_green.webp');
    var bodySprite= Sprite('tank/t_body_green.webp');
    gTanks.add(GreenTank(this,bodySprite,turretSprite, Offset(100,100)));
    gTanks.add(GreenTank(this,bodySprite,turretSprite, Offset(100,screenSize.height*0.8)));


    ///sand
    var turretSpriteS = Sprite('tank/t_turret_sand.webp');
    var bodySpriteS = Sprite('tank/t_body_sand.webp');
    sTanks.add( SandTank(this,bodySpriteS,turretSpriteS,
        Offset(screenSize.width-100,100)));
    sTanks.add( SandTank(this,bodySpriteS,turretSpriteS,
            Offset(screenSize.width-100,screenSize.height*0.8)));
  }



}























