import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../core/libretro_core.dart';

class VirtualGamepad extends StatelessWidget {
  const VirtualGamepad({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // DPad
        Positioned(
          left: 30,
          bottom: 60,
          child: Column(
            children: [
              _key(
                size: 50,
                onDown: () => _press(LibretroCore.BUTTON_UP, true),
                onUp: () => _press(LibretroCore.BUTTON_UP, false),
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _key(
                    size: 50,
                    onDown: () => _press(LibretroCore.BUTTON_LEFT, true),
                    onUp: () => _press(LibretroCore.BUTTON_LEFT, false),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 70),
                  _key(
                    size: 50,
                    onDown: () => _press(LibretroCore.BUTTON_RIGHT, true),
                    onUp: () => _press(LibretroCore.BUTTON_RIGHT, false),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _key(
                size: 50,
                onDown: () => _press(LibretroCore.BUTTON_DOWN, true),
                onUp: () => _press(LibretroCore.BUTTON_DOWN, false),
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
            ],
          ),
        ),

        // A B
        Positioned(
          right: 30,
          bottom: 80,
          child: Row(
            children: [
              _circle(
                label: 'B',
                onDown: () => _press(LibretroCore.BUTTON_B, true),
                onUp: () => _press(LibretroCore.BUTTON_B, false),
              ),
              const SizedBox(width: 24),
              _circle(
                label: 'A',
                onDown: () => _press(LibretroCore.BUTTON_A, true),
                onUp: () => _press(LibretroCore.BUTTON_A, false),
              ),
            ],
          ),
        ),

        // SELECT START
        Positioned(
          bottom: 30,
          left: MediaQuery.of(context).size.width * 0.5 - 70,
          child: Row(
            children: [
              _smallBtn(
                'SELECT',
                onDown: () => _press(LibretroCore.BUTTON_SELECT, true),
                onUp: () => _press(LibretroCore.BUTTON_SELECT, false),
              ),
              const SizedBox(width: 20),
              _smallBtn(
                'START',
                onDown: () => _press(LibretroCore.BUTTON_START, true),
                onUp: () => _press(LibretroCore.BUTTON_START, false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _key({
    required double size,
    required VoidCallback onDown,
    required VoidCallback onUp,
    required Widget child,
  }) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _circle({
    required String label,
    required VoidCallback onDown,
    required VoidCallback onUp,
  }) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: Colors.white30,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
      ),
    );
  }

  Widget _smallBtn(
    String text, {
    required VoidCallback onDown,
    required VoidCallback onUp,
  }) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _press(int btn, bool down) {
    LibretroCore.instance.setButton(btn, down);
    if (down) Vibration.vibrate(duration: 20);
  }
}
