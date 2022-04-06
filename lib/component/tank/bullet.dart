
/*
* Author : LiJiqqi
* Date : 2020/7/30
*/
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:tankcombat/component/base_component.dart';

import 'dart:async' as async;
import 'dart:collection';

class ComputerBullet extends BaseBullet{

  factory ComputerBullet.green({required int tankId, required Size activeSize}) {
    return ComputerBullet('tank/bullet_green.webp', tankId: tankId, activeSize: activeSize);
  }

  factory ComputerBullet.sand({required int tankId, required Size activeSize}) {
    return ComputerBullet('tank/bullet_green.webp', tankId: tankId, activeSize: activeSize);
  }

  ComputerBullet(this.spritePath, {required int tankId, required Size activeSize})
      : super(tankId: tankId, activeSize: activeSize);

  final String spritePath;

  late Sprite _sprite;

  Rect _rect = Rect.fromLTWH(-4, -2, 6, 4);

  @override
  Rect get bulletRect => _rect;

  @override
  Sprite get bulletSprite => _sprite;

  @override
  Future<void> loadSprite() async {
    _sprite = await Sprite.load(spritePath);
  }

  @override
  ComputerBullet copyWith({int? tankId, Size? activeSize, Offset? position, double? angle, BulletStatus status = BulletStatus.none}) {
    final ComputerBullet pb = ComputerBullet(this.spritePath, tankId: tankId ?? this.tankId, activeSize: activeSize ?? this.activeSize);
    pb.position = position ?? Offset.zero;
    pb.angle = angle ?? 0;
    pb.status = status;
    return pb;
  }

}


class PlayerBullet extends BaseBullet{

  PlayerBullet({required int tankId, required Size activeSize})
      : super(tankId: tankId, activeSize: activeSize);

  late Sprite _sprite;

  Rect _rect = Rect.fromLTWH(-4, -2, 8, 4);

  @override
  Sprite get bulletSprite => _sprite;

  @override
  Rect get bulletRect => _rect;

  @override
  Future<void> loadSprite() async {
    _sprite = await Sprite.load('tank/bullet_blue.webp');
  }

  @override
  PlayerBullet copyWith({int? tankId, Size? activeSize, Offset? position, double? angle, BulletStatus status = BulletStatus.none}) {
    final PlayerBullet pb = PlayerBullet(tankId: tankId ?? this.tankId, activeSize: activeSize ?? this.activeSize);
    pb.position = position ?? Offset.zero;
    pb.angle = angle ?? 0;
    pb.status = status;
    return pb;
  }

}


enum BulletStatus{
  none, //初始状态
  standBy,// 准备状态： 可参与绘制
  hit, //击中状态
  outOfBorder, //飞出边界
}

abstract class BaseBullet extends WindowComponent{

  BaseBullet({
    required this.tankId,
    required this.activeSize,
  }) {
    init();
  }

  BaseBullet copyWith({
    int? tankId,
    Size? activeSize,
    Offset? position,
    double? angle,
    BulletStatus status = BulletStatus.none,
  });

  ///隶属于的tank
  final int tankId;

  ///子弹尺寸
  /// * 后期可以加入特效等
  Rect get bulletRect;

  ///子弹皮肤
  Sprite get bulletSprite;

  ///可活动范围
  /// * 超出判定为失效子弹
  Size activeSize;

  Offset position = Offset.zero;

  double speed = 200;

  double angle = 0;

  ///子弹状态
  BulletStatus status = BulletStatus.none;

  ///可移除的子弹
  bool get dismissible => status.index > 1;

  void hit() {
    status = BulletStatus.hit;
  }

  Future<void> loadSprite();

  void init() async {
    await loadSprite();
    status = BulletStatus.standBy;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    activeSize = canvasSize.toSize();
    super.onGameResize(canvasSize);
  }


  @override
  void render(Canvas canvas) {
    if(dismissible)
      return;
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);
    bulletSprite.renderRect(canvas, bulletRect);
    canvas.restore();
  }

  @override
  void update(double t) {
    if(dismissible)
      return;
    position += Offset.fromDirection(angle,speed * t);

    if(!activeSize.contains(position)) {
      status = BulletStatus.outOfBorder;
    }
  }

}

class BulletTrigger{

  BulletTrigger() {
    trigger = async.Timer.periodic(const Duration(milliseconds: 100), _onTick);
  }

  final Queue<Function> _task = Queue();

  late final async.Timer trigger;

  void _onTick(async.Timer timer) {
    if(_task.isEmpty)
      return;
    final Function t = _task.removeFirst();
    t.call();
  }

  void chargeLoading(Function b) {
    _task.add(b);
  }

}
