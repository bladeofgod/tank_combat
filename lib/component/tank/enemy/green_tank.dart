/*
* Author : LiJiqqi
* Date : 2020/7/31
*/

import 'dart:math';
import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/component/tank/enemy/tank_model.dart';
import 'package:tankcombat/game/tank_game.dart';

class GreenTank extends TankModel with BaseComponent{
  GreenTank(TankGame game, Sprite bodySprite, Sprite turretSprite) : super(game, bodySprite, turretSprite);

  @override
  void render(Canvas canvas) {
    // TODO: implement render
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  void drawBody(Canvas canvas) {
    //将canvas 原点设置在tank上
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(bodyAngle);

    //绘制tank身体

    bodySprite.renderRect(canvas,Rect.fromLTWH(-20*ration, -15*ration, 38*ration, 32*ration));

    //旋转炮台
    canvas.rotate(turretAngle);
    // 绘制炮塔
    turretSprite.renderRect(canvas, Rect.fromLTWH(-1, -2*ration, 22*ration, 6*ration));

    canvas.restore();

  }

  void rotateBody(double t) {
    final double rotationRate = pi * t;

    if (targetBodyAngle != null) {
      if (bodyAngle < targetBodyAngle) {
        //车体角度和目标角度差额
        if ((targetBodyAngle - bodyAngle).abs() > pi) {
          bodyAngle = bodyAngle - rotationRate;
          if (bodyAngle < -pi) {
            bodyAngle += pi * 2;
          }
        } else {
          bodyAngle = bodyAngle + rotationRate;
          if (bodyAngle > targetBodyAngle) {
            bodyAngle = targetBodyAngle;
          }
        }
      }
      if (bodyAngle > targetBodyAngle) {
        if ((targetBodyAngle - bodyAngle).abs() > pi) {
          bodyAngle = bodyAngle + rotationRate;
          if (bodyAngle > pi) {
            bodyAngle -= pi * 2;
          }
        } else {
          bodyAngle = bodyAngle - rotationRate;
          if (bodyAngle < targetBodyAngle) {
            bodyAngle = targetBodyAngle;
          }
        }
      }
    }
  }

  void rotateTurret(double t) {
    final double rotationRate = pi * t;

    if(targetTurretAngle != null){
      double localTargetTurretAngle = targetTurretAngle - bodyAngle;
      if(turretAngle < localTargetTurretAngle){
        if((localTargetTurretAngle -turretAngle).abs() > pi){
          turretAngle = turretAngle - rotationRate;
          //超出临界值，进行转换 即：小于-pi时，转换成pi之后继续累加，具体参考 笛卡尔坐标，范围是（-pi,pi）
          if(turretAngle < -pi){
            turretAngle += pi*2;
          }
        }else{
          turretAngle = turretAngle + rotationRate;
          if(turretAngle > localTargetTurretAngle){
            turretAngle = localTargetTurretAngle;
          }
        }
      }
      if(turretAngle > localTargetTurretAngle){
        if((localTargetTurretAngle - turretAngle).abs() > pi){
          turretAngle = turretAngle + rotationRate;
          if(turretAngle > pi){
            turretAngle -= pi*2;
          }
        }else{
          turretAngle = turretAngle - rotationRate;
          if(turretAngle < localTargetTurretAngle){
            turretAngle = localTargetTurretAngle;
          }
        }
      }
    }

  }

  void moveTank(double t) {
    if(targetBodyAngle != null){
      if(bodyAngle == targetBodyAngle){
        //tank 直线时 移动速度快
        position = position + Offset.fromDirection(bodyAngle,100*t);//100 是像素
      }else{
        //tank旋转时 移动速度要慢
        position = position + Offset.fromDirection(bodyAngle,50*t);
      }
    }
  }


  ///获取炮弹发射位置
  Offset getBulletOffset() {
    return position +
        Offset.fromDirection(
          getBulletAngle(),
          18,
        );
  }

  double getBulletAngle() {
    double bulletAngle = bodyAngle + turretAngle;
    while (bulletAngle > pi) {
      bulletAngle -= pi * 2;
    }
    while (bulletAngle < -pi) {
      bulletAngle += pi * 2;
    }
    return bulletAngle;
  }

}
























