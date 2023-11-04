class MusicianClass {
  String id;
  String name;

  MusicianClass({
    required this.id,
    required this.name,
  });

  MusicianClass copyWith({
    String? id,
    String? name,
  }) =>
      MusicianClass(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}

List<MusicianClass> listOfMusicians = [firstMusicianClass];

MusicianClass firstMusicianClass = MusicianClass(
  id: "MM100000001",
  name: "Test musician",
);
