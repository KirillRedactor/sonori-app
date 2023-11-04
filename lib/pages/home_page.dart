// ignore_for_file: prefer_const_constructors, unused_import

import "dart:async";
import "dart:io";

import "package:audio_service/audio_service.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:get_it/get_it.dart";
import "package:musicplayer_app/classes/music_player_class.dart";
import 'dart:ui' as ui;

import "package:musicplayer_app/components/cards_widgets.dart";
import "package:musicplayer_app/components/home_components.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "homepage.welcome_back".tr(),
              style: TextStyle(
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 40),
                    const Offset(200, 40),
                    <Color>[
                      Color.fromARGB(255, 253, 89, 22),
                      // Color.fromARGB(255, 225, 13, 232),
                      Color.fromARGB(255, 204, 52, 198),
                    ],
                  ),
                // color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
            backgroundColor: Colors.black,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "homepage.recently_listened".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FTHomeWidget(),
                      Gap(10),
                      HomeChip.standard(
                        text: "Playlist #2",
                        child: errorImage,
                      ),
                      Gap(10),
                      HomeChip.standard(
                        text: "Playlist #4",
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade400,
                          ),
                          errorWidget: (context, url, error) => errorImage,
                        ),
                      ),
                      Gap(10),
                      HomeChip(
                        text: Center(
                          child: Text(
                            "Gaming playlist for hard games from C00l Man",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade400,
                          ),
                          errorWidget: (context, url, error) => errorImage,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "homepage.only_for_you".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FTCardWidget(),
                      Gap(10),
                      PlaylistCardWidget.standart(
                        child: errorImage,
                        title: "Error",
                        description:
                            "Playlist is not found. You can delete them. Just tap or hold.",
                      ),
                      Gap(10),
                      PlaylistCardWidget.standart(
                        title: "Playlist",
                        description: "Tracks that you liked",
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade400,
                          ),
                          errorWidget: (context, url, error) => errorImage,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Musicians",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      MusicianCard.standard(
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade400,
                          ),
                          errorWidget: (context, url, error) => errorImage,
                        ),
                        musicianName: "Jim Yosef Scarlet and Another cool guys",
                      )
                    ],
                  ),
                ),
                SizedBox(height: 102 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FTCardWidget extends StatelessWidget {
  const FTCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlaylistCardWidget.standart(
      title: "Favorite tracks",
      description: "Tracks that you liked",
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              Color.fromARGB(255, 70, 13, 161),
              Color.fromARGB(255, 160, 29, 230),
              Color.fromARGB(255, 233, 179, 240),
            ],
          ),
        ),
        child: Icon(
          Icons.favorite,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class FTHomeWidget extends StatelessWidget {
  const FTHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeChip.standard(
      text: "Favorite tracks",
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              Color.fromARGB(255, 70, 13, 161),
              Color.fromARGB(255, 160, 29, 230),
              Color.fromARGB(255, 233, 179, 240),
            ],
          ),
        ),
        child: Icon(
          Icons.favorite,
          color: Colors.white,
        ),
      ),
    );
  }
}
