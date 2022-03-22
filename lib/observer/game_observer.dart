/*
* Author : LiJiqqi
* Date : 2020/7/31
*/

import 'dart:math';

import 'package:flame/sprite.dart';

import 'package:flutter/cupertino.dart';
import 'package:tankcombat/component/explosion/explosion.dart';
import 'package:tankcombat/component/tank/bullet.dart';
import 'package:tankcombat/component/tank/enemy/green_tank.dart';
import 'package:tankcombat/component/tank/enemy/sand_tank.dart';
import 'package:tankcombat/game/tank_game.dart';

enum TankCate{
  GreenTank,SandTank
}

class GameObserver{

  final TankGame game;

  GameObserver(this.game);

  bool isGenerating = false;

  void watching(double t){
    if(!isGenerating){
      if(game.gTanks.length<2){
        isGenerating = true;
        coolDown(spawnTank(TankCate.GreenTank));
        return;
      }
      if(game.sTanks.length<2){
        isGenerating = true;
        coolDown(spawnTank(TankCate.SandTank));
        return;
      }
    }
    ///check hit
    checkHit();
  }



  spawnTank(TankCate tankCate) async {
    switch(tankCate){
      case TankCate.GreenTank:
        var turretSprite = await Sprite.load('tank/t_turret_green.webp');
        var bodySprite= await Sprite.load('tank/t_body_green.webp');
        double r = Random().nextDouble();
        game.gTanks.add( GreenTank(game,bodySprite,turretSprite,
              r < 0.5 ? Offset(100,100)
                  :Offset(100,game.screenSize.height*0.8)));
        break;
      case TankCate.SandTank:
        var turretSprite = await Sprite.load('tank/t_turret_sand.webp');
        var bodySprite= await Sprite.load('tank/t_body_sand.webp');
        double r = Random().nextDouble();
        game.sTanks.add( SandTank(game,bodySprite,turretSprite,
            r < 0.5 ? Offset(game.screenSize.width-100,100)
                :Offset(game.screenSize.width-100,game.screenSize.height*0.8)));
        break;
    }
    isGenerating = false;
  }

  void coolDown(Function task) {
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      if(task != null){
        task();
      }
    });
  }



  double hitDistance = 10;

  ///检查是否有tank被击中
  void checkHit() {
    game.bullets.forEach((bullet) {
      switch(bullet.bulletColor){
        //玩家对敌军
        case BulletColor.BLUE:
          game.gTanks.forEach((gt) {

            Offset zone =gt.position - bullet.position;

            if(zone.distance < hitDistance){
              //hit
              gt.isDead = true;
              bullet.isHit = true;
              //添加爆炸
              addExplosion(gt.position);
            }
          });
          game.sTanks.forEach((st) {
            Offset zone =st.position - bullet.position;
            if(zone.distance < hitDistance){
              st.isDead = true;
              bullet.isHit = true;
              addExplosion(st.position);
            }
          });
          break;

          ///敌军对玩家
        ///暂时不写了，打不过 ...
        case BulletColor.GREEN:

          break;
        case BulletColor.SAND:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void addExplosion(Offset position){
    game.explosions.add(OrangeExplosion(game, position));
  }


}




















