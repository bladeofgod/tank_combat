import 'package:tankcombat/component/tank/enemy/tank_model.dart';

/// 作者：李佳奇
/// 日期：2022/3/28
/// 备注：工厂、builder及tank模型

class TankFactory{

  PlayerTank buildPlayerTank(TankModel model, Offset birthPosition) {
    return PlayerTank(
        id: DateTime.now().millisecondsSinceEpoch,
        birthPosition: birthPosition,
        config: model);
  }

}


class TankModelBuilder{

  TankModelBuilder({
    required this.id,
    required this.bodySpritePath,
    required this.turretSpritePath,
});

  final int id;

  ///车体纹理
  final String bodySpritePath;

  ///炮塔纹理
  final String turretSpritePath;

  ///车体宽度
  double bodyWidth = 38;

  ///车体高度
  double bodyHeight = 32;

  ///炮塔宽度(长)
  double turretWidth = 22;

  ///炮塔高度(直径)
  double turretHeight = 6;

  ///坦克尺寸比例
  double ratio = 0.7;

  ///直线速度
  double speed = 80;

  ///转弯速度
  double turnSpeed = 40;


  ///设置车身尺寸
  void setBodySize(double width, double height) {
    bodyWidth = width;
    bodyHeight = height;
  }

  ///设置炮塔尺寸
  void setTurretSize(double width, double height) {
    turretWidth = width;
    turretHeight = height;
  }

  ///设置tank尺寸比例
  void setTankRatio(double r) {
    ratio = r;
  }

  ///设置直线速度
  void setDirectSpeed(double s) {
    speed = s;
  }

  ///设置转弯速度
  void setTurnSpeed(double s) {
    turnSpeed = s;
  }

  TankModel build() {
    return TankModel(id: id,
        bodySpritePath: bodySpritePath,
        turretSpritePath: turretSpritePath,
        ratio: ratio,
        speed: speed,
        turnSpeed: turnSpeed,
        bodyWidth: bodyWidth,
        bodyHeight: bodyHeight,
        turretWidth: turretWidth,
        turretHeight: turretHeight);

  }

}


///坦克基础模型
class TankModel {
  TankModel({
    required this.id,
    required this.bodySpritePath,
    required this.turretSpritePath,
    required this.ratio,
    required this.speed,
    required this.turnSpeed,
    required this.bodyWidth,
    required this.bodyHeight,
    required this.turretWidth,
    required this.turretHeight,
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


}
















