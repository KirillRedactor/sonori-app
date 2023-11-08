import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicplayer_app/classes/profile_class.dart';

class UserClass {
  String id;
  String email;
  String password;
  String name;
  String? avatarUri;

  UserClass({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    this.avatarUri,
  });

  toJson() {
    return <String, dynamic>{
      "id": id,
      "email": email,
      "password": password,
      "name": name,
      "avatarUri": avatarUri,
    };
  }

  toProfileClass() {
    return ProfileClass(id: id, name: name, avatarUri: avatarUri);
  }

  static UserClass fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserClass(
      id: document.id,
      email: data["email"],
      password: data["password"],
      name: data["name"],
      avatarUri: data["avatarUri"],
    );
  }
}
