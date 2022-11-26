class DavarLanguage {
  const DavarLanguage({required name, required englishName, required shortcut})
      : _name = name,
        _englishName = englishName,
        _shortcut = shortcut;

  final String _name, _englishName, _shortcut;

  String get name => _name;

  String get englishName => _englishName;

  String get shortcut => _shortcut;

  @override
  bool operator ==(Object other) =>
      other is DavarLanguage &&
      _name == other._name &&
      _shortcut == other._shortcut &&
      _englishName == other._englishName;

  @override
  int get hashCode => Object.hash(_name, _englishName, _shortcut);
}
