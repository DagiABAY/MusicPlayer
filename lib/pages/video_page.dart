import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:music_player/pages/video_player.dart';
import 'package:music_player/providers/video_provider.dart';
import 'package:music_player/utils/drawer.dart';
import 'package:music_player/utils/videos.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(builder: (context, provider, _) {
      final List<Videos> videos = provider.videos;

      return Scaffold(
          drawer: const MyDrawer(),
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text('V I D E O S'),
          ),
          body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                Videos video = videos[index];
                return FutureBuilder<Uint8List?>(
                  future: getCachedThumbnail(
                      video.videoPath, provider), // Use cached thumbnails
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Stack(
                        children: [
                          const Center(child: CircularProgressIndicator()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerPage(
                                      videoUrl: video.videoPath),
                                ),
                              );
                            },
                            child: Text(
                              video.videoName,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoPlayerPage(videoUrl: video.videoPath),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.play_circle_filled,
                              color: Colors.white.withOpacity(0.8),
                              size: 60,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoPlayerPage(videoUrl: video.videoPath),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          color: Theme.of(context).colorScheme.secondary,
                          shadowColor: const Color.fromARGB(255, 98, 96, 96),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: snapshot.data != null
                                        ? SizedBox(
                                            width: double.infinity,
                                            child: Image.memory(
                                              snapshot.data!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.videocam,
                                            size: 60,
                                          ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    video.videoName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 60,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              }));
    });
  }

  Future<Uint8List?> getCachedThumbnail(
      String videoPath, VideoProvider provider) async {
    // Check if the thumbnail is already cached
    if (provider.thumbnailCache.containsKey(videoPath)) {
      print("from cache");
      return provider.thumbnailCache[videoPath];
    }

    // If not in cache, get a new thumbnail
    print("not from cache");
    final thumbnail = await getVideoThumbnail(videoPath);

    // Cache the new thumbnail
    provider.setThumbnailCache({videoPath: thumbnail});
    return thumbnail;
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
