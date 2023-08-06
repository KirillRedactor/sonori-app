// ignore_for_file: prefer_const_constructors, unused_import

import "dart:async";

import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:musicplayer_app/classes/music_player_class.dart";
import 'dart:ui' as ui;

MusicItem mIFirst = MusicItem(
  id: 0,
  mediaItem: MediaItem(
    id: "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/t123456789.mp3?alt=media&token=9c9c9bc3-9e71-42e6-a266-f4d46395d8c7&_gl=1*f8ypit*_ga*MzMyNDEwNzEyLjE2ODUyMTAzNjI.*_ga_CW55HF8NVT*MTY4NTQ2MjMwOS4xLjEuMTY4NTQ2MjM4My4wLjAuMA..",
    title: "8 Legged Dreams",
    artist: "Unlike Pluto",
    album: "No album",
    artUri: Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/243b9e26190d947bfc046b6360446b2b.1000x1000x1.jpg?alt=media&token=7b901867-934c-4030-a05a-40d878916459"),
  ),
);

MusicItem mISecond = MusicItem(
  id: 0,
  mediaItem: MediaItem(
    id: "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.mp3?alt=media&token=809d7477-d13b-4487-829f-8f96df2abf06",
    title: "Stamp on the ground",
    artist: "Jim Yosef, Scarlett",
    album: "No album",
    artUri: Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb"),
  ),
);

MusicItem mIThird = MusicItem(
  id: 0,
  mediaItem: MediaItem(
    id: "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Jim%20Yosef%2C%20Scarlett%20-%20Battlecry.mp3?alt=media&token=f8654e61-afd1-43eb-93ec-8dc3cc5aefec",
    title: "Battlecry (Heart of Courage)",
    artist: "Jim Yosef, Scarlett",
    album: "No album",
    artUri: Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Scarlett.png?alt=media&token=6e279561-f3de-4e52-9441-45a2e3186afd"),
  ),
);
MusicItem mIFourth = MusicItem(
  id: 0,
  mediaItem: MediaItem(
    id: "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Throne%20(ft.%20Neoni)%20-%20Lost%20Identities%20Remix.mp3?alt=media&token=9c3e9879-7afa-4213-82dd-0ce8ba0952b3",
    title: "Throne(ft. Neoni) - Lost Identities Remix",
    artist: "Rival, Neoni, Lost Identities",
    album: "No album",
    artUri: Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Throne%20(ft.%20Neoni)%20-%20Lost%20Identities%20Remix.jpg?alt=media&token=929a3c13-9a69-409a-a31c-3720200ee0e2"),
  ),
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late StreamSubscription<MediaItem> _stream;
  @override
  void initState() {
    // _stream =
    //     GetIt.I.get<MusicPlayerClass>().currentPlaying.stream.listen((event) {
    //   setState(() {
    //     _currentPlayingMediaItem = event;
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Home page",
          style: TextStyle(
            // foreground: Paint()
            //   ..shader = ui.Gradient.linear(
            //     const Offset(0, 20),
            //     const Offset(150, 20),
            //     <Color>[
            //       Color.fromARGB(255, 202, 202, 202),
            //       const Color.fromARGB(255, 255, 255, 255),
            //     ],
            //   ),
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          TextButton(
            child: Text("Play test playlist"),
            onPressed: () => GetIt.I<MusicPlayerClass>().updateQueue([
              mIFourth,
              mISecond,
              mIThird,
              mIFirst,
              mIFourth,
              mISecond,
              mIThird,
              mIFirst,
              mISecond,
              mIThird,
              mIFourth,
              mIFirst,
            ], playQueue: true),
          ),
        ],
      ),
    );
  }
}