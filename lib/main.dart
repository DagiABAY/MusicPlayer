import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/pages/home_page.dart';
import 'package:music_player/pages/settings_page.dart';
import 'package:music_player/pages/video_page.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/providers/theme_providers.dart';
import 'package:music_player/providers/video_provider.dart';
import 'package:music_player/utils/drawer.dart';
import 'package:music_player/utils/videos.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlaylistProvider(context),
      ),
      ChangeNotifierProvider(
        create: (context) => VideoProvider(context),
      )
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
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

    @override
  void initState() {
    super.initState();
    // Access the provider and initialize it with context
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.initialize(context);
  }
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(
        Icons.home,
      ),
      const Icon(Icons.music_note),
      const Icon(Icons.video_call),
      const Icon(Icons.settings)
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          index: index,
          backgroundColor: Theme.of(context).colorScheme.surface,
          color: Theme.of(context).colorScheme.primary,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          height: 70,
          items:  [
            Icon(
              Icons.music_note,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.video_camera_back,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.background,
            ),
          ]),
      drawer: const MyDrawer(),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: getSelectedPage(index),
      ),
    );
  }

  Widget? getSelectedPage(int index) {
    print("indes$index");
    Widget? widget;
    switch (index) {
      case 0:
        widget = const HomePage();
        break;
      case 1:
        widget =  VideoPage();
        break;
      case 2:
        widget = const SettingsPage();
        break;
      default:
        const SettingsPage();
    }

    return widget;
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