/*
* Author : LiJiqqi
* Date : 2020/7/30
*/

import 'dart:math';

import 'package:flutter/material.dart';

class JoyStick extends StatefulWidget{

  final void Function(Offset) onChange;

  const JoyStick({Key key, this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return JoyStickState();
  }

}

class JoyStickState extends State<JoyStick> {

  //偏移量
  Offset delta = Offset.zero;

  //更新位置
  void updateDelta(Offset newD){
    widget.onChange(newD);
    setState(() {
      delta = newD;
    });
  }

  void calculateDelta(Offset offset){
    Offset newD = offset - Offset(bgSize/2,bgSize/2);
    updateDelta(Offset.fromDirection(newD.direction,min(bgSize/4, newD.distance)));//活动范围控制在bgSize之内
  }

  final double bgSize = 120;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: bgSize,height: bgSize,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(bgSize/2)
        ),
        child: GestureDetector(
          ///摇杆背景
          child: Container(
            decoration: BoxDecoration(
              color: Color(0x88ffffff),
              borderRadius: BorderRadius.circular(bgSize/2),
            ),
            child: Center(
              child: Transform.translate(offset: delta,
                ///摇杆
                child: SizedBox(
                  width: bgSize/2,height: bgSize/2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xccffffff),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),),
            ),
          ),
          onPanDown: onDragDown,
          onPanUpdate: onDragUpdate,
          onPanEnd: onDragEnd,
        ),
      ),
    );
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }
}
























