import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/utils/permission.dart';
import 'package:music_player/utils/song.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PlaylistProvider extends ChangeNotifier {
  PlaylistProvider(BuildContext context) {
    Permissions.requestPermissions(context).then((_) {
      loadAudioFiles(context);
      listenToDuration();
    });
  }

  final List<Song> _playlists = [];

  bool favorite = false;
  int? _currentSongIndex;
  bool _isPlaying = false;

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _volume = 0.5;
  bool _isMuted = false;
  int _isRepeat =
      0; // i want to set 3 values for repeat 0-> repeat all, 1-> repeat one, 2-> not repeat
  bool _isShuffle = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> loadAudioFiles(BuildContext context) async {
    await Permissions.requestPermissions(context);

    final Directory? rootDir = Directory('/storage/emulated/0');
    if (rootDir != null) {
      await _findMp3Files(rootDir);
      notifyListeners();
    }
  }

  Future<void> _findMp3Files(Directory dir) async {
    try {
      final List<FileSystemEntity> entities = dir.listSync();

      for (var entity in entities) {
        if (entity is Directory) {
          if (entity.path.contains("PLAYit") ||
              entity.path.contains("Alarms") ||
              entity.path.contains("Notifications")) {
            continue;
          }

          await _findMp3Files(entity);
        } else if (entity is File &&
            (entity.path.endsWith('.mp3') || entity.path.endsWith('.wav'))) {
          print("File found: ${entity.path}");
          _playlists.add(Song(
            songName: entity.uri.pathSegments.last,
            artistName: 'Unknown Artist',
            albumArtImagePath: 'assets/images/musiclogo.png',
            audioPath: entity.path,
          ));
        }
      }
    } catch (e) {
      print("Error accessing directory ${dir.path}: $e");
    }
  }

  // Getters
  List<Song> get playlist => _playlists;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  double get volume => _volume;
  bool get isMuted => _isMuted;
  int get isRepeat => _isRepeat;

  bool get isShuffle => _isShuffle;

  // Setters
  set currentSongIndex(int? index) {
    _currentSongIndex = index;
    if (index != null) {
      play();
    }
    notifyListeners();
  }

  set isPlaying(bool playing) {
    _isPlaying = playing;
  }

  set currentDuration(Duration duration) {
    _currentDuration = duration;
    notifyListeners();
  }

  // Set volume
  set volume(double newVolume) {
    _volume = newVolume;
    _audioPlayer.setVolume(_isMuted ? 0.0 : newVolume);
    notifyListeners();
  }

  // Play song
  void play() async {
    final String path = _playlists[currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    seek(Duration.zero);
    await _audioPlayer.play(DeviceFileSource(path));

    _isPlaying = true;
    notifyListeners();
  }

  // Pause the current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume
  void pauseOrResume() async {
    _isPlaying ? pause() : resume();
  }

  // Seek to specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

// reapeat one song
  void repeat(int x) {
    _isRepeat = x;
    notifyListeners();
  }

  // shufle controller

  void shufle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  // Play next song
  void playNextSong() async {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < playlist.length - 1) {
        if (_isShuffle) {
          int length = playlist.length;
          Random random = Random();
          int randomIndex = random.nextInt(length);
          currentSongIndex = randomIndex;
        } else {
          currentSongIndex = _currentSongIndex! + 1;
        }
      } else {
        currentSongIndex = 0;
      }
    }
  }

  // play next for repeat one
  void playNextSongForRepeatOne() async {
    currentSongIndex = _currentSongIndex;
  }

//stop the song when the repeat is off
  void playNextSonRepeatOff() async {
    await _audioPlayer.stop();
    seek(Duration.zero);
    _isPlaying = false;
    notifyListeners();
  }

  // Play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    if (_currentSongIndex! > 0) {
      currentSongIndex = _currentSongIndex! - 1;
    } else {
      currentSongIndex = _playlists.length - 1;
    }
  }

  // Set volume
  void setVolume(double newVolume) {
    volume = newVolume;
  }

  // Mute or unmute
  void toggleMute() {
    _isMuted = !_isMuted;
    _audioPlayer.setVolume(_isMuted ? 0.0 : _volume);
    notifyListeners();
  }

  void listenToDuration() {
    // Total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // Current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // Listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isRepeat == 1) {
        playNextSongForRepeatOne();
      } else if (_isRepeat == 0) {
        playNextSong();
      } else {
        playNextSonRepeatOff();
      }
    });
  }
}
