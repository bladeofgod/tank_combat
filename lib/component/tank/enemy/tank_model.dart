/*
* Author : LiJiqqi
* Date : 2020/7/31
*/

import 'dart:math';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:tankcombat/game/tank_game.dart';

import '../../base_component.dart';

///坦克基础模型
abstract class BaseTankModel {
  BaseTankModel({
    required this.id,
    required this.bodySpritePath,
    required this.turretSpritePath,
    this.ratio = 0.7,
    this.speed = 80,
    this.turnSpeed = 40,
    this.bodyWidth = 38,
    this.bodyHeight = 32,
    this.turretWidth = 22,
    this.turretHeight = 6,
  });

  final int id;

  ///车体宽度
  final double bodyWidth;

  ///车体高度
  final double bodyHeight;

  ///炮塔宽度(长)
  final double turretWidth;

  ///炮塔高度(直径)
  final double turretHeight;

  ///坦克尺寸比例
  final double ratio;

  ///直线速度
  final double speed;

  ///转弯速度
  final double turnSpeed;

  ///车体纹理
  final String bodySpritePath;

  ///炮塔纹理
  final String turretSpritePath;

  ///车体
  Sprite? bodySprite;

  ///炮塔
  Sprite? turretSprite;

  ///配置完成
  bool isStandBy = false;

}

class DefaultTank extends BaseTank implements BaseComponent{

  DefaultTank({
    required int id,
    required Offset birthPosition,
    required String bodySpritePath,
    required String turretSpritePath})
      :
        super(id: id, birthPosition: birthPosition, bodySpritePath: bodySpritePath, turretSpritePath: turretSpritePath);


  @override
  void render(Canvas canvas) {
    if(!isStandBy || isDead) {
      return;
    }
    //将canvas 原点设置在tank上
    canvas.save();
    canvas.translate(position.dx, position.dy);
    drawBody(canvas);
    drawTurret(canvas);
    canvas.restore();
  }

  @override
  void update(double t) {
    if(!isStandBy || isDead) {
      return;
    }
    rotateBody(t);
    rotateTurret(t);
    move(t);

    //todo fire

  }

  @override
  void drawBody(Canvas canvas) {
    canvas.rotate(bodyAngle);
    bodySprite?.renderRect(canvas,bodyRect);
  }

  @override
  void drawTurret(Canvas canvas) {
    //旋转炮台
    canvas.rotate(turretAngle);
    // 绘制炮塔
    turretSprite?.renderRect(canvas, turretRect);
  }

  @override
  void move(double t) {
    if(targetOffset != null){
      movedDis += speed * t;
      //Offset target = targetOffset - position;
//        debugPrint('distance  ${target.distance}');
//        debugPrint('s   $s');
      if(movedDis < 100){
        if(bodyAngle == targetBodyAngle){
          //tank 直线时 移动速度快
          position = position + Offset.fromDirection(bodyAngle,speed*t);//100 是像素
        }else{
          //tank旋转时 移动速度要慢
          position = position + Offset.fromDirection(bodyAngle,turnSpeed*t);
        }
      }else{
        movedDis = 0;
        generateTargetOffset();

      }
    }
  }

  @override
  void rotateBody(double t) {
    final double rotationRate = pi * t;
    if (bodyAngle < targetBodyAngle) {
      //车体角度和目标角度差额
      if ((targetBodyAngle - bodyAngle).abs() > pi) {
        bodyAngle -= rotationRate;
        if (bodyAngle < -pi) {
          bodyAngle += pi * 2;
        }
      } else {
        bodyAngle += rotationRate;
        if (bodyAngle > targetBodyAngle) {
          bodyAngle = targetBodyAngle;
        }
      }
    } else if (bodyAngle > targetBodyAngle) {
      if ((targetBodyAngle - bodyAngle).abs() > pi) {
        bodyAngle += rotationRate;
        if (bodyAngle > pi) {
          bodyAngle -= pi * 2;
        }
      } else {
        bodyAngle -= rotationRate;
        if (bodyAngle < targetBodyAngle) {
          bodyAngle = targetBodyAngle;
        }
      }
    }
  }

