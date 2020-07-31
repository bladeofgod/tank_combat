/*
* Author : LiJiqqi
* Date : 2020/7/31
*/

import 'dart:math';

import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'package:flutter/cupertino.dart';
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

  void watching(){
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
  }



  spawnTank(TankCate tankCate) {
    switch(tankCate){
      case TankCate.GreenTank:
        var turretSprite = Sprite('tank/t_turret_green.webp');
        var bodySprite= Sprite('tank/t_body_green.webp');
        double r = Random().nextDouble();
        game.gTanks.add( GreenTank(game,bodySprite,turretSprite,
              r < 0.5 ? Offset(100,100)
                  :Offset(100,game.screenSize.height*0.8)));
        break;
      case TankCate.SandTank:
        var turretSprite = Sprite('tank/t_turret_sand.webp');
        var bodySprite= Sprite('tank/t_body_sand.webp');
        double r = Random().nextDouble();
        game.sTanks.add( SandTank(game,bodySprite,turretSprite,
            r < 0.5 ? Offset(game.screenSize.width-100,100)
                :Offset(game.screenSize.width-100,game.screenSize.height*0.8)));
        break;
    }
    isGenerating = false;
  }

  void coolDown(Function task) {
    Future.delayed(Duration(milliseconds: 1500)).then((value) => task());
  }


}




















