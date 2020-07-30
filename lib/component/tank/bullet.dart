/*
* Author : LiJiqqi
* Date : 2020/7/30
*/
import 'dart:ui';

import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/game/tank_game.dart';

class Bullet extends BaseComponent{

  final TankGame game;
  final double speed = 300;
  Offset position;
  double angle = 0;
  bool isOffScreen = false;

  Bullet(this.game,{this.position,this.angle});

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    canvas.drawRect(
      Rect.fromLTWH(-10, -3, 16, 6), Paint()..color = Color(0xffff0000),);
    canvas.restore();
  }

  @override
  void update(double t) {
    if(isOffScreen)return;

    position = position + Offset.fromDirection(angle,speed * t);
    if (position.dx < -50) {
      isOffScreen = true;
    }
    if (position.dx > game.screenSize.width + 50) {
      isOffScreen = true;
    }
    if (position.dy < -50) {
      isOffScreen = true;
    }
    if (position.dy > game.screenSize.height + 50) {
      isOffScreen = true;
    }
  }

}