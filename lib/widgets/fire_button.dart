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
    return GestureDetector(
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: const Color(0x88ffffff),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      onTap: buttonControllerListener.fireButtonTriggered,
    );
  }
}
