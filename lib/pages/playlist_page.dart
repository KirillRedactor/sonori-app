// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
import 'package:musicplayer_app/classes/playlist_class.dart';
import 'package:musicplayer_app/components/cards_widgets.dart';

import 'dart:math' as math;

import 'package:musicplayer_app/components/general_components.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;

  const PlaylistPage({super.key, required this.playlistId});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  PlaylistClass? playlistClass;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fc.getPlaylist(widget.playlistId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          playlistClass = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.black,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).viewPadding.top,
                  backgroundColor: Colors.black,
                  pinned: true,
                  // actions: [
                  //   IconButton(
                  //     onPressed: () => Modular.to.pushNamed('/settings'),
                  //     icon: Icon(Icons.settings),
                  //   ),
                  // ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    title: Text(
                      playlistClass?.title ?? "Unknown playlist",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    background: playlistClass?.artUri != null
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: playlistClass!.artUri!,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade400,
                            ),
                            errorWidget: (context, url, error) => errorImage,
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: SweepGradient(
                                transform: GradientRotation(-math.pi / 4),
                                colors: [
                                  Colors.deepPurpleAccent,
                                  Colors.redAccent,
                                  Colors.deepOrangeAccent,
                                ],
                                stops: [0.30, 0.70, 1],
                              ),
                            ),
                            child: const Icon(
                              Icons.subscriptions,
                              size: 200,
                            ),
                          ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Subscribe",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
                            ),
                            IconButton(
                              onPressed: () => mpc.playPlaylist(playlistClass!,
                                  playPlaylist: true, isShuffle: true),
                              icon: const Icon(Icons.shuffle),
                            ),
                            const Gap(20),
                            TextButton(
                              onPressed: () => mpc.playPlaylist(playlistClass!,
                                  playPlaylist: true),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*SliverToBoxAdapter(
                  child: FutureBuilder(
                    future: fc.getListOfMusicItems(playlistClass!.tracksId),
                    builder: (context, snapshot) {
                      print("hello ${snapshot.data}");
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!
                              .map((e) => ExoItem.trackFromClass(musicItem: e))
                              .toList(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),*/
                SliverToBoxAdapter(
                  child: FutureBuilder<List<MusicItem>>(
                    future: fc.getListOfMusicItems(playlistClass!.tracksId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // playlistClass!.tracks = snapshot.data!;
                        return Column(
                          children: snapshot.data!
                              .map(
                                (e) => ExoItem.trackFromClass(
                                  musicItem: e,
                                  playlistClass: playlistClass,
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
          );
        }
      },
    );
  }
}
