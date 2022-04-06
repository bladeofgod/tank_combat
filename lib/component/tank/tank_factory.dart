import 'dart:ui';

import 'package:tankcombat/component/tank/tank_model.dart';
import 'package:tankcombat/game/tank_game.dart';

/// 作者：李佳奇
/// 日期：2022/3/28
/// 备注：工厂、builder,tank-generator及tank模型

///用于生产绿色tank
class GreenTankFlowLine extends ComputerTankFlowLine<ComputerTank> {
  GreenTankFlowLine(Offset depositPosition, Size activeSize) : super(depositPosition, activeSize);

  @override
  ComputerTank spawnTank() {
      final TankModelBuilder greenBuilder = TankModelBuilder(
          id: DateTime.now().millisecondsSinceEpoch,
          bodySpritePath: 'tank/t_body_green.webp',
          turretSpritePath: 'tank/t_turret_green.webp',
          activeSize: activeSize);
      return TankFactory.buildGreenTank(greenBuilder.build(), depositPosition);
  }

}

///用于生产黄色tank
class SandTankFlowLine extends ComputerTankFlowLine<ComputerTank> {
  SandTankFlowLine(Offset depositPosition, Size activeSize) : super(depositPosition, activeSize);

  @override
  ComputerTank spawnTank() {
    final TankModelBuilder sandBuilder = TankModelBuilder(
        id: DateTime.now().millisecondsSinceEpoch,
        bodySpritePath: 'tank/t_body_sand.webp',
        turretSpritePath: 'tank/t_turret_sand.webp',
        activeSize: activeSize);
    return TankFactory.buildSandTank(sandBuilder.build(), depositPosition);
  }
}

///流水线基类
/// * 用于生成电脑tank
/// * 见[ComputerTankSpawner]
abstract class ComputerTankFlowLine<T extends ComputerTank> implements ComputerTankSpawnerTrigger<T> {
  ComputerTankFlowLine(this.depositPosition, this.activeSize);

  ///活动范围
  final Size activeSize;

  ///部署位置
  final Offset depositPosition;
}

abstract class ComputerTankSpawnerTrigger<T extends ComputerTank> {
  T spawnTank();
}

///电脑生成器
/// * [TankTheater]下，tank生成的直接参与者，负责电脑的随机生成。
///
/// * [spawners]为具体[ComputerTank]的生成流水线，见[GreenTankFlowLine]和[SandTankFlowLine]
///   流水线内部的[ComputerTank]产出由[TankFactory]负责。
class ComputerTankSpawner {

  ///流水线
  List<ComputerTankFlowLine> spawners = [];

  ///生成器初始化完成
  bool standby = false;

  ///构建中
  /// * 将会影响是否相应tank生成
  bool building = false;

  ///初始化调用
  /// * 用于配置流水线
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

  ///快速生成tank
  /// * 各生产线生成一辆tank
  /// * [plaza]为接收tank对象
  void fastSpawn(List<ComputerTank> plaza) {
    plaza.addAll(spawners.map<ComputerTank>((e) => e.spawnTank()..deposit()).toList());
  }

  ///随机生成一辆tank
  /// * [plaza]为接收tank对象
  void randomSpan(List<ComputerTank> plaza) {
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

  ///用于约束生产速度
  void _startSpawn(Function task) {
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      task();
    });
  }

}

///用于构建tank
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

///[TankModel]构建器
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

///坦克基础配置模型
/// * 由[TankModelBuilder]负责构建
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
