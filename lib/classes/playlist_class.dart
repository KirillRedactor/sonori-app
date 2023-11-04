import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';

class PlaylistClass {
  String id;
  String title;
  String? description;
  List<String> tracksId;
  List<MusicItem>? tracks;
  String authorId;
  UserClass? author;

  PlaylistClass({
    required this.id,
    required this.title,
    this.description,
    required this.tracksId,
    this.tracks,
    required this.authorId,
    this.author,
  });

  static PlaylistClass get empty => PlaylistClass(
        id: "PL000000000",
        title: "Unknown playlist",
        tracksId: [],
        authorId: "US000000000",
      );

  PlaylistClass copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? tracksId,
    List<MusicItem>? tracks,
    String? authorId,
    UserClass? author,
  }) =>
      PlaylistClass(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        tracksId: tracksId ?? this.tracksId,
        tracks: tracks ?? this.tracks,
        authorId: authorId ?? this.authorId,
        author: author ?? this.author,
      );
}

List<PlaylistClass> listOfPlaylists = [firstPlaylist];

PlaylistClass firstPlaylist = PlaylistClass(
  id: "PL100000000",
  title: "First playlist",
  tracksId: ["TR100000000", "TR100000002"],
  authorId: "MM100000001",
);
