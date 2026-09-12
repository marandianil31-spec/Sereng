import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._internal();

  static final AudioPlayerService _instance =
      AudioPlayerService._internal();

  factory AudioPlayerService() {
    return _instance;
  }

  static AudioPlayerService get instance =>
      _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> play(String url) async {
    if (url.isEmpty) return;

    await _player.setUrl(url);
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
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // App ke normal screen navigation me
  // isko call NAHI karna hai.
  Future<void> disposePlayer() async {
    await _player.dispose();
  }
}
