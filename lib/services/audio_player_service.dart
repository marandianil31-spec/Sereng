import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._internal();

  static final AudioPlayerService _instance =
      AudioPlayerService._internal();

  factory AudioPlayerService() {
    return _instance;
  }

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  String? currentUrl;

  Future<void> play(String url) async {
    // Same song already loaded hai
    if (currentUrl != url) {
      currentUrl = url;

      await _player.setUrl(url);
    }

    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    currentUrl = null;
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
