/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:ui';

import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/game/tank_game.dart';

class BattleBackground with BaseComponent{

  final TankGame game;

  BattleBackground(this.game);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height)
        , Paint()..color = Color(0xff27ae60));
  }

  @override
  void update(double t) {

  }

}



















