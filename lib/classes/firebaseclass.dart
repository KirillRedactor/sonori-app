import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
import 'package:musicplayer_app/classes/playlist_class.dart';

class FirabaseClass {
  FirabaseClass();

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

  Future<MusicItem> getMusicItem(String id) async {
    if (!id.contains("TR")) return MusicItem.empty;
    for (MusicItem musicItem in listOfMusicItems) {
      if (musicItem.id == id) {
        return musicItem;
      }
    }
    return MusicItem.empty;
  }

  Future<List<MusicItem>> getListOfMusicItems(List<String> list) async {
    Map<int, MusicItem> map = {};
    for (MusicItem musicItem in listOfMusicItems) {
      int id = list.indexOf(musicItem.id);
      if (id != -1) {
        map[id] = musicItem;
      }
    }
    List<MusicItem> resList = [];
    for (int i = 0; i < list.length; i++) {
      resList.add(map[i]!);
    }
    return resList;
  }
}
