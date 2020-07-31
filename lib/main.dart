import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tankcombat/game/tank_game.dart';
import 'package:tankcombat/widgets/fire_button.dart';
import 'package:tankcombat/widgets/joy_stick.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  loadAssets();

  ///设置横屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);

  ///全面屏
  await SystemChrome.setEnabledSystemUIOverlays([]);

  final TankGame tankGame = TankGame();

  runApp(Directionality(textDirection: TextDirection.ltr,
      child: Stack(
    children: [

      tankGame.widget,

      Column(
        children: [

          Spacer(),
          //发射按钮
          Row(
            children: [
              SizedBox(width: 48),
              FireButton(
                onTap: tankGame.onFireButtonTap,
              ),
              Spacer(),
              FireButton(
                onTap: tankGame.onFireButtonTap,
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
                onChange: (Offset delta)=>tankGame.onLeftJoypadChange(delta),
              ),
              Spacer(),
              JoyStick(
                onChange: (Offset delta)=>tankGame.onRightJoypadChange(delta),
              ),
              SizedBox(width: 48)
            ],
          ),
          SizedBox(height: 24)
        ],
      ),

    ],
  )));



}

void loadAssets(){
  Flame.images.loadAll([
    'new_map.webp',
    'tank/t_body_blue.webp',
    'tank/t_turret_blue.webp'
  ]);
}

