import 'package:flutter/material.dart';

import '../widgets/fire_button.dart';
import '../widgets/joy_stick.dart';
import 'controller_listener.dart';

/// 作者：李佳奇
/// 日期：2022/3/24
/// 备注：控制面板

class ControlPanelWidget extends StatelessWidget{

  const ControlPanelWidget({Key? key,
    required this.tankController})
      : super(key: key);

  final TankController tankController;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        //发射按钮
        Row(
          children: [
            SizedBox(width: 48),
            FireButton(
              buttonControllerListener: tankController,
            ),
            Spacer(),
            FireButton(
              buttonControllerListener: tankController,
            ),
            SizedBox(width: 48),
          ],
        ),
        SizedBox(height: 20),
        //摇杆
        Row(
          children: [
            SizedBox(width: 48),
            JoyStick(
              onChange: tankController.bodyAngleChanged,
            ),
            Spacer(),
            JoyStick(
              onChange: tankController.turretAngleChanged,
            ),
            SizedBox(width: 48)
          ],
        ),
        SizedBox(height: 24)
      ],
    );
  }


}















