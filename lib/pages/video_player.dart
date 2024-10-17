import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({super.key, required this.videoUrl});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
      autoPlay: true,
      videoPlayerController: VideoPlayerController.file(File(widget.videoUrl)),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: FlickVideoPlayer(
                    flickManager: flickManager,
                    flickVideoWithControls: FlickVideoWithControls(
                      controls: FlickPortraitControls(
                        progressBarSettings: FlickProgressBarSettings(
                          playedColor: const Color.fromARGB(255, 3, 242, 19),
                          bufferedColor: Colors.green[200]!,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
