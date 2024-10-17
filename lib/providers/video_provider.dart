import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_player/utils/permission.dart';
import 'package:music_player/utils/videos.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoProvider extends ChangeNotifier {
  VideoProvider(BuildContext context) {
    initialize(context);
    // Permissions.requestPermissions(context).then((_) {
    //   loadVideoFiles(context);
    //   preloadThumbnails(videos);
    // });
  }

  List<Videos> videos = [];

  int? _currentVideoIndex;

  bool _isPlaying = false;

  final Map<String, Uint8List?> _thumbnailCache = {};

/* 
  G E T T E R S

*/
  int? get currentVideoIndex => _currentVideoIndex;
  bool get isPlaying => _isPlaying;

  Map<String, Uint8List?> get thumbnailCache => _thumbnailCache;
/* 

  S E T T E R S

*/
  set currentVideoIndex(int? index) {
    _currentVideoIndex = index;
    if (index != null) {
      // play();
    }
    notifyListeners();
  }

  Future<void> initialize(BuildContext context) async {
    await Permissions.requestPermissions(context);
    await loadVideoFiles(context);
    await preloadThumbnails(videos); // Preload thumbnails after loading videos
  }

  void setThumbnailCache(Map<String, Uint8List?> thumbnails) {
    _thumbnailCache.addAll(thumbnails);
    notifyListeners();
  }

  set isPlaying(bool playing) {
    _isPlaying = playing;
  }

  Future<void> loadVideoFiles(BuildContext context) async {
    await Permissions.requestPermissions(context);

    final Directory rootDir = Directory('/storage/emulated/0');
    await _findVideoFiles(rootDir);
    notifyListeners();
  }

  Future<void> _findVideoFiles(Directory dir) async {
    try {
      final List<FileSystemEntity> entities = dir.listSync();

      for (var entity in entities) {
        if (entity is Directory) {
          if (entity.path.contains("PLAYit") ||
              entity.path.contains("Alarms") ||
              entity.path.contains("Notifications") ||
              entity.path.contains("Telegram") ||
              entity.path.contains("Telegram Video")) {
            continue;
          }

          await _findVideoFiles(entity);
        } else if (entity is File &&
            (entity.path.endsWith('.mp4') || entity.path.endsWith('.wav'))) {
          print("File found: ${entity.path}");
          videos.add(Videos(
            videoName: entity.uri.pathSegments.last,
            videoPath: entity.path,
          ));
        }
      }
    } catch (e) {
      print("Error accessing directory ${dir.path}: $e");
    }
  }

  Future<void> preloadThumbnails(List<Videos> videos) async {
    for (var video in videos) {
      final thumbnail = await getVideoThumbnail(video.videoPath);
      if (thumbnail != null) {
        _thumbnailCache[video.videoPath] = thumbnail;
      }
    }
    notifyListeners();
  }

  Future<Uint8List?> getVideoThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      quality: 50,
    );
  }
}
