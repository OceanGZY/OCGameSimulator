import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';
import 'package:ffi/ffi.dart';

final class retro_game_info extends Struct {
  external Pointer<Char> path;
  external Pointer<Uint8> data;
  @Int32()
  external int size;
  external Pointer<Char> meta;
}

typedef native_init = Void Function();
typedef native_deinit = Void Function();
typedef native_load = Int32 Function(Pointer<retro_game_info>);
typedef native_run = Void Function();
typedef native_input = Void Function(Int32, Int32, Int32, Int32, Int32);
typedef native_video = Void Function(Pointer<Void>);
typedef native_speed = Void Function(Float);
typedef native_audio = Void Function(Bool);
typedef native_vcb = Void Function(Pointer<Uint8>, Uint32, Uint32, Uint32);

typedef dart_init = void Function();
typedef dart_deinit = void Function();
typedef dart_load = int Function(Pointer<retro_game_info>);
typedef dart_run = void Function();
typedef dart_input = void Function(int, int, int, int, int);
typedef dart_video = void Function(Pointer<Void>);
typedef dart_speed = void Function(double);
typedef dart_audio = void Function(bool);

class LibretroCore {
  static final LibretroCore instance = LibretroCore._internal();
  LibretroCore._internal();

  DynamicLibrary? lib;
  bool ok = false;

  Uint32List fb = Uint32List(256 * 240);
  int w = 256, h = 240;

  dart_init rInit = () {};
  dart_deinit rDeinit = () {};
  dart_load rLoad = (_) => 0;
  dart_run rRun = () {};
  dart_input rInput = (_, _, _, _, _) {};
  dart_video rVid = (_) {};
  dart_speed rSpeed = (_) {};
  dart_audio rAud = (_) {};

  static const int UP = 16,
      DOWN = 17,
      LEFT = 18,
      RIGHT = 19,
      A = 8,
      B = 9,
      START = 7,
      SELECT = 6;

  bool loadCore() {
    if (ok) return true;
    try {
      if (Platform.isIOS) {
        // lib = DynamicLibrary.process();
        lib = DynamicLibrary.open("fceumm_libretro_ios.dylib");
      } else {
        lib = DynamicLibrary.open("fceumm_libretro_android.so");
      }

      // 🔥 🔥 🔥 关键：iOS 不加任何前缀！！！
      String prefix = "";

      rInit = lib!.lookupFunction<native_init, dart_init>(
        "${prefix}retro_init",
      );
      rDeinit = lib!.lookupFunction<native_deinit, dart_deinit>(
        "${prefix}retro_deinit",
      );
      rLoad = lib!.lookupFunction<native_load, dart_load>(
        "${prefix}retro_load_game",
      );
      rRun = lib!.lookupFunction<native_run, dart_run>("${prefix}retro_run");
      rInput = lib!.lookupFunction<native_input, dart_input>(
        "${prefix}retro_input_state",
      );
      rVid = lib!.lookupFunction<native_video, dart_video>(
        "${prefix}retro_set_video_refresh",
      );
      rSpeed = lib!.lookupFunction<native_speed, dart_speed>(
        "${prefix}retro_set_speed",
      );
      rAud = lib!.lookupFunction<native_audio, dart_audio>(
        "${prefix}retro_set_audio",
      );

      rInit();
      final cb = Pointer.fromFunction<native_vcb>(_v);
      rVid(cb.cast());
      ok = true;
      return true;
    } catch (e) {
      print("❌ $e");
      return false;
    }
  }

  static void _v(Pointer<Uint8> d, int w, int h, int pitch) {
    if (d == nullptr) return;
    final i = d.asTypedList(h * pitch);
    final b = instance.fb;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final p = y * pitch + x * 4;
        b[y * w + x] = (0xFF << 24) | (i[p + 2] << 16) | (i[p + 1] << 8) | i[p];
      }
    }
    instance.w = w;
    instance.h = h;
  }

  bool loadRom(Uint8List data, String name) {
    final info = calloc<retro_game_info>();
    final rom = calloc<Uint8>(data.length);
    rom.asTypedList(data.length).setAll(0, data);
    info.ref.data = rom;
    info.ref.size = data.length;
    info.ref.path = name.toNativeUtf8().cast();

    final res = rLoad(info);
    calloc.free(info);
    print("🎮 load_game = $res");
    return res == 1;
  }

  void runFrame() => rRun();
  Uint32List get frameBuffer => fb;
  int get width => w;
  int get height => h;
  void setButton(int k, bool p) => rInput(0, 1, 0, k, p ? 1 : 0);
  void setSpeed(double s) => rSpeed(s);
  void setAudio(bool e) => rAud(e);
}
