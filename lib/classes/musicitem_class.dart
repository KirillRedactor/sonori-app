import 'dart:ui';

import 'package:audio_service/audio_service.dart';

class MusicItem {
  String id;
  MediaItem mediaItem;
  int? index;
  Color? color;

  MusicItem(
      {required this.id, required this.mediaItem, this.index, this.color});

  static final empty = MusicItem(
    id: "0",
    mediaItem: const MediaItem(
      id: "",
      title: "Unknown track title",
    ),
  );

  MusicItem copyWith({
    String? id,
    MediaItem? mediaItem,
    int? index,
    Color? color,
  }) {
    return MusicItem(
      id: id ?? this.id,
      mediaItem: mediaItem ?? this.mediaItem,
      index: index ?? this.index,
      color: color ?? this.color,
    );
  }
}
