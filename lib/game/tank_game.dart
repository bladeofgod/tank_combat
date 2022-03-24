/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:tankcombat/component/background/background.dart';
import 'package:tankcombat/component/explosion/explosion.dart';
import 'package:tankcombat/component/tank/bullet.dart';
import 'package:tankcombat/component/tank/enemy/green_tank.dart';
import 'package:tankcombat/component/tank/enemy/sand_tank.dart';
import 'package:tankcombat/component/tank/enemy/tank_model.dart';
import 'package:tankcombat/component/tank/tank.dart';
import 'package:tankcombat/observer/game_observer.dart';

import '../controller/controller_listener.dart';

class TankGame extends FlameGame with TankController{
  late Size screenSize;

  BattleBackground? bg;

  //玩家
  Tank? tank;

  //炮弹
  List<Bullet> bullets = [];
  //绿色炮弹数量
  int greenBulletNum = 0;
  //黄色炮弹数量
  int sandBulletNum = 0;
  //蓝色炮弹数量
  int blueBulletNum = 0;


  //敌方tank
  //分开，也许需要特殊处理
  List<GreenTank> gTanks = [];
  List<SandTank> sTanks = [];

  //爆炸动画
  List<OrangeExplosion> explosions = [];

  late GameObserver observer;

  TankGame(){
    observer = GameObserver(this);

  }

  @override
  void onGameResize(Vector2 canvasSize) {
    resize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    //绘制草坪
    bg?.render(canvas);
    //tank
    tank?.render(canvas);
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
    //爆炸
    explosions.forEach((element) {element.render(canvas);});
    super.render(canvas);
  }

  @override
  void update(double t) {
    if(screenSize == null)return;
    tank?.update(t);
    gTanks.forEach((element) {
      element.update(t);
    });
    sTanks.forEach((element) {
      element.update(t);
    });
    blueBulletNum = 0;
    greenBulletNum = 0;
    sandBulletNum = 0;
    bullets.forEach((element) {
      switch(element.bulletColor){

        case BulletColor.BLUE:
          blueBulletNum ++;
          break;
        case BulletColor.GREEN:
          greenBulletNum ++;
          break;
        case BulletColor.SAND:
          sandBulletNum ++;
          break;
      }
      element.update(t);
    });
    //移除飞出屏幕的
    bullets.removeWhere((element) => element.isHit || element.isOffScreen);
    //移除死亡tank
    gTanks.removeWhere((element) => element.isDead);
    sTanks.removeWhere((element) => element.isDead);

    //移除爆炸
    explosions.removeWhere((element) => element.playDone);
    //爆炸
    explosions.forEach((element) {element.update(t);});

    observer.watching(t);

  }

  void resize(Vector2 canvasSize) {
    screenSize = Size(canvasSize.storage.first, canvasSize.storage.last);
    //initEnemyTank();
    if(bg == null){
      bg = BattleBackground(this);
    }
    if(tank == null){
      tank = Tank(
        this,position: Offset(screenSize.width/2,screenSize.height/2),
      );
    }
  }


  void enemyTankFire<T extends TankModel>(BulletColor color,T tankModel){
    bullets.add(Bullet(this,color,tankModel.id
        ,position: tankModel.getBulletOffset(),angle: tankModel.getBulletAngle()));
  }


  ///初始化敌军
  void initEnemyTank() async {
    var turretSprite = await Sprite.load('tank/t_turret_green.webp');
    var bodySprite= await Sprite.load('tank/t_body_green.webp');
    gTanks.add(GreenTank(this,bodySprite,turretSprite, Offset(100,100)));
    gTanks.add(GreenTank(this,bodySprite,turretSprite, Offset(100,screenSize.height*0.8)));


    ///sand
    var turretSpriteS = await Sprite.load('tank/t_turret_sand.webp');
    var bodySpriteS = await Sprite.load('tank/t_body_sand.webp');
    sTanks.add( SandTank(this,bodySpriteS,turretSpriteS,
        Offset(screenSize.width-100,100)));
    sTanks.add( SandTank(this,bodySpriteS,turretSpriteS,
            Offset(screenSize.width-100,screenSize.height*0.8)));
  }

  @override
  void fireButtonTriggered() {
    if(blueBulletNum < 20 && tank != null){
      bullets.add(Bullet(this,BulletColor.BLUE,tank!.tankId
          ,position: tank!.getBulletOffset(),angle: tank!.getBulletAngle()));
    }
  }

  @override
  void bodyAngleChanged(Offset newAngle) {
    if(newAngle == Offset.zero){
      tank?.targetBodyAngle = null;
    }else{
      tank?.targetBodyAngle = newAngle.direction;//范围（pi,-pi）
    }
  }

  @override
  void turretAngleChanged(Offset newAngle) {
    if (newAngle == Offset.zero) {
      tank?.targetTurretAngle = null;
    } else {
      tank?.targetTurretAngle = newAngle.direction;
    }
  }



}























