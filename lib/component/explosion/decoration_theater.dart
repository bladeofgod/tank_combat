


import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:tankcombat/component/base_component.dart';
import '../../utils/extension.dart';
import 'package:vector_math/vector_math_64.dart';

import '../background/background.dart';

mixin DecorationTheater on FlameGame{

  final BattleBackground bg = BattleBackground();

  final List<OrangeExplosion> explosions = [];

  ///在[pos]位置添加一个爆炸效果
  void addExplosions(Offset pos) {
    explosions.add(OrangeExplosion(pos));
  }

  @override
  void render(Canvas canvas) {
    bg.render(canvas);
    super.render(canvas);
    explosions.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    explosions.update(dt);
    explosions.removeWhere((element) => element.playDone);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    bg.onGameResize(canvasSize);
    super.onGameResize(canvasSize);
    explosions.onGameResize(canvasSize);
  }
}


class OrangeExplosion implements WindowComponent{

  OrangeExplosion(this.position) : exRect = Rect.fromCenter(center: position,width: 30,height: 30) {
    loadSprite();
  }

  ///爆炸位置
  final Offset position;

  ///爆炸纹理
  final List<Sprite> sprites = [];

  ///爆炸纹理尺寸
  final Rect exRect;

  int playIndex =0;

  bool playDone = false;

  ///爆炸开始经过的时间
  /// * 用于调整[sprites]的fps
  double passedTime = 0;


  void loadSprite() async {
    sprites.add(await Sprite.load('explosion/explosion1.webp'));
    sprites.add(await Sprite.load('explosion/explosion2.webp'));
    sprites.add(await Sprite.load('explosion/explosion3.webp'));
    sprites.add(await Sprite.load('explosion/explosion4.webp'));
    sprites.add(await Sprite.load('explosion/explosion5.webp'));
  }


  @override
  void render(Canvas canvas) {
    if(playDone)
      return;
    if(sprites.length == 5 && playIndex < 5) {
      sprites[playIndex].renderRect(canvas, exRect);
    }
  }

  @override
  void update(double t) {
    if(playDone)
      return;
    if(playIndex < 5) {
      //1秒 5张图片
      passedTime += t;
      playIndex = passedTime ~/ 0.2;
    }else{
      playDone = true;
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
  }

}
























