import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/libretro_core.dart';
import '../providers/app_provider.dart';
import '../widgets/virtual_gamepad.dart';
import '../widgets/float_menu.dart';

class EmulatorPage extends StatefulWidget {
  const EmulatorPage({super.key});
  @override
  State<EmulatorPage> createState() => _EmulatorPageState();
}

class _EmulatorPageState extends State<EmulatorPage> {
  final core = LibretroCore.instance;
  ui.Image? screenImage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      core.runFrame();
      _render();
    });
  }

  void _render() {
    final pixels = core.frameBuffer;
    // print(
    //   "🖼️ 渲染帧: pixels.length=${pixels.length}, first pixel=${pixels.first}",
    // );

    ui.decodeImageFromPixels(
      pixels.buffer.asUint8List(),
      core.width,
      core.height,
      ui.PixelFormat.rgba8888,
      (img) {
        if (mounted) setState(() => screenImage = img);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (screenImage != null)
            Center(
              child: AspectRatio(
                aspectRatio: 256 / 240,
                child: RawImage(image: screenImage),
              ),
            ),
          if (provider.showPad) const VirtualGamepad(),
          FloatMenu(
            onExit: () {
              provider.exitGame();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
