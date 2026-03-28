import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'dart:typed_data';

class VoiceChat {
  static final VoiceChat instance = VoiceChat._internal();
  VoiceChat._internal();

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool isRecording = false;

  Future<void> init() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
  }

  // 开始语音
  Future<void> startVoice(void Function(Uint8List) onData) async {
    isRecording = true;

    // 关键修复：这里必须是 StreamSink<Uint8List>
    final sink = StreamController<Uint8List>();
    sink.stream.listen(onData);

    await _recorder.startRecorder(
      codec: Codec.pcm16,
      sampleRate: 16000,
      numChannels: 1,
      toStream: sink.sink, // ✅ 完全匹配
    );
  }

  // 停止语音
  Future<void> stopVoice() async {
    isRecording = false;
    await _recorder.stopRecorder();
  }

  // 播放语音
  Future<void> playVoice(Uint8List data) async {
    try {
      await _player.startPlayer(
        fromDataBuffer: data,
        codec: Codec.pcm16,
        sampleRate: 16000,
        numChannels: 1,
      );
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
    await _player.closePlayer();
  }
}
