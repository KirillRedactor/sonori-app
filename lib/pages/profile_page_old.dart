import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'dart:ui' as ui;

import 'package:musicplayer_app/components/cards_widgets.dart';
import 'package:musicplayer_app/components/home_components.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Modular.to.navigate('/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                "User name",
                style: TextStyle(
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 40),
                      const Offset(200, 40),
                      <Color>[
                        const Color.fromARGB(255, 253, 89, 22),
                        // Color.fromARGB(255, 225, 13, 232),
                        const Color.fromARGB(255, 204, 52, 198),
                      ],
                    ),
                  // color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),
              floating: true,
              backgroundColor: Colors.black,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10000),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade400,
                          ),
                          errorWidget: (context, url, error) => errorImage,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Modular.to.pushNamed("/settings");
                        },
                        icon: const Icon(Icons.settings),
                      ),
                      IconButton(
                        onPressed: () {
                          Modular.to.pushNamed("/error");
                        },
                        icon: const Icon(Icons.error),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Favorite playlists",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlaylistCardWidget.standart(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 70, 13, 161),
                                  Color.fromARGB(255, 160, 29, 230),
                                  Color.fromARGB(255, 233, 179, 240),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                          title: "Liked tracks",
                        ),
                        const Gap(10),
                        MusicianCard.standard(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 161, 13, 13),
                                  Color.fromARGB(255, 230, 40, 40),
                                  Color.fromARGB(255, 240, 179, 179),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                          musicianName: "Random guy",
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Favorite musicians",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MusicianCard.standard(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 161, 13, 13),
                                  Color.fromARGB(255, 230, 40, 40),
                                  Color.fromARGB(255, 240, 179, 179),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                          musicianName: "Random guy",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 102 + MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
