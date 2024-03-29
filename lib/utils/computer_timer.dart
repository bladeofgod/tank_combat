import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flutter/foundation.dart';

/// 作者：李佳奇
/// 日期：2022/4/1
/// 备注：电脑计时器，用于执行一些定时性操作

///电脑自动开火接口
abstract class ComputerTimerListener{
  void onFireTimerTrigger();
}

///电脑计时器
/// * 主要用于触发一些自动行为，如[ComputerTimerListener]自动开火。
mixin ComputerTimer on FlameGame{

  Timer? timer;

  void onTick() {
    _listener?.onFireTimerTrigger();
  }

  ComputerTimerListener? _listener;

  void setTimerListener(ComputerTimerListener listener) {
    _listener = listener;
  }


  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    //limit's unit : second
    timer ??= Timer(1, repeat: true, onTick: onTick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer!.update(dt);
  }

}














