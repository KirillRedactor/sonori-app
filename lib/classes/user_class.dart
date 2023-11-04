class UserClass {
  String id;
  String name;
  String? username;

  UserClass({
    required this.id,
    required this.name,
    this.username,
  });

  static UserClass get empty => UserClass(
        id: "MM000000000",
        name: "Unknown user",
      );

  UserClass copyWith({
    String? id,
    String? name,
    String? username,
  }) =>
      UserClass(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
      );
}

List<UserClass> listOfUsers = [firstUserClass, testUserClass];

UserClass firstUserClass = UserClass(
  id: "US100000001",
  name: "Test musician",
);

UserClass testUserClass = UserClass(
  id: "US000000000",
  name: "Test user",
  username: "Test username",
);
