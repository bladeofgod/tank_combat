/*
* Author : LiJiqqi
* Date : 2020/7/30
*/
import 'package:flutter/material.dart';

import '../controller/controller_listener.dart';

class FireButton extends StatelessWidget {

  const FireButton({Key? key, required this.buttonControllerListener}) : super(key: key);

  final ButtonControllerListener buttonControllerListener;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,width: 64,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32)
        ),
        child: GestureDetector(
          child:Container(
            decoration: BoxDecoration(
              color: Color(0x88ffffff),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onTap: buttonControllerListener.fireButtonTriggered,
        ),
      ),
    );
  }
}