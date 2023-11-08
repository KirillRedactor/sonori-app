import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/profile_class.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
import 'package:musicplayer_app/classes/playlist_class.dart';
import 'package:musicplayer_app/classes/user_class.dart';

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
    for (ProfileClass user in listOfUsers) {
      if (user.id == id) {
        return user.name;
      }
    }
    return "Unknown author";
  }

  Future<void> createUser(
      UserClass userClass, ProfileClass profileClass) async {
    db.collection("users").doc(userClass.id).set(userClass.toJson());
    db.collection("profiles").doc(profileClass.id).set(profileClass.toJson());
  }

  Future<ProfileClass> getProfile(String id) async {
    final snapshot =
        await db.collection("profiles").where("id", isEqualTo: id).get();
    return ProfileClass.fromDocument(snapshot.docs.single);
  }

  Future<UserClass> getUser(String id) async {
    final snapshot =
        await db.collection("users").where("id", isEqualTo: id).get();
    return UserClass.fromDocument(snapshot.docs.single);
  }

  Future<UserClass> getUserFromEmailAndPassword(
      String email, String password) async {
    final snapshot = await db
        .collection("users")
        .where("email", isEqualTo: email)
        .where(
          "password",
          isEqualTo: password,
        )
        .get();
    return UserClass.fromDocument(snapshot.docs.single);
  }

  ProfileClass getLocalUser() {
    return settings.user?.toProfileClass();
  }

  Future<void> updateMusicItem(MusicItem musicItem) async {
    db.collection("tracks").doc(musicItem.id).set(musicItem.toJson());
  }

  Future<String> getIdForUser() async {
    final id =
        await db.collection("users").count().get().then((value) => value.count);
    db
        .collection("users")
        .doc("US${100000001 + id}")
        .set({"id": "US${100000001 + id}"});
    return "US${100000001 + id}";
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
