/*
* Author : LiJiqqi
* Date : 2020/7/31
*/

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:tankcombat/component/tank/bullet.dart';

import '../../base_component.dart';
import '../tank_factory.dart';

///电脑
class ComputerTank extends DefaultTank {
  factory ComputerTank.green({
    required int id,
    required Offset birthPosition,
    required TankModel config,
  }) {
    return ComputerTank(
        id: id, birthPosition: birthPosition, config: config, bullet: ComputerBullet.green(tankId: id, activeSize: config.activeSize));
  }

  factory ComputerTank.sand({
    required int id,
    required Offset birthPosition,
    required TankModel config,
  }) {
    return ComputerTank(id: id, birthPosition: birthPosition, config: config, bullet: ComputerBullet.sand(tankId: id, activeSize: config.activeSize));
  }

  ComputerTank({
    required int id,
    required Offset birthPosition,
    required TankModel config,
    required this.bullet,
  }) : super(id: id, birthPosition: birthPosition, config: config);

  ///用于生成随机路线
  static final Random random = Random();

  ///活动边界
  static final double activeBorderLow = 0.01, activeBorderUp = 1 - activeBorderLow;

  ///最大单向移动距离
  static final double maxMovedDistance = 100;

  BaseBullet bullet;

  ///移动的距离
  double movedDis = 0;

  void generateNewTarget() {
    Future.delayed(const Duration(seconds: 1), () {
      final double x = random.nextDouble().clamp(activeBorderLow, activeBorderUp) * config.activeSize.width;
      final double y = random.nextDouble().clamp(activeBorderLow, activeBorderUp) * config.activeSize.height;

      targetOffset = Offset(x, y);

      final Offset vector = targetOffset - position;
      targetBodyAngle = vector.direction;
      targetTurretAngle = vector.direction;
    });
  }

  @override
  void deposit() {
    super.deposit();
    generateNewTarget();
  }

  @override
  void move(double t) {
    if (targetBodyAngle != null) {
      movedDis += speed * t;
      if (movedDis > maxMovedDistance) {
        super.move(t);
      } else {
        movedDis = 0;
        generateNewTarget();
      }
    }
  }

  @override
  BaseBullet getBullet() => bullet.copyWith(position: getBulletFirePosition(), angle: getBulletFireAngle());
}

///玩家
class PlayerTank extends DefaultTank {
  PlayerTank({required int id, required Offset birthPosition, required TankModel config})
      : bullet = PlayerBullet(tankId: id, activeSize: config.activeSize),
        super(id: id, birthPosition: birthPosition, config: config);

  final PlayerBullet bullet;

  @override
  BaseBullet getBullet() => bullet.copyWith(position: getBulletFirePosition(), angle: getBulletFireAngle());
}

abstract class DefaultTank extends BaseTank implements WindowComponent {
  DefaultTank({
    required int id,
    required Offset birthPosition,
    required TankModel config,
  }) : super(id: id, birthPosition: birthPosition, config: config);

  @override
  void deposit() {
    isDead = false;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    config.activeSize = canvasSize.toSize();
  }

