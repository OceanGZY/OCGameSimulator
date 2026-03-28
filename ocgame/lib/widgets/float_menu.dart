/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:27:39
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:27:45
 * @FilePath: /ocgame/lib/widgets/float_menu.dart
 * @Description: 注释信息
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class FloatMenu extends StatefulWidget {
  final VoidCallback onExit;
  const FloatMenu({super.key, required this.onExit});

  @override
  State<FloatMenu> createState() => _FloatMenuState();
}

class _FloatMenuState extends State<FloatMenu> {
  double x = 20;
  double y = 100;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanUpdate: (d) {
          setState(() {
            x += d.delta.dx;
            y += d.delta.dy;
          });
        },
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: PopupMenuButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            itemBuilder: (c) => [
              PopupMenuItem(
                onTap: provider.toggleSpeed,
                child: Text('速度 ${provider.speed}x'),
              ),
              PopupMenuItem(
                onTap: provider.toggleAudio,
                child: Text(provider.audioEnabled ? '静音' : '开启声音'),
              ),
              PopupMenuItem(
                onTap: provider.togglePad,
                child: Text(provider.showPad ? '隐藏按键' : '显示按键'),
              ),
              if (provider.isOnline)
                PopupMenuItem(
                  onTap: provider.toggleVoice,
                  child: Text(provider.voiceEnabled ? '关闭语音' : '开启语音'),
                ),
              PopupMenuItem(onTap: widget.onExit, child: const Text('退出游戏')),
            ],
          ),
        ),
      ),
    );
  }
}
