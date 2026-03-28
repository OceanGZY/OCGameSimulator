/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:37:03
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:37:09
 * @FilePath: /ocgame/lib/pages/online_room_page.dart
 * @Description: 注释信息
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../online/online_sync.dart';
import '../voice/voice_chat.dart';
import 'emulator_page.dart';

class OnlineRoomPage extends StatefulWidget {
  const OnlineRoomPage({super.key});

  @override
  State<OnlineRoomPage> createState() => _OnlineRoomPageState();
}

class _OnlineRoomPageState extends State<OnlineRoomPage> {
  final sync = OnlineSync.instance;
  final voice = VoiceChat.instance;
  bool playerReady = false;

  @override
  void initState() {
    super.initState();
    voice.init();
    sync.listenRemoteInput();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("房间号: ${sync.roomId}", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 12),
            Text(
              sync.isHost ? "你是主机" : "你是客机",
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() => playerReady = true);
              },
              child: const Text("准备就绪"),
            ),
            const SizedBox(height: 12),
            if (playerReady)
              ElevatedButton(
                onPressed: () {
                  app.enterOnline(sync.roomId, sync.isHost);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const EmulatorPage()),
                  );
                },
                child: const Text("开始游戏"),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                app.toggleVoice();
              },
              child: Text(app.voiceEnabled ? "关闭语音" : "开启语音"),
            ),
          ],
        ),
      ),
    );
  }
}
