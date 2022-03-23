import 'dart:ui';

/// 作者：李佳奇
/// 日期：2022/3/23
/// 备注：控制器监听器

abstract class DirectionControllerListener{

  ///车身角度变化
  void bodyAngleChanged(Offset newAngle);

  ///炮塔角度变化
  void turretAngleChanged(Offset newAngle);

}


abstract class ButtonControllerListener{

  ///开火按钮触发
  void fireButtonTriggered();

}
















