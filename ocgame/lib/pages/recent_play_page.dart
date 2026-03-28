/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:41:50
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:41:56
 * @FilePath: /ocgame/lib/pages/recent_play_page.dart
 * @Description: 注释信息
 */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/recent_play.dart';

class RecentPlayPage extends StatefulWidget {
  const RecentPlayPage({super.key});

  @override
  State<RecentPlayPage> createState() => _RecentPlayPageState();
}

class _RecentPlayPageState extends State<RecentPlayPage> {
  List<RecentPlay> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await RecentPlayManager.getList();
    setState(() => _list = list);
  }

  String _formatTime(int ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat('MM/dd HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('最近游玩'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await RecentPlayManager.clear();
              await _load();
            },
          ),
        ],
      ),
      body: _list.isEmpty
          ? const Center(child: Text('暂无记录'))
          : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (c, i) {
                final item = _list[i];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(item.romName),
                  subtitle: Text('上次游玩: ${_formatTime(item.timestamp)}'),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    // 这里可以做“继续游戏”逻辑
                    // 因为是本地记录，通常提示用户重新选择ROM
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('请重新选择ROM: ${item.romName}')),
                    );
                  },
                );
              },
            ),
    );
  }
}
