


import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/game/tank_game.dart';

class OrangeExplosion extends BaseComponent{

  final TankGame game;
  final Offset position;
  final List<Sprite> sprites = [];
  Rect exRect;

  int playIndex =0;

  bool playDone = false;

  OrangeExplosion(this.game,this.position){

    exRect = Rect.fromCenter(center: position,width: 30,height: 30);

    init();
  }

  void init() async {
    sprites.add(await Sprite.load('explosion/explosion1.webp'));
    sprites.add(await Sprite.load('explosion/explosion2.webp'));
    sprites.add(await Sprite.load('explosion/explosion3.webp'));
    sprites.add(await Sprite.load('explosion/explosion4.webp'));
    sprites.add(await Sprite.load('explosion/explosion5.webp'));
  }


  @override
  void render(Canvas canvas) {
    if(playDone)return;
    if(playIndex<5){
      sprites[playIndex].renderRect(canvas, exRect);
    }
  }


  double passedTime = 0;

  @override
  void update(double t) {
    if(playDone)return;
    if(playIndex<5){
      //1秒 5张图片
      passedTime +=t;
      playIndex = passedTime ~/ 0.2;
    }else{
      playDone = true;
    }
  }

}
























