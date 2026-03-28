import 'dart:async';
import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/libretro_core.dart';
import '../providers/app_provider.dart';
import '../widgets/virtual_gamepad.dart';
import '../widgets/float_menu.dart';
import '../widgets/controller_support.dart';

class EmulatorPage extends StatefulWidget {
  const EmulatorPage({super.key});

  @override
  State<EmulatorPage> createState() => _EmulatorPageState();
}

class _EmulatorPageState extends State<EmulatorPage> {
  final core = LibretroCore.instance;
  ui.Image? screenImage;
  Timer? _timer;
  bool running = true;

  @override
  void initState() {
    super.initState();
    _startFrameLoop();
  }

  void _startFrameLoop() {
    _timer = Timer.periodic(const Duration(microseconds: 16667), (t) {
      if (!running) return;
      core.runFrame();
      _refreshScreen();
    });
  }

  void _refreshScreen() {
    final buf = core.frameBuffer;
    if (buf.address == 0) return;

    final pixels = buf.asTypedList(256 * 240);
    ui.decodeImageFromPixels(
      pixels.buffer.asUint8List(),
      256,
      240,
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
      body: ControllerSupport(
        child: Stack(
          children: [
            if (screenImage != null)
              Center(
                child: AspectRatio(
                  aspectRatio: 256 / 240,
                  child: RawImage(image: screenImage!),
                ),
              ),
            if (provider.showPad) const VirtualGamepad(),
            FloatMenu(
              onExit: () {
                provider.exitGame();
                Navigator.pop(context);
              },
            ),
            if (provider.isOnline)
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    provider.voiceEnabled ? '语音开启' : '语音关闭',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
