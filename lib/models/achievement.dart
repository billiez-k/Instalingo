import 'package:instalingo/models/localized_text.dart';

class Achievement {
  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final String iconName;
  final int targetValue;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String tier;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.targetValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.tier = 'bronze',
  });

  double get progressRatio => (currentValue / targetValue).clamp(0.0, 1.0);

  Achievement copyWith({
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) =>
      Achievement(
        id: id,
        title: title,
        description: description,
        iconName: iconName,
        targetValue: targetValue,
        currentValue: currentValue ?? this.currentValue,
        isUnlocked: isUnlocked ?? this.isUnlocked,
        unlockedAt: unlockedAt ?? this.unlockedAt,
        tier: tier,
      );
}
