/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:36:37
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:36:39
 * @FilePath: /ocgame/lib/pages/online_hall_page.dart
 * @Description: 注释信息
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../online/online_sync.dart';
import 'online_room_page.dart';

class OnlineHallPage extends StatefulWidget {
  const OnlineHallPage({super.key});

  @override
  State<OnlineHallPage> createState() => _OnlineHallPageState();
}

class _OnlineHallPageState extends State<OnlineHallPage> {
  final List<String> rooms = ["房间-001", "房间-002", "房间-003"];
  final sync = OnlineSync.instance;

  @override
  void initState() {
    super.initState();
    sync.connect("your-server.com:8080");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("联机大厅")),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (c, i) {
          return ListTile(
            title: Text(rooms[i]),
            subtitle: const Text("2人在线"),
            trailing: ElevatedButton(
              child: const Text("加入"),
              onPressed: () {
                sync.joinRoom(rooms[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OnlineRoomPage()),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final room = "房间-${DateTime.now().microsecondsSinceEpoch}";
          sync.createRoom(room);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OnlineRoomPage()),
          );
        },
      ),
    );
  }
}
