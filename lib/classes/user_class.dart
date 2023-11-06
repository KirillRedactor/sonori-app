class UserClass {
  String id;
  String name;
  String? username;
  String? avatarUri;
  List<String>? listOfTracksIds;

  UserClass({
    required this.id,
    required this.name,
    this.username,
    this.avatarUri,
    this.listOfTracksIds,
  });

  static UserClass get empty => UserClass(
        id: "US000000000",
        name: "Unknown user",
      );

  UserClass copyWith({
    String? id,
    String? name,
    String? username,
    List<String>? listOfTracksIds,
  }) =>
      UserClass(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        listOfTracksIds: listOfTracksIds ?? this.listOfTracksIds,
      );

  int getRawId() {
    return id.split("US")[1] as int;
  }
}

List<UserClass> listOfUsers = [
  firstUserClass,
  JimYosef,
  testUserClass,
  localUser,
];

UserClass firstUserClass = UserClass(
  id: "US100000001",
  name: "Test musician",
);

UserClass testUserClass = UserClass(
  id: "US000000000",
  name: "Test user",
  username: "Test username",
);

UserClass JimYosef = UserClass(
  id: "US120000000",
  name: "Jim Yosef",
  avatarUri:
      "https://avatars.yandex.net/get-music-content/2386207/3e93ea4b.a.12248515-1/m1000x1000?webp=false",
);

UserClass UnlikePluto = UserClass(id: "US120000001", name: "Unlike Pluto");

UserClass localUser = UserClass(id: "US123456789", name: "Kirill");
