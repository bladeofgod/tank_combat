/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/game/tank_game.dart';

class BattleBackground with BaseComponent{

  final TankGame game;

  Sprite bgSprite;
  Rect bgRect;

  BattleBackground(this.game){
    bgSprite = Sprite('new_map.webp');
    bgRect = Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
  }

  @override
  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
//    canvas.drawRect(Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height)
//        , Paint()..color = Color(0xff27ae60));
  }

  @override
  void update(double t) {

  }

}



















