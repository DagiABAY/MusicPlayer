import 'package:flutter/material.dart';
import 'package:music_player/pages/home_page.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/providers/theme_providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlaylistProvider(context),
      ),
    ],
    child: const MyApp(),
  )
      // ChangeNotifierProvider(
      //   create: (context) => ThemeProvider(),
      //   child: const MyApp(),
      // ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomePage(),
    );
  }
}


//  bottomNavigationBar: CurvedNavigationBar(
//           backgroundColor: Theme.of(context).colorScheme.background,
//           color: Theme.of(context).colorScheme.primary,
//           onTap: (value) {
//             if (value == 1) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const HomePage(),
//                 ),
//               );
//             } else if (value == 2) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const SettingsPage(),
//                 ),
//               );
//             } else {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const SettingsPage(),
//                 ),
//               );
//             }
//           },
//           items: const [
//             const Icon(
//               Icons.music_note,
//               color: Colors.white,
//             ),
//             Icon(
//               Icons.video_camera_back,
//               color: Colors.white,
//             ),
//             Icon(
//               Icons.settings,
//               color: Colors.white,
//             ),
//           ]),