/*
 * @Author: OCEAN.GZY
 * @Date: 2026-03-28 17:39:03
 * @LastEditors: OCEAN.GZY
 * @LastEditTime: 2026-03-28 17:39:50
 * @FilePath: /ocgame/lib/utils/recent_play.dart
 * @Description: 注释信息
 */
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class RecentPlay {
  final String romName;
  final int timestamp;

  RecentPlay({required this.romName, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {'romName': romName, 'timestamp': timestamp};
  }

  static RecentPlay fromJson(Map<String, dynamic> json) {
    return RecentPlay(romName: json['romName'], timestamp: json['timestamp']);
  }
}

class RecentPlayManager {
  static const _key = 'recent_play_list';
  static const _maxCount = 20;

  static Future<List<RecentPlay>> getList() async {
    final sp = await SharedPreferences.getInstance();
    final str = sp.getString(_key);
    if (str == null) return [];
    try {
      final list = json.decode(str) as List;
      return list.map((e) => RecentPlay.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> add(String romName) async {
    final list = await getList();
    // 移除已存在的同名记录
    list.removeWhere((e) => e.romName == romName);
    // 插入到最前面
    list.insert(
      0,
      RecentPlay(
        romName: romName,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    // 限制数量
    if (list.length > _maxCount) {
      list.removeRange(_maxCount, list.length);
    }
    // 保存
    final sp = await SharedPreferences.getInstance();
    sp.setString(_key, json.encode(list.map((e) => e.toJson()).toList()));
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    sp.remove(_key);
  }
}
