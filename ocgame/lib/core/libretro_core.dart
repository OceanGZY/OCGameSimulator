/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:25:36
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:25:42
 * @FilePath: /ocgame/lib/core/libretro_core.dart
 * @Description: 注释信息
 */
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

class LibretroCore {
  static final LibretroCore instance = LibretroCore._internal();

  LibretroCore._internal();

  DynamicLibrary? _lib;
  bool _inited = false;

  int Function()? retro_init;
  void Function()? retro_deinit;
  void Function(Pointer<Uint8>, int)? retro_load_game;
  void Function()? retro_run;
  Pointer<Uint32> Function()? retro_get_frame;
  void Function(int, int)? retro_set_input;
  void Function(double)? retro_set_speed;
  void Function(bool)? retro_set_audio;

  static const int BUTTON_UP = 0;
  static const int BUTTON_DOWN = 1;
  static const int BUTTON_LEFT = 2;
  static const int BUTTON_RIGHT = 3;
  static const int BUTTON_A = 4;
  static const int BUTTON_B = 5;
  static const int BUTTON_SELECT = 6;
  static const int BUTTON_START = 7;

  bool loadCore() {
    if (_inited) return true;
    try {
      _lib = DynamicLibrary.open("libretro_nes.so");
      _bind();
      retro_init?.call();
      _inited = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  void _bind() {
    retro_init = _lib?.lookupFunction<Int32 Function(), int Function()>(
      'retro_init',
    );
    retro_deinit = _lib?.lookupFunction<Void Function(), void Function()>(
      'retro_deinit',
    );
    retro_load_game = _lib
        ?.lookupFunction<
          Void Function(Pointer<Uint8>, Int32),
          void Function(Pointer<Uint8>, int)
        >('retro_load_game');
    retro_run = _lib?.lookupFunction<Void Function(), void Function()>(
      'retro_run',
    );
    retro_get_frame = _lib
        ?.lookupFunction<
          Pointer<Uint32> Function(),
          Pointer<Uint32> Function()
        >('retro_get_frame');
    retro_set_input = _lib
        ?.lookupFunction<Void Function(Int32, Int32), void Function(int, int)>(
          'retro_set_input',
        );
    retro_set_speed = _lib
        ?.lookupFunction<Void Function(Double), void Function(double)>(
          'retro_set_speed',
        );
    retro_set_audio = _lib
        ?.lookupFunction<Void Function(Bool), void Function(bool)>(
          'retro_set_audio',
        );
  }

  void loadRom(Uint8List data) {
    final ptr = malloc.allocate<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    retro_load_game?.call(ptr, data.length);
    malloc.free(ptr);
  }

  void runFrame() => retro_run?.call();
  Pointer<Uint32> get frameBuffer => retro_get_frame?.call() ?? nullptr;
  void setButton(int btn, bool pressed) =>
      retro_set_input?.call(btn, pressed ? 1 : 0);
  void setSpeed(double s) => retro_set_speed?.call(s);
  void setAudio(bool enable) => retro_set_audio?.call(enable);
}
