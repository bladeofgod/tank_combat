/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:math';
import 'dart:ui';

import 'package:tankcombat/component/base_component.dart';
import 'package:tankcombat/game/tank_game.dart';

class Tank extends BaseComponent{

  final TankGame game;

  Tank(this.game,{this.position});

  //出生位置
  Offset position;
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



  @override
  void render(Canvas canvas) {
    if(isDead) return;
    drawBody(canvas);
  }


  @override
  void update(double t) {
    //时间增量t 旋转速率
//    rotateBody(t);
//    rotateTurret(t);
//    moveTank(t);
  }

  final Paint lightPaint = Paint()..color = Color(0xffdddddd);
  final Paint darkPaint = Paint()..color = Color(0xff777777);

  void drawBody(Canvas canvas) {
    //将canvas 原点设置在tank上
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(bodyAngle);

    //绘制tank身体
    canvas.drawRect(Rect.fromLTWH(-20, -15, 40, 30), lightPaint);

    //绘制轮子
    canvas.drawRect(Rect.fromLTWH(-24, -23, 48, 8), darkPaint);
    canvas.drawRect(
      Rect.fromLTWH(-24, 15, 48, 8),
      darkPaint,
    );
    //旋转炮台
    canvas.rotate(turretAngle);
    // 绘制炮塔
    canvas.drawRect(
      Rect.fromLTWH(-10, -12, 25, 24),
      darkPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, -3, 36, 6),
      darkPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(36, -5, 6, 10),
      darkPaint,
    );
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

}





















