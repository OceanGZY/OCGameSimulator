/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:35:36
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:35:43
 * @FilePath: /ocgame/lib/online/online_sync.dart
 * @Description: 注释信息
 */
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../core/libretro_core.dart';

class OnlineSync {
  static final OnlineSync instance = OnlineSync._internal();
  OnlineSync._internal();

  WebSocketChannel? channel;
  bool isHost = false;
  String roomId = '';

  // 连接联机服务器
  Future<void> connect(String server) async {
    channel = WebSocketChannel.connect(Uri.parse('ws://$server'));
  }

  // 创建房间（主机）
  void createRoom(String room) {
    isHost = true;
    roomId = room;
    channel?.sink.add(jsonEncode({'type': 'create', 'room': roomId}));
  }

  // 加入房间（客机）
  void joinRoom(String room) {
    isHost = false;
    roomId = room;
    channel?.sink.add(jsonEncode({'type': 'join', 'room': roomId}));
  }

  // 发送按键指令
  void sendButton(int btn, bool pressed) {
    channel?.sink.add(
      jsonEncode({'type': 'input', 'btn': btn, 'press': pressed}),
    );
  }

  // 监听远程指令
  void listenRemoteInput() {
    final core = LibretroCore.instance;
    channel?.stream.listen((msg) {
      final data = jsonDecode(msg);
      if (data['type'] == 'input') {
        int btn = data['btn'];
        bool press = data['press'];
        core.setButton(btn, press);
      }
    });
  }

  void close() {
    channel?.sink.close();
  }
}
