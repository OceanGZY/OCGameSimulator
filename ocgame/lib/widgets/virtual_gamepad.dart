import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../core/libretro_core.dart';

class VirtualGamepad extends StatelessWidget {
  const VirtualGamepad({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 30,
          bottom: 60,
          child: Column(
            children: [
              _btn(
                onDown: () => _press(LibretroCore.UP, true),
                onUp: () => _press(LibretroCore.UP, false),
                child: Icon(Icons.arrow_upward, color: Colors.white),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _btn(
                    onDown: () => _press(LibretroCore.LEFT, true),
                    onUp: () => _press(LibretroCore.LEFT, false),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 70),
                  _btn(
                    onDown: () => _press(LibretroCore.RIGHT, true),
                    onUp: () => _press(LibretroCore.RIGHT, false),
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _btn(
                onDown: () => _press(LibretroCore.DOWN, true),
                onUp: () => _press(LibretroCore.DOWN, false),
                child: Icon(Icons.arrow_downward, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          right: 30,
          bottom: 80,
          child: Row(
            children: [
              _circle(
                onDown: () => _press(LibretroCore.B, true),
                onUp: () => _press(LibretroCore.B, false),
                label: 'B',
              ),
              SizedBox(width: 24),
              _circle(
                onDown: () => _press(LibretroCore.A, true),
                onUp: () => _press(LibretroCore.A, false),
                label: 'A',
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          left: MediaQuery.of(context).size.width * 0.5 - 70,
          child: Row(
            children: [
              _smallBtn(
                'SELECT',
                onDown: () => _press(LibretroCore.SELECT, true),
                onUp: () => _press(LibretroCore.SELECT, false),
              ),
              SizedBox(width: 20),
              _smallBtn(
                'START',
                onDown: () => _press(LibretroCore.START, true),
                onUp: () => _press(LibretroCore.START, false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _btn({
    required VoidCallback onDown,
    required VoidCallback onUp,
    required Widget child,
  }) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: child,
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
            style: TextStyle(color: Colors.white, fontSize: 26),
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
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _press(int btn, bool down) {
    LibretroCore.instance.setButton(btn, down);
    if (down) Vibration.vibrate(duration: 20);
  }
}
