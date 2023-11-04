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
    Future.delayed(const Duration(seconds: 10));
    for (UserClass user in listOfUsers) {
      if (user.id == id) {
        return user;
      }
    }
    return UserClass.empty;
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
}
