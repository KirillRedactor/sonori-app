import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileClass {
  String id;
  String name;
  String? avatarUri;

  ProfileClass({
    required this.id,
    required this.name,
    this.avatarUri,
  });

  static ProfileClass get empty => ProfileClass(
        id: "US000000000",
        name: "Unknown user",
      );

  ProfileClass copyWith({
    String? id,
    String? name,
    String? avatarUri,
  }) =>
      ProfileClass(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarUri: avatarUri ?? this.avatarUri,
      );

  toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "avatarUri": avatarUri,
    };
  }

  static ProfileClass fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return ProfileClass(
      id: document.id,
      name: data["name"],
      avatarUri: data["avatarUri"],
    );
  }

  int getRawId() {
    return id.split("US")[1] as int;
  }
}

List<ProfileClass> listOfUsers = [
  firstUserClass,
  JimYosef,
  testUserClass,
  localUser,
];

ProfileClass firstUserClass = ProfileClass(
  id: "US100000001",
  name: "Test musician",
);

ProfileClass testUserClass = ProfileClass(
  id: "US000000000",
  name: "Test user",
);

ProfileClass JimYosef = ProfileClass(
  id: "US120000000",
  name: "Jim Yosef",
  avatarUri:
      "https://avatars.yandex.net/get-music-content/2386207/3e93ea4b.a.12248515-1/m1000x1000?webp=false",
);

ProfileClass UnlikePluto =
    ProfileClass(id: "US120000001", name: "Unlike Pluto");

ProfileClass localUser = ProfileClass(id: "US123456789", name: "Kirill");
