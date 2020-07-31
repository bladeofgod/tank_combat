/*
* Author : LiJiqqi
* Date : 2020/7/31
*/


import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:tankcombat/game/tank_game.dart';

abstract class TankModel{
  final TankGame game;
  Sprite bodySprite,turretSprite;
  //出生位置
  Offset position;

  TankModel(this.game,this.bodySprite,this.turretSprite,{this.position});


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

  final double ration = 0.7;
}



















