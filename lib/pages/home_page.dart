import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/pages/settings_page.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/utils/drawer.dart';
import 'package:music_player/utils/player_ani.dart';
import 'package:music_player/utils/song.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic playlistProvider;
  @override
  void initState() {
    super.initState();

    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int index) {
    if (playlistProvider.currentSongIndex == index) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        ),
      );
    } else {
      playlistProvider.currentSongIndex = index;
      playlistProvider.currentDuration = Duration.zero;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.redAccent,
      Colors.yellowAccent,
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("M U S I C  L I B R A R Y"),
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];
              return ListTile(
                title: Text(
                  song.songName,
                  style: value.currentSongIndex == index
                      ? const TextStyle(color: Colors.green)
                      : const TextStyle(),
                ),
                subtitle: Text(
                  song.artistName,
                  style: value.currentSongIndex == index
                      ? const TextStyle(color: Colors.green)
                      : const TextStyle(),
                ),
                leading: value.currentSongIndex == index
                    ? value.isPlaying
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: MusicVisualizer(
                              height: true,
                            ))
                        : const Icon(Icons.play_arrow)
                    : Text(
                        (index + 1).toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}

class PlayingAnimation extends StatelessWidget {
  const PlayingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
