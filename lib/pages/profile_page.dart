import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/components/cards_widgets.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserClass? userClass;

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
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              userClass?.name ?? "Unknown user",
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*ShaderMask(
                        shaderCallback: (Rect rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: SizedBox(
                          height: 20,
                          child: Transform.flip(
                            flipY: true,
                            child: CachedNetworkImage(
                              alignment: Alignment.bottomCenter,
                              fit: BoxFit.fitWidth,
                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade400,
                              ),
                              errorWidget: (context, url, error) =>
                                  Container(color: Colors.black),
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
