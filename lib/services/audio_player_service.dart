import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._internal();

  static final AudioPlayerService instance =
      AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  // Play song
  Future<void> play(String url) async {
    if (url.isEmpty) {
      return;
    }

    await _player.setUrl(url);
    await _player.play();
  }

  // Pause song
  Future<void> pause() async {
    await _player.pause();
  }

  // Resume song
  Future<void> resume() async {
    await _player.play();
  }

  // Stop song
  Future<void> stop() async {
    await _player.stop();
  }

  // Seek song position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // Dispose player
  Future<void> dispose() async {
    await _player.dispose();
  }
}
