import 'dart:ui';

import 'package:tankcombat/component/tank/enemy/tank_model.dart';

/// 作者：李佳奇
/// 日期：2022/3/28
/// 备注：工厂、builder,tank-generator及tank模型

class GreenTankFlowLine extends ComputerTankFlowLine {
  GreenTankFlowLine(Offset depositPosition, Size activeSize) : super(depositPosition, activeSize);

  @override
  T spawnTank<T extends ComputerTank>() {
    final TankModelBuilder greenBuilder = TankModelBuilder(
        id: DateTime.now().millisecondsSinceEpoch,
        bodySpritePath: 'tank/t_body_green.webp',
        turretSpritePath: 'tank/t_turret_green.webp',
        activeSize: activeSize);
    return TankFactory.buildGreenTank(greenBuilder.build(), depositPosition) as T;
  }
}

class SandTankFlowLine extends ComputerTankFlowLine {
  SandTankFlowLine(Offset depositPosition, Size activeSize) : super(depositPosition, activeSize);

  @override
  T spawnTank<T extends ComputerTank>() {
    final TankModelBuilder sandBuilder = TankModelBuilder(
        id: DateTime.now().millisecondsSinceEpoch,
        bodySpritePath: 'tank/t_body_sand.webp',
        turretSpritePath: 'tank/t_turret_sand.webp',
        activeSize: activeSize);
    return TankFactory.buildSandTank(sandBuilder.build(), depositPosition) as T;
  }
}

abstract class ComputerTankFlowLine implements ComputerTankSpawnerTrigger {
  ComputerTankFlowLine(this.depositPosition, this.activeSize);

  final Size activeSize;

  final Offset depositPosition;
}

abstract class ComputerTankSpawnerTrigger {
  T spawnTank<T extends ComputerTank>();
}

class ComputerTankSpawner<T extends ComputerTank> {
  List<ComputerTankFlowLine> spawners = [];

  ///生成器初始化完成
  bool standby = false;

  ///构建中
  /// * 将会影响是否相应tank生成
  bool building = false;

  void warmUp(Size bgSize) {
    if (standby) {
      return;
    }
    standby = true;

    spawners.addAll([
      GreenTankFlowLine(const Offset(100, 100), bgSize),
      GreenTankFlowLine(Offset(100, bgSize.height * 0.8), bgSize),
      SandTankFlowLine(Offset(bgSize.width - 100, 100), bgSize),
      SandTankFlowLine(Offset(bgSize.width - 100, bgSize.height * 0.8), bgSize)
    ]);
  }

  void fastSpawn(List<T> plaza) {
    plaza.addAll(spawners.map<T>((e) => e.spawnTank()..deposit()).toList());
  }

  void randomSpan(List<T> plaza) {
    if(building) {
      return;
    }
    building = true;
    _startSpawn(() {
      spawners.shuffle();
      plaza.add(spawners.first.spawnTank()..deposit());
      building = false;
    });
  }

  void _startSpawn(Function task) {
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      task();
    });
  }

}

class TankFactory {
  static PlayerTank buildPlayerTank(TankModel model, Offset birthPosition) {
    return PlayerTank(id: model.id, birthPosition: birthPosition, config: model);
  }

  static ComputerTank buildGreenTank(TankModel model, Offset birthPosition) {
    return ComputerTank.green(id: model.id, birthPosition: birthPosition, config: model);
  }

  static ComputerTank buildSandTank(TankModel model, Offset birthPosition) {
    return ComputerTank.sand(id: model.id, birthPosition: birthPosition, config: model);
  }
}

class TankModelBuilder {
  TankModelBuilder({
    required this.id,
    required this.bodySpritePath,
    required this.turretSpritePath,
    required this.activeSize,
  });

  final int id;

  ///车体纹理
  final String bodySpritePath;

  ///炮塔纹理
  final String turretSpritePath;

  ///活动范围
  /// * 一般是地图尺寸
  Size activeSize;

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

  ///设置活动范围
  void setActiveSize(Size size) {
    activeSize = size;
  }

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
    return TankModel(
      id: id,
      bodySpritePath: bodySpritePath,
      turretSpritePath: turretSpritePath,
      ratio: ratio,
      speed: speed,
      turnSpeed: turnSpeed,
      bodyWidth: bodyWidth,
      bodyHeight: bodyHeight,
      turretWidth: turretWidth,
      turretHeight: turretHeight,
      activeSize: activeSize,
    );
  }
}

///坦克基础模型
class TankModel {
  TankModel(
      {required this.id,
      required this.bodySpritePath,
      required this.turretSpritePath,
      required this.ratio,
      required this.speed,
      required this.turnSpeed,
      required this.bodyWidth,
      required this.bodyHeight,
      required this.turretWidth,
      required this.turretHeight,
      required this.activeSize});

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

  ///活动范围
  /// * 一般是地图尺寸
  Size activeSize;
}
