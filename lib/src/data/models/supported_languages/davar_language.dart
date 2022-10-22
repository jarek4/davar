class DavarLanguage {
  const DavarLanguage({required this.name, required this.englishName, required this.shortcut});

  final String name;
  final String englishName;
  final String shortcut;

  @override
  bool operator == (Object other) => other is DavarLanguage && name == other.name && shortcut == other.shortcut && englishName == other.englishName;

  @override
  int get hashCode => Object.hash(name, englishName, shortcut);


}