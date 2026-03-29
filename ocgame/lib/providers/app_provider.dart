/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:26:54
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 19:07:24
 * @FilePath: /ocgame/lib/providers/app_provider.dart
 * @Description: 注释信息
 */
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../core/libretro_core.dart';

class AppProvider extends ChangeNotifier {
  final core = LibretroCore.instance;

  Uint8List? romData;
  String romName = '';
  double speed = 1.0;
  bool audioEnabled = true;
  bool showPad = true;
  bool isOnline = false;
  String roomId = '';
  bool isHost = false;
  bool voiceEnabled = true;

  void loadGame(Uint8List data, String name) {
    romData = data;
    romName = name;
    core.loadCore();
    core.loadRom(data, name);
    notifyListeners();
  }

  void toggleSpeed() {
    speed = speed == 1.0 ? 2.0 : 1.0;
    core.setSpeed(speed);
    notifyListeners();
  }

  void toggleAudio() {
    audioEnabled = !audioEnabled;
    core.setAudio(audioEnabled);
    notifyListeners();
  }

  void togglePad() {
    showPad = !showPad;
    notifyListeners();
  }

  void enterOnline(String room, bool host) {
    isOnline = true;
    roomId = room;
    isHost = host;
    notifyListeners();
  }

  void toggleVoice() {
    voiceEnabled = !voiceEnabled;
    notifyListeners();
  }

  void exitGame() {
    romData = null;
    romName = '';
    isOnline = false;
    notifyListeners();
  }
}
