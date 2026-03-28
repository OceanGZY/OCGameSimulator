/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:29:05
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:29:12
 * @FilePath: /ocgame/lib/widgets/controller_support.dart
 * @Description: 注释信息
 */
import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';
import '../core/libretro_core.dart';

class ControllerSupport extends StatefulWidget {
  final Widget child;
  const ControllerSupport({super.key, required this.child});

  @override
  State<ControllerSupport> createState() => _ControllerSupportState();
}

class _ControllerSupportState extends State<ControllerSupport> {
  @override
  void initState() {
    super.initState();
    Gamepads.events.listen((event) {
      final core = LibretroCore.instance;
      final v = event.value > 0;

      if (event.key.toLowerCase().contains('up')) core.setButton(0, v);
      if (event.key.toLowerCase().contains('down')) core.setButton(1, v);
      if (event.key.toLowerCase().contains('left')) core.setButton(2, v);
      if (event.key.toLowerCase().contains('right')) core.setButton(3, v);
      if (event.key.toLowerCase().contains('a')) core.setButton(4, v);
      if (event.key.toLowerCase().contains('b')) core.setButton(5, v);
      if (event.key.toLowerCase().contains('select')) core.setButton(6, v);
      if (event.key.toLowerCase().contains('start')) core.setButton(7, v);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
