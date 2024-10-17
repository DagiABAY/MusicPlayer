import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/utils/my_box.dart';
import 'package:provider/provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formatedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formatedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: (context, value, child) {
      final playlists = value.playlist;
      final currentSong = playlists[value.currentSongIndex ?? 0];
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Text(
                      'Now Playing...',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                MyBox(
                    child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                          child: value.isPlaying
                              ? Lottie.asset(
                                  'assets/images/my2.json',
                                  fit: BoxFit.cover,
                                  repeat: true,
                                  animate: true,
                                )
                              : Lottie.asset(
                                  'assets/images/my2.json',
                                  fit: BoxFit.cover,
                                  repeat: false,
                                  animate: false,
                                )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(value.isMuted
                                  ? Icons.volume_off
                                  : Icons.volume_up),
                              onPressed: () {
                                value.toggleMute();
                              },
                            ),
                            if (!value.isMuted)
                              Slider(
                                value: value.volume,
                                min: 0.0,
                                activeColor: Colors.green,
                                max: 1.0,
                                onChanged: (double newValue) {
                                  value.setVolume(newValue);
                                },
                              ),
                          ],
                        ),
                        const SizedBox(
                            // height:
                            //     MediaQuery.of(context).size.height / 2 / ,
                            // child: value.isPlaying
                            //     ? MusicVisualizer(
                            //         height: false,
                            //       )
                            //     : Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: List.generate(10, (index) {
                            //           return Container(
                            //             width: 10,
                            //             height: 20 + (index * 5).toDouble(),
                            //             color: colors[index % 4],
                            //           );
                            //         }),
                            //       ),
                            ),
                      ],
                    ),
                    Positioned(
                      left: 1,
                      bottom: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.songName.length > 20
                                      ? '${currentSong.songName.substring(0, 20)}...'
                                      : currentSong.songName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(currentSong.artistName)
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            IconButton(
                              onPressed: () {
                                value.favorite = !value.favorite;
                              },
                              icon: value.favorite
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(value.currentDuration)),
                          IconButton(
                              onPressed: () {
                                value.shufle();
                              },
                              icon: value.isShuffle
                                  ? const Icon(
                                      Icons.shuffle,
                                      color: Colors.green,
                                    )
                                  : const Icon(Icons.shuffle)),
                          if (value.isRepeat == 1)
                            IconButton(
                                onPressed: () {
                                  value.repeat(0);
                                },
                                icon: const Icon(
                                  Icons.repeat_one,
                                  color: Colors.green,
                                ))
                          else if (value.isRepeat == 0)
                            IconButton(
                                onPressed: () {
                                  value.repeat(2);
                                },
                                icon: const Icon(
                                  Icons.repeat,
                                  color: Colors.green,
                                ))
                          else
                            IconButton(
                                onPressed: () {
                                  value.repeat(1);
                                },
                                icon: const Icon(
                                  Icons.repeat,
                                  //color: Colors,,
                                )),
                          Text(formatTime(value.totalDuration)),
                        ],
                      ),
                    ),
                    // ProgressBar(
                    //   thumbGlowColor: Colors.green,
                    //   bufferedBarColor: Colors.yellow,

                    //   progressBarColor: Colors.green,
                    //   thumbColor: Colors.green,
                    //   barHeight: 6.0,
                    //   timeLabelLocation: TimeLabelLocation.none,

                    //   progress: value.currentDuration,
                    //   buffered: value.currentDuration+Duration(milliseconds: 4000),
                    //   total: value.totalDuration,
                    //   onSeek: (duration) {
                    //     value.seek(Duration(seconds: duration.inSeconds));
                    //   },
                    // ),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        min: 0,
                        max: value.totalDuration.inSeconds.toDouble(),
                        value: value.currentDuration.inSeconds.toDouble(),
                        activeColor: Colors.green,
                        onChanged: (double newValue) {
                          value.currentDuration =
                              Duration(seconds: newValue.toInt());
                        },
                        onChangeEnd: (double double) {
                          value.seek(Duration(seconds: double.toInt()));
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playPreviousSong,
                        child: const MyBox(
                          child: Icon(Icons.skip_previous),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: value.pauseOrResume,
                        child: MyBox(
                          child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playNextSong,
                        child: const MyBox(
                          child: Icon(Icons.skip_next),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
