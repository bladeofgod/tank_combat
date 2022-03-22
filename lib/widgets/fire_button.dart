/*
* Author : LiJiqqi
* Date : 2020/7/30
*/
import 'package:flutter/material.dart';

class FireButton extends StatelessWidget {
  final void Function() onTap;

  const FireButton({Key? key, required this.onTap}) : super(key: key);
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
          onTap: onTap,
        ),
      ),
    );
  }
}