  @override
  void rotateTurret(double t) {
    final double rotationRate = pi * t;

    double localTargetTurretAngle = targetTurretAngle - bodyAngle;
    if(turretAngle < localTargetTurretAngle){
      if((localTargetTurretAngle - turretAngle).abs() > pi){
        turretAngle -= rotationRate;
        //超出临界值，进行转换 即：小于-pi时，转换成pi之后继续累加，具体参考 笛卡尔坐标，范围是（-pi,pi）
        if(turretAngle < -pi){
          turretAngle += pi*2;
        }
      }else{
        turretAngle += rotationRate;
        if(turretAngle > localTargetTurretAngle){
          turretAngle = localTargetTurretAngle;
        }
      }
    }
    if(turretAngle > localTargetTurretAngle){
      if((localTargetTurretAngle - turretAngle).abs() > pi){
        turretAngle += rotationRate;
        if(turretAngle > pi){
          turretAngle -= pi*2;
        }
      }else{
        turretAngle -= rotationRate;
        if(turretAngle < localTargetTurretAngle){
          turretAngle = localTargetTurretAngle;
        }
      }
    }
  }

}

abstract class BaseTank extends BaseTankModel{
  BaseTank({required int id,
    required Offset birthPosition,
    required String bodySpritePath,
    required String turretSpritePath})
      : position = birthPosition,
        super(id: id, bodySpritePath: bodySpritePath, turretSpritePath: turretSpritePath) {
    bodyRect = Rect.fromCenter(center: Offset.zero, width: bodyWidth * ratio, height: bodyHeight * ratio);
    turretRect = Rect.fromCenter(center: Offset.zero, width: turretWidth * ratio, height: turretHeight * ratio);
    init();
  }

  ///坦克位置
  Offset position;

  ///移动到目标位置
  late Offset targetOffset;

  ///车体角度
  double bodyAngle = 0;

  ///炮塔角度
  double turretAngle = 0;

  ///车体目标角度
  late double targetBodyAngle;

  ///炮塔目标角度
  late double targetTurretAngle;

  ///车体尺寸
  late Rect bodyRect;

  ///炮塔尺寸
  late Rect turretRect;

  ///tank是否存活
  bool isDead = false;

  @mustCallSuper
  Future<bool> init() async {
    bodySprite = await Sprite.load(bodySpritePath);
    turretSprite = await Sprite.load(turretSpritePath);
    isStandBy = true;
    return isStandBy;
  }

  ///移动
  /// [t] 过渡时间-> 理论值16.66ms
  void move(double t);

  ///绘制车体
  void drawBody(Canvas canvas);

  ///绘制炮塔
  void drawTurret(Canvas canvas);

  ///旋转车体
  /// [t] 过渡时间-> 理论值16.66ms
  void rotateBody(double t);

  ///旋转炮塔
  /// [t] 过渡时间-> 理论值16.66ms
  void rotateTurret(double t);


}

abstract class TankModel {
  final int id;

  final TankGame game;
  Sprite bodySprite, turretSprite;

  //出生位置
  Offset position;

  TankModel(this.game, this.bodySprite, this.turretSprite, this.position) : id = DateTime.now().millisecondsSinceEpoch + Random().nextInt(100);

  ///随机生成路线用到
  final int seedNum = 50;
  final int seedRatio = 2;

  //移动的路线
  double movedDis = 0;

  //直线速度
  final double speed = 80;

  //转弯速度
  final double turnSpeed = 40;

  //车体角度
  double bodyAngle = 0;

  //炮塔角度
  double turretAngle = 0;

  //车体目标角度
  late double targetBodyAngle;

  //炮塔目标角度
  late double targetTurretAngle;

  //tank是否存活
  bool isDead = false;

  //移动到目标位置
  late Offset targetOffset;

  final double ration = 0.7;

  ///获取炮弹发射位置
  Offset getBulletOffset();

  double getBulletAngle();
}
