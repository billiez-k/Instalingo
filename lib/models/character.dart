class AiCharacter {
  final String handle;
  final String name;
  final String nationality;
  final String visualStyle;
  final String bio;
  final String avatarColor;
  final List<String> primaryDomains;
  final List<String> secondaryDomains;
  final String tone;
  final List<String> typicalSettings;
  final List<String> colorPalette;

  const AiCharacter({
    required this.handle,
    required this.name,
    required this.nationality,
    required this.visualStyle,
    required this.bio,
    required this.avatarColor,
    required this.primaryDomains,
    required this.secondaryDomains,
    required this.tone,
    required this.typicalSettings,
    required this.colorPalette,
  });
}
