import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _audioPlayer1 = AudioPlayer();

  Future<void> playBackgroundAudio(List<String> audioFiles) async {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    String selectedAudio = audioFiles[Random().nextInt(audioFiles.length)];
    await _audioPlayer.play(AssetSource(selectedAudio));
  }

  Future<void> playSoundEffect(String file) async {
    await _audioPlayer1.play(AssetSource(file));
  }

  // Stops all audio playback
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    await _audioPlayer1.stop();
  }

  // Disposes audio resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _audioPlayer1.dispose();
  }
}
