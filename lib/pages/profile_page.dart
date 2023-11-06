import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/components/cards_widgets.dart';
import 'dart:math' as math;

import '../components/bottom_widget.dart';
import '../components/general_components.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// enum Page { collection, tracks, albums, playlist }

class _ProfilePageState extends State<ProfilePage> {
  UserClass? userClass;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fc.getUser(widget.userId ?? fc.getLocalUser().id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(backgroundColor: Colors.black);
        } else if (snapshot.hasData) {
          userClass = snapshot.data;
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
                      userClass?.name ?? "Unknown user",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    background: userClass?.avatarUri != null
                        ? CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: userClass!.avatarUri!,
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
                              Icons.person,
                              size: 300,
                            ),
                          ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      if (userClass?.id != fc.getLocalUser().id)
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
                              const Gap(20),
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
                      //* My collection part
                      if (userClass?.id == fc.getLocalUser().id)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                "My collection",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              leading: const Icon(Icons.favorite_border),
                              title: const Text(
                                "Favorite tracks",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              leading: const Icon(Icons.view_day),
                              title: const Text(
                                "Playlists",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              leading: const Icon(Icons.download),
                              title: const Text(
                                "Downloaded tracks",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () => Modular.to.pushNamed('/settings'),
                              leading: const Icon(Icons.settings),
                              title: const Text(
                                "Settings",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      //* Tracks part
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              "Best tracks",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          ExoItem.trackFromClass(musicItem: mIFirst),
                          ExoItem.trackFromClass(musicItem: mISecond),
                          ExoItem.trackFromClass(musicItem: mIFourth),
                          ListTile(
                            onTap: () {},
                            trailing: const Icon(
                              Icons.navigate_next,
                              size: 30,
                            ),
                            title: const Text(
                              "All tracks",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const BottomWidget(),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            backgroundColor: Colors.black,
          );
        }
      },
    );
  }
}
