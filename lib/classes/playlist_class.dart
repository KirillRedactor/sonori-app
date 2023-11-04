import 'package:musicplayer_app/classes/musician_class.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';

class PlaylistClass {
  String id;
  String title;
  String? description;
  List<String> tracksId;
  List<MusicItem>? tracks;
  String musicianId;
  MusicianClass? musician;

  PlaylistClass({
    required this.id,
    required this.title,
    this.description,
    required this.tracksId,
    this.tracks,
    required this.musicianId,
    this.musician,
  });

  PlaylistClass copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? tracksId,
    List<MusicItem>? tracks,
    String? musicianId,
    MusicianClass? musician,
  }) =>
      PlaylistClass(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        tracksId: tracksId ?? this.tracksId,
        tracks: tracks ?? this.tracks,
        musicianId: musicianId ?? this.musicianId,
        musician: musician ?? this.musician,
      );
}

List<PlaylistClass> listOfPlaylists = [firstPlaylist];

PlaylistClass firstPlaylist = PlaylistClass(
  id: "PL100000000",
  title: "First playlist",
  tracksId: ["TR100000000", "TR100000002"],
  musicianId: "MM100000001",
);
