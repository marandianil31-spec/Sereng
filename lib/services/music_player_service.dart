import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerService extends ChangeNotifier {
  MusicPlayerService._internal() {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;

      if (state.processingState == ProcessingState.completed) {
        if (_repeatEnabled) {
          playSong(_currentIndex);
        } else {
          playNext();
        }
      }

      notifyListeners();
    });

    _player.positionStream.listen((value) {
      _position = value;
      notifyListeners();
    });

    _player.durationStream.listen((value) {
      _duration = value ?? Duration.zero;
      notifyListeners();
    });

    _player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
      }
    });
  }

  static final MusicPlayerService instance =
      MusicPlayerService._internal();

  static const MethodChannel _channel =
      MethodChannel('sereng/local_music');

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, dynamic>> _songs = [];

  int _currentIndex = -1;

  bool _isPlaying = false;
  bool _isLoading = false;
  bool _shuffleEnabled = false;
  bool _repeatEnabled = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  List<Map<String, dynamic>> get songs =>
      List.unmodifiable(_songs);

  AudioPlayer get player => _player;

  int get currentIndex => _currentIndex;

  bool get isPlaying => _isPlaying;

  bool get isLoading => _isLoading;

  bool get shuffleEnabled => _shuffleEnabled;

  bool get repeatEnabled => _repeatEnabled;

  Duration get position => _position;

  Duration get duration => _duration;

  Map<String, dynamic>? get currentSong {
    if (_currentIndex < 0 || _currentIndex >= _songs.length) {
      return null;
    }

    return _songs[_currentIndex];
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result =
          await _channel.invokeListMethod<dynamic>('getSongs');

      _songs
        ..clear()
        ..addAll(
          (result ?? <dynamic>[])
              .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item as Map),
              ),
        );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= _songs.length) return;

    final uri = _songs[index]['uri']?.toString();

    if (uri == null || uri.isEmpty) return;

    try {
      _currentIndex = index;
      _position = Duration.zero;
      _duration = Duration.zero;

      notifyListeners();

      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );

      await _player.play();
    } catch (error) {
      debugPrint('SERENG music playback error: $error');
      rethrow;
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentIndex == -1) {
      if (_songs.isNotEmpty) {
        await playSong(0);
      }
      return;
    }

    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> playNext() async {
    if (_songs.isEmpty) return;

    if (_shuffleEnabled && _songs.length > 1) {
      final choices =
          List<int>.generate(_songs.length, (index) => index)
            ..remove(_currentIndex);

      choices.shuffle();

      await playSong(choices.first);
      return;
    }

    if (_currentIndex + 1 < _songs.length) {
      await playSong(_currentIndex + 1);
    } else if (_repeatEnabled) {
      await playSong(0);
    } else {
      await _player.pause();
    }
  }

  Future<void> playPrevious() async {
    if (_songs.isEmpty) return;

    if (_position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    if (_currentIndex > 0) {
      await playSong(_currentIndex - 1);
    } else {
      await playSong(_songs.length - 1);
    }
  }

  Future<void> seek(Duration value) async {
    await _player.seek(value);
  }

  void toggleShuffle() {
    _shuffleEnabled = !_shuffleEnabled;
    notifyListeners();
  }

  void toggleRepeat() {
    _repeatEnabled = !_repeatEnabled;
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }
}
