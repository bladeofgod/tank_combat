/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:tankcombat/component/background/background.dart';
import 'package:tankcombat/component/explosion/explosion.dart';
import 'package:tankcombat/component/tank/enemy/tank_model.dart';
import 'package:tankcombat/component/tank/tank.dart';
import 'package:tankcombat/observer/game_observer.dart';
import 'package:tankcombat/utils/computer_timer.dart';
import '../utils/extension.dart';

import '../component/tank/bullet.dart';
import '../component/tank/tank_factory.dart';
import '../controller/controller_listener.dart';
import 'game_action.dart';

class TankGame extends FlameGame with BulletTheater, TankTheater, ComputerTimer{

  TankGame() {
    observer = GameObserver(this);
    setTimerListener(this);
  }

  late Size screenSize;

  final BattleBackground bg = BattleBackground();


  //敌方tank
  //分开，也许需要特殊处理
  List<GreenTank> gTanks = [];
  List<SandTank> sTanks = [];

  //爆炸动画
  List<OrangeExplosion> explosions = [];

  late GameObserver observer;



  @override
  void onGameResize(Vector2 canvasSize) {
    screenSize = canvasSize.toSize();
    bg.onGameResize(canvasSize);
    if(tank == null){
      tank = Tank(
        this,position: Offset(screenSize.width/2,screenSize.height/2),
      );
    }

    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    //绘制草坪
    bg.render(canvas);
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




}

mixin TankTheater on FlameGame, BulletTheater implements TankController, ComputerTimerListener{

  PlayerTank? player;

  final List<ComputerTank> computers = [];

  void initPlayer() {
    final Size bgSize = canvasSize.toSize();

    final TankModelBuilder playerBuilder = TankModelBuilder(
        id: DateTime.now().millisecondsSinceEpoch,
        bodySpritePath: 'tank/t_body_blue.webp',
        turretSpritePath: 'tank/t_turret_blue.webp',
        activeSize: bgSize);

    player ??= TankFactory.buildPlayerTank(playerBuilder.build()
        , Offset(bgSize.width/2,bgSize.height/2));
  }

  ///初始化敌军
  void initEnemyTank() {

    final Size bgSize = canvasSize.toSize();

    final TankModelBuilder greenBuilder = TankModelBuilder(
        id: DateTime.now().millisecondsSinceEpoch,
        bodySpritePath: 'tank/t_body_green.webp',
      turretSpritePath: 'tank/t_turret_green.webp',
      activeSize: bgSize);

    computers.add(TankFactory.buildGreenTank(greenBuilder.build(), const Offset(100,100)));
    computers.add(TankFactory.buildGreenTank(greenBuilder.build(), Offset(100, bgSize.height*0.8)));


    final TankModelBuilder sandBuilder = TankModelBuilder(
        id: DateTime.now().millisecondsSinceEpoch,
        bodySpritePath: 'tank/t_body_sand.webp',
        turretSpritePath: 'tank/t_turret_sand.webp',
        activeSize: bgSize);

    computers.add(TankFactory.buildSandTank(sandBuilder.build(), Offset(bgSize.width-100,100)));
    computers.add(TankFactory.buildSandTank(sandBuilder.build(), Offset(bgSize.width-100, bgSize.height*0.8)));
  }

  @override
  void onFireTimerTrigger() {
    computers.shuffle();
    computers.forEach(computerTankFire);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    if(player == null) {
      initPlayer();
    }
    if(computers.isEmpty) {
      initEnemyTank();
    }
    player?.onGameResize(canvasSize);
    computers.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    player?.render(canvas);
    computers.render(canvas);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    player?.update(dt);
    computers.update(dt);
    super.update(dt);
  }

  @override
  void fireButtonTriggered() {
    if(player != null){
      playerTankFire(player!);
    }
  }

  @override
  void bodyAngleChanged(Offset newAngle) {
    if(newAngle == Offset.zero){
      player?.targetBodyAngle = null;
    }else{
      player?.targetBodyAngle = newAngle.direction;//范围（pi,-pi）
    }
  }

  @override
  void turretAngleChanged(Offset newAngle) {
    if (newAngle == Offset.zero) {
      player?.targetTurretAngle = null;
    } else {
      player?.targetTurretAngle = newAngle.direction;
    }
  }

}


mixin BulletTheater on FlameGame implements ComputerTankAction{
  //
  // ///电脑炮弹最大数量
  // ///绿色炮弹数量
  // final int maxGreenBulletNum = 10;
  // ///黄色炮弹数量
  // final int maxSandBulletNum = 10;

  ///玩家炮弹最大数量
  final int maxPlayerBulletNum = 20;


  List<BaseBullet> computerBullets = [];

  List<BaseBullet> playerBullets = [];

  void playerTankFire(TankFireHelper helper) {
    if(playerBullets.length < maxPlayerBulletNum) {
      playerBullets.add(helper.getBullet());
    }
  }

  @override
  void computerTankFire(TankFireHelper helper) {
    //todo 间隔 x ms发射

  }

  @override
  void onGameResize(Vector2 canvasSize) {
    computerBullets.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    computerBullets.render(canvas);
    super.render(canvas);
  }


  @override
  void update(double dt) {
    computerBullets.update(dt);
    super.update(dt);
  }


}























