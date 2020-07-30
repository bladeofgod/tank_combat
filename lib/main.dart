import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  ///设置横屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);

  ///全面屏
  await SystemChrome.setEnabledSystemUIOverlays([]);



}

