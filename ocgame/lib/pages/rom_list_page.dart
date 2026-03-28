import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ocgame/pages/online_hall_page.dart';
import 'package:ocgame/pages/recent_play_page.dart';
import 'package:ocgame/utils/recent_play.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import '../providers/app_provider.dart';
import 'emulator_page.dart';

class RomListPage extends StatefulWidget {
  const RomListPage({super.key});

  @override
  State<RomListPage> createState() => _RomListPageState();
}

class _RomListPageState extends State<RomListPage> {
  final Map<String, Uint8List> _assetsRoms = {};

  @override
  void initState() {
    super.initState();
    _loadAssetsRoms();
  }

  Future<void> _loadAssetsRoms() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final list = manifest.listAssets().where(
      (e) => e.startsWith('assets/roms/'),
    );
    for (final path in list) {
      final bytes = await rootBundle.load(path);
      final name = path.split('/').last;
      _assetsRoms[name] = bytes.buffer.asUint8List();
    }
    setState(() {});
  }

  Future<void> _pickLocalRom() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['nes'],
    );
    if (result == null || result.files.single.bytes == null) return;

    final name = result.files.single.name;
    final data = result.files.single.bytes!;

    if (mounted) {
      final p = Provider.of<AppProvider>(context, listen: false);
      p.loadGame(data, name);
      RecentPlayManager.add(name);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EmulatorPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('游戏库'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _pickLocalRom,
          ),
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OnlineHallPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecentPlayPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 240,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _assetsRoms.length,
        itemBuilder: (c, i) {
          final name = _assetsRoms.keys.elementAt(i);
          final data = _assetsRoms[name]!;
          return GestureDetector(
            onTap: () {
              final p = Provider.of<AppProvider>(context, listen: false);
              p.loadGame(data, name);
              RecentPlayManager.add(name);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmulatorPage()),
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: 'https://retromatch.cc/covers/$name.png',
                    width: 160,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => Container(
                      width: 160,
                      height: 180,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.gamepad,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
