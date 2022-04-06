/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:math';

import 'package:flutter/material.dart';


///摇杆
class JoyStick extends StatefulWidget {
  final void Function(Offset) onChange;

  const JoyStick({Key? key, required this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return JoyStickState();
  }
}

class JoyStickState extends State<JoyStick> {
  ///偏移量
  Offset delta = Offset.zero;

  ///更新位置
  void updateDelta(Offset newD) {
    widget.onChange(newD);
    setState(() {
      delta = newD;
    });
  }

  Offset calculateDelta(Offset offset) {
    Offset newD = offset - Offset(stickSize / 2, stickSize / 2);
    //活动范围控制在stickSize之内
    return Offset.fromDirection(newD.direction, min(stickSize / 4, newD.distance));
  }

  ///遥感尺寸
  /// * 外层大圆的直径，上层圆为1/2直径
  final double stickSize = 120;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: stickSize,
      height: stickSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(stickSize / 2),
        color: const Color(0x88ffffff),
      ),
      child: GestureDetector(
        //摇杆背景
        child: Center(
          child: Transform.translate(
            offset: delta,
            //摇杆
            child: SizedBox(
              width: stickSize / 2,
              height: stickSize / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xccffffff),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
        onPanDown: onDragDown,
        onPanUpdate: onDragUpdate,
        onPanEnd: onDragEnd,
      ),
    );
  }

  void onDragDown(DragDownDetails d) {
    updateDelta(calculateDelta(d.localPosition));
  }

  void onDragUpdate(DragUpdateDetails d) {
    updateDelta(calculateDelta(d.localPosition));
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }
}
