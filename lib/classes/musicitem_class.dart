import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/user_class.dart';

class MusicItem {
  String id;
  String uri;
  String? _title;
  String? _artistId;
  String? _artistUsername;
  // ignore: unused_field
  UserClass? _artistClass;
  MediaItem? mediaItem;
  String? artUri;
  int? index;
  int? _color;

  MusicItem({
    required this.id,
    this.mediaItem,
    this.index,
    required this.uri,
    this.artUri,
    Color? color,
    String? title,
    String? artistId,
    String? artistUsername,
  }) {
    _title = title;
    _artistId = artistId;
    _artistUsername = artistUsername;
    _color = color?.value;
    mediaItem ??= MediaItem(
      id: id,
      title: this.title,
      artist: artist,
      artUri: artUri != null ? Uri.parse(artUri!) : null,
    );
  }

  String get title => _title ?? "Unknown track";
  Future<UserClass> get artistClass async =>
      fc.getUser(_artistId ?? "US000000000");
  String get artist => _artistUsername ?? "Unknown musicial";
  Color get color => Color(_color ?? Colors.white.value);

  // MediaItem get mediaItem => MediaItem(id: uri, title: title, )

  static final empty = MusicItem(
    id: "0",
    uri: "",
  );

  toJson() {
    return {
      "id": id,
      "title": title,
      "uri": uri,
      "artUri": artUri,
      "artistId": _artistId,
      "color": _color,
    };
  }

  static MusicItem fromJson(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return MusicItem(
      id: document.id,
      title: data["title"],
      uri: data["uri"],
      artUri: data["artUri"],
      artistId: data["artistId"],
      color: Color(data["color"]),
    );
  }

  MusicItem copyWith({
    String? id,
    String? uri,
    MediaItem? mediaItem,
    int? index,
    Color? color,
    String? title,
    String? artistId,
    String? artistUsername,
  }) {
    return MusicItem(
      id: id ?? this.id,
      uri: uri ?? this.uri,
      mediaItem: mediaItem ?? this.mediaItem,
      index: index ?? this.index,
      color: color ?? this.color,
      title: title ?? _title,
      artistId: artistId ?? _artistId,
      artistUsername: artistUsername ?? _artistUsername,
    );
  }
}

List<MusicItem> listOfMusicItems = [mIFirst, mISecond, mIThird, mIFourth];

MusicItem mIFirst = MusicItem(
  id: "TR100000000",
  title: "8 Legged Dreams",
  artistId: "US120000001",
  artistUsername: "Unlike Pluto",
  uri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/t123456789.mp3?alt=media&token=9c9c9bc3-9e71-42e6-a266-f4d46395d8c7&_gl=1*f8ypit*_ga*MzMyNDEwNzEyLjE2ODUyMTAzNjI.*_ga_CW55HF8NVT*MTY4NTQ2MjMwOS4xLjEuMTY4NTQ2MjM4My4wLjAuMA..",
  artUri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/243b9e26190d947bfc046b6360446b2b.1000x1000x1.jpg?alt=media&token=7b901867-934c-4030-a05a-40d878916459",
  color: const Color.fromARGB(219, 255, 98, 0),
);

MusicItem mISecond = MusicItem(
  id: "TR100000001",
  uri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.mp3?alt=media&token=809d7477-d13b-4487-829f-8f96df2abf06",
  title: "Stamp on the ground",
  artistUsername: "Jim Yosef, Scarlett",
  artUri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Stamp-on-the-ground_Jim-Yosef_Scarlett.png?alt=media&token=7cbad75f-f36f-400d-b498-e856bdd63efb",
  color: const Color.fromARGB(255, 180, 74, 141),
);

MusicItem mIThird = MusicItem(
  id: "TR100000002",
  uri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Jim%20Yosef%2C%20Scarlett%20-%20Battlecry.mp3?alt=media&token=f8654e61-afd1-43eb-93ec-8dc3cc5aefec",
  title: "Battlecry (Heart of Courage)",
  artistUsername: "Jim Yosef, Scarlett",
  artUri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Scarlett.png?alt=media&token=6e279561-f3de-4e52-9441-45a2e3186afd",
  color: const Color.fromARGB(219, 187, 95, 49),
);
MusicItem mIFourth = MusicItem(
  id: "TR100000003",
  uri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Throne%20(ft.%20Neoni)%20-%20Lost%20Identities%20Remix.mp3?alt=media&token=9c3e9879-7afa-4213-82dd-0ce8ba0952b3",
  title: "Throne(ft. Neoni) - Lost Identities Remix",
  artistUsername: "Rival, Neoni, Lost Identities",
  artUri:
      "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/Throne%20(ft.%20Neoni)%20-%20Lost%20Identities%20Remix.jpg?alt=media&token=929a3c13-9a69-409a-a31c-3720200ee0e2",
  color: const Color.fromARGB(219, 31, 31, 37),
);
