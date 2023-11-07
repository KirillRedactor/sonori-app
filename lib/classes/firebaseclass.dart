import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
import 'package:musicplayer_app/classes/playlist_class.dart';

class FirabaseClass {
  late FirebaseFirestore db;

  FirabaseClass() {
    db = FirebaseFirestore.instance;
  }

  Future<PlaylistClass> getPlaylist(String id) async {
    if (!id.contains("PL")) return PlaylistClass.empty;
    for (PlaylistClass playlist in listOfPlaylists) {
      if (playlist.id == id) {
        return playlist;
      }
    }
    return PlaylistClass.empty;
  }

  Future<String> getUserName(String id) async {
    if (!id.contains("US")) return "Error id";
    for (UserClass user in listOfUsers) {
      if (user.id == id) {
        return user.name;
      }
    }
    return "Unknown author";
  }

  Future<UserClass> getUser(String id) async {
    if (!id.contains("US")) return UserClass.empty;
    for (UserClass user in listOfUsers) {
      if (user.id == id) {
        return user;
      }
    }
    return UserClass.empty;
  }

  UserClass getLocalUser() {
    return localUser;
  }

  Future<void> updateMusicItem(MusicItem musicItem) async {
    db.collection("tracks").doc(musicItem.id).set(musicItem.toJson());
  }

  /*Future<MusicItem> getMusicItem(String id) async {
    final snapshot = await db.collection("tracks").doc(id).get();
    MusicItem mi = MusicItem.fromJson(snapshot);
    return mi;
  }*/

  Future<List<MusicItem>> getListOfMusicItems(List<String> list) async {
    final snapshot = await db
        .collection("tracks")
        .where("id", whereIn: list)
        .get()
        .then((value) => value.docs);
    final lst = snapshot.map((e) => MusicItem.fromJson(e)).toList();
    return lst;
  }
}