  @override
  void render(Canvas canvas) {
    if (!isStandBy || isDead) {
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
    if (!isStandBy || isDead) {
      return;
    }
    rotateBody(t);
    rotateTurret(t);
    move(t);
  }

  @override
  void drawBody(Canvas canvas) {
    canvas.rotate(bodyAngle);
    bodySprite?.renderRect(canvas, bodyRect);
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
    if (targetBodyAngle == null) return;
    if (bodyAngle == targetBodyAngle) {
      //tank 直线时 移动速度快
      position += Offset.fromDirection(bodyAngle, speed * t); //100 是像素
    } else {
      //tank旋转时 移动速度要慢
      position += Offset.fromDirection(bodyAngle, turnSpeed * t);
    }
  }

  @override
  void rotateBody(double t) {
    if (targetBodyAngle != null) {
      final double rotationRate = pi * t;
      if (bodyAngle < targetBodyAngle!) {
        //车体角度和目标角度差额
        if ((targetBodyAngle! - bodyAngle).abs() > pi) {
          bodyAngle -= rotationRate;
          if (bodyAngle < -pi) {
            bodyAngle += pi * 2;
          }
        } else {
          bodyAngle += rotationRate;
          if (bodyAngle > targetBodyAngle!) {
            bodyAngle = targetBodyAngle!;
          }
        }
      } else if (bodyAngle > targetBodyAngle!) {
        if ((targetBodyAngle! - bodyAngle).abs() > pi) {
          bodyAngle += rotationRate;
          if (bodyAngle > pi) {
            bodyAngle -= pi * 2;
          }
        } else {
          bodyAngle -= rotationRate;
          if (bodyAngle < targetBodyAngle!) {
            bodyAngle = targetBodyAngle!;
          }
        }
      }
    }
  }

  @override
  void rotateTurret(double t) {
    if (targetTurretAngle != null) {
      final double rotationRate = pi * t;
      //炮塔和车身夹角
      final double localTargetTurretAngle = targetTurretAngle! - bodyAngle;
      if (turretAngle < localTargetTurretAngle) {
        if ((localTargetTurretAngle - turretAngle).abs() > pi) {
          turretAngle -= rotationRate;
          //超出临界值，进行转换 即：小于-pi时，转换成pi之后继续累加，具体参考 笛卡尔坐标，范围是（-pi,pi）
          if (turretAngle < -pi) {
            turretAngle += pi * 2;
          }
        } else {
          turretAngle += rotationRate;
          if (turretAngle > localTargetTurretAngle) {
            turretAngle = localTargetTurretAngle;
          }
        }
      }
      if (turretAngle > localTargetTurretAngle) {
        if ((localTargetTurretAngle - turretAngle).abs() > pi) {
          turretAngle += rotationRate;
          if (turretAngle > pi) {
            turretAngle -= pi * 2;
          }
        } else {
          turretAngle -= rotationRate;
          if (turretAngle < localTargetTurretAngle) {
            turretAngle = localTargetTurretAngle;
          }
        }
      }
    }
  }

  @override
  int getTankId() => id;

  @override
  double getBulletFireAngle() {
    double bulletAngle = bodyAngle + turretAngle;
    while (bulletAngle > pi) {
      bulletAngle -= pi * 2;
    }
    while (bulletAngle < -pi) {
      bulletAngle += pi * 2;
    }
    return bulletAngle;
  }

  @override
  Offset getBulletFirePosition() =>
      position +
      Offset.fromDirection(
        getBulletFireAngle(),
        bulletBornLoc,
      );
}

///tank 开火辅助接口
abstract class TankFireHelper {
  ///隶属于的坦克
  int getTankId();

  ///获取炮弹发射位置
  Offset getBulletFirePosition();

  ///获取炮弹发射角度
  double getBulletFireAngle();

  BaseBullet getBullet();
}

abstract class BaseTank implements TankFireHelper {
  BaseTank({
    required int id,
    required this.config,
    required Offset birthPosition,
  }) : position = birthPosition {
    bodyRect = Rect.fromCenter(center: Offset.zero, width: bodyWidth * ratio, height: bodyHeight * ratio);
    turretRect = Rect.fromCenter(center: Offset.zero, width: turretWidth * ratio, height: turretHeight * ratio);
    init();
  }

  final TankModel config;

  ///坦克位置
  Offset position;

  ///移动到目标位置
  late Offset targetOffset;

  ///车体角度
  double bodyAngle = 0;

  ///炮塔角度
  double turretAngle = 0;

  ///车体目标角度
  /// * 为空时，说明没有角度变动
  double? targetBodyAngle;

  ///炮塔目标角度
  /// * 为空时，说明没有角度变动
  double? targetTurretAngle;

  ///炮弹出炮口位置
  double get bulletBornLoc => 18;

  ///车体尺寸
  late Rect bodyRect;

  ///炮塔尺寸
  late Rect turretRect;

  ///tank是否存活
  bool isDead = true;

  ///车体
  Sprite? bodySprite;

  ///炮塔
  Sprite? turretSprite;

  ///配置完成
  bool isStandBy = false;

  int get id => config.id;

  ///车体宽度
  double get bodyWidth => config.bodyWidth;

  ///车体高度
  double get bodyHeight => config.bodyHeight;

  ///炮塔宽度(长)
  double get turretWidth => config.turretWidth;

  ///炮塔高度(直径)
  double get turretHeight => config.turretHeight;

  ///坦克尺寸比例
  double get ratio => config.ratio;

  ///直线速度
  double get speed => config.speed;

  ///转弯速度
  double get turnSpeed => config.turnSpeed;

  ///车体纹理
  String get bodySpritePath => config.bodySpritePath;

  ///炮塔纹理
  String get turretSpritePath => config.turretSpritePath;

  Future<bool> init() async {
    bodySprite = await Sprite.load(bodySpritePath);
    turretSprite = await Sprite.load(turretSpritePath);
    isStandBy = true;
    return isStandBy;
  }

  ///部署
  void deposit();

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
