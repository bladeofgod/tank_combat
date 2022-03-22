/*
* Author : LiJiqqi
* Date : 2020/7/30
*/
import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/game/tank_game.dart';


///blue for player
/// green&sand for enemy
enum BulletColor{
  BLUE,GREEN,SAND
}


class Bullet extends BaseComponent{

  final TankGame game;
  final double speed;
  final int tankId;
  Offset position;
  double angle = 0;
  bool isOffScreen = false;

  Sprite blueSprite;
  Sprite greenSprite;
  Sprite sandSprite ;
  final BulletColor bulletColor;

  Bullet(this.game,this.bulletColor,this.tankId,{this.position,this.angle,this.speed = 200}) {
    init();
  }

  void init() async {
    blueSprite = await Sprite.load('tank/bullet_blue.webp');
    greenSprite = await Sprite.load('tank/bullet_green.webp');
    sandSprite = await Sprite.load('tank/bullet_green.webp');
  }

  //是否击中
  bool isHit = false;

  @override
  void render(Canvas canvas) {
    if(isHit) return;
    if(isOffScreen)return;
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    switch(bulletColor){

      case BulletColor.BLUE:
        blueSprite.renderRect(canvas, Rect.fromLTWH(-4, -2, 8, 4));
        break;
      case BulletColor.GREEN:
        greenSprite.renderRect(canvas, Rect.fromLTWH(-4, -2, 6, 4));
        break;
      case BulletColor.SAND:
        sandSprite.renderRect(canvas, Rect.fromLTWH(-4, -2, 6, 4));
        break;
    }
//    canvas.drawRect(
//      Rect.fromLTWH(-10, -3, 16, 6), Paint()..color = Color(0xffff0000),);
    canvas.restore();
  }

  @override
  void update(double t) {
    if(isHit) return;
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