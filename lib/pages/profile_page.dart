import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/components/cards_widgets.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

enum Page { collection, tracks, albums, playlist }

class _ProfilePageState extends State<ProfilePage> {
  UserClass? userClass;
  Page currentPage = Page.collection;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fc.getUser(widget.userId ?? "US000000000"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
          );
        } else {
          userClass = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.black,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                /*SliverAppBar(
                  title: Text(
                    userClass?.username ?? userClass?.name ?? "Unknown user",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  backgroundColor: Colors.black,
                ),*/
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).viewPadding.top,
                  backgroundColor: Colors.black,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    title: Text(
                      userClass?.name ?? "Unknown user",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    background: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade400,
                      ),
                      errorWidget: (context, url, error) => errorImage,
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
                            TextButton(
                              onPressed: () {},
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
                /*SliverAppBar(
                  collapsedHeight: 20,
                  backgroundColor: Colors.black,
                  toolbarHeight: 20,
                  pinned: true,
                  flexibleSpace: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            currentPage = Page.collection;
                            setState(() {});
                          },
                          child: Text(
                            "My collection",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: currentPage == Page.collection
                                  ? FontWeight.w600
                                  : FontWeight.w100,
                            ),
                          ),
                        ),
                        Gap(10),
                        TextButton(
                          onPressed: () {
                            currentPage = Page.tracks;
                            setState(() {});
                          },
                          child: Text(
                            "Tracks",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: currentPage == Page.tracks
                                  ? FontWeight.w600
                                  : FontWeight.w100,
                            ),
                          ),
                        ),
                        Gap(10),
                        TextButton(
                          onPressed: () {
                            currentPage = Page.albums;
                            setState(() {});
                          },
                          child: Text(
                            "Albums",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: currentPage == Page.albums
                                  ? FontWeight.w600
                                  : FontWeight.w100,
                            ),
                          ),
                        ),
                        Gap(10),
                        TextButton(
                          onPressed: () {
                            currentPage = Page.playlist;
                            setState(() {});
                          },
                          child: Text(
                            "Playlists",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: currentPage == Page.playlist
                                  ? FontWeight.w600
                                  : FontWeight.w100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      currentPage == Page.collection
                          ? Container(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height -
                                    MediaQuery.of(context).viewPadding.top -
                                    MediaQuery.of(context).viewPadding.bottom -
                                    75,
                                maxHeight: double.infinity,
                              ),
                              child: Column(children: []),
                              color: Colors.red,
                            )
                          : Container(),
                      currentPage == Page.tracks
                          ? Container(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height -
                                    MediaQuery.of(context).viewPadding.top -
                                    MediaQuery.of(context).viewPadding.bottom -
                                    102,
                                maxHeight: double.infinity,
                              ),
                              color: Colors.red,
                            )
                          : Container(),
                    ],
                  ),
                ),*/
              ],
            ),
          );
        }
      },
    );
  }
}
