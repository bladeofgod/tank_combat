
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:tankcombat/component/explosion/decoration_theater.dart';
import 'package:tankcombat/component/tank/tank_model.dart';
import 'package:tankcombat/observer/game_observer.dart';
import 'package:tankcombat/utils/computer_timer.dart';
import '../utils/extension.dart';

import '../component/tank/bullet.dart';
import '../component/tank/tank_factory.dart';
import '../controller/controller_listener.dart';
import 'game_action.dart';


///游戏入口
/// * 继承于[FlameGame]
/// * 所混入的类 : [BulletTheater]、[TankTheater]、[ComputerTimer]、[DecorationTheater]、[GameObserver]
/// *           用于拓展[TankGame]的场景内容和[Sprite]交互行为，具体见各自的注释。
class TankGame extends FlameGame with BulletTheater, TankTheater, ComputerTimer, DecorationTheater, GameObserver{

  TankGame() {
    setTimerListener(this);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double t) {
    super.update(t);
  }

}

///负责管理玩家和电脑tank
mixin TankTheater on FlameGame, BulletTheater implements TankController, ComputerTimerListener{

  ComputerTankSpawner _computerSpawner = ComputerTankSpawner();

  PlayerTank? player;

  final List<ComputerTank> computers = [];

  void initPlayer(Vector2 canvasSize) {
    final Size bgSize = canvasSize.toSize();

    final TankModelBuilder playerBuilder = TankModelBuilder(
        id: DateTime.now().millisecondsSinceEpoch,
        bodySpritePath: 'tank/t_body_blue.webp',
        turretSpritePath: 'tank/t_turret_blue.webp',
        activeSize: bgSize);

    player ??= TankFactory.buildPlayerTank(playerBuilder.build()
        , Offset(bgSize.width/2,bgSize.height/2));
    player!.deposit();
  }

  ///初始化敌军
  /// * 一般情况下是在游戏伊始时执行。
  void initEnemyTank() {
    _computerSpawner.fastSpawn(computers);
  }

  void randomSpanTank() {
    _computerSpawner.randomSpan(computers);
  }


  @override
  void onFireTimerTrigger() {
    computers.shuffle();
    computers.forEach(computerTankFire);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    if(player == null) {
      initPlayer(canvasSize);
    }
    if(computers.isEmpty) {
      _computerSpawner.warmUp(canvasSize.toSize());
      initEnemyTank();
      computers.forEach((element) => element.deposit());
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
    computers.removeWhere((element) => element.isDead);
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


///负责坦克的开火系统
mixin BulletTheater on FlameGame implements ComputerTankAction{

  ///电脑tank的开火器
  final BulletTrigger trigger = BulletTrigger();

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
    trigger.chargeLoading(() {
      computerBullets.add(helper.getBullet());
    });
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    computerBullets.onGameResize(canvasSize);
    playerBullets.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    computerBullets.render(canvas);
    playerBullets.render(canvas);
    super.render(canvas);
  }


  @override
  void update(double dt) {
    computerBullets.update(dt);
    playerBullets.update(dt);
    super.update(dt);
    computerBullets.removeWhere((element) => element.dismissible);
    playerBullets.removeWhere((element) => element.dismissible);
  }


}

