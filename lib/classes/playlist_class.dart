import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';

class PlaylistClass {
  String id; // id of playlsit
  String title; // name of playlist
  String? description; // description of playlist
  List<String> tracksId; // ids of all tracks in playlist
  List<MusicItem>? tracks; // items of all tracks in playlist
  String authorId; // id of author of this playlist
  UserClass? author; // item of author of this playlist
  String? artUri; // link of painting of this playlist

  PlaylistClass({
    required this.id,
    required this.title,
    this.description,
    required this.tracksId,
    this.tracks,
    required this.authorId,
    this.author,
    this.artUri,
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
    String? artUri,
  }) =>
      PlaylistClass(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        tracksId: tracksId ?? this.tracksId,
        tracks: tracks ?? this.tracks,
        authorId: authorId ?? this.authorId,
        author: author ?? this.author,
        artUri: artUri ?? this.artUri,
      );
}

List<PlaylistClass> listOfPlaylists = [firstPlaylist];

PlaylistClass firstPlaylist = PlaylistClass(
  id: "PL100000000",
  title: "First playlist",
  tracksId: ["TR100000001", "TR100000002", "TR100000003"],
  authorId: "MM100000001",
  artUri:
      "https://phonoteka.org/uploads/posts/2022-01/1643591095_62-phonoteka-org-p-fon-zvezdnoe-nebo-svetloe-68.jpg",
);
