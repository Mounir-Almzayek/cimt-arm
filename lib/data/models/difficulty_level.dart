enum DifficultyLevel {
  beginner,
  intermediate,
  advanced;

  static DifficultyLevel fromString(String value) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => DifficultyLevel.beginner,
    );
  }

  String toJson() => name;

  static DifficultyLevel fromJson(String json) => fromString(json);
}

extension DifficultyLevelArabic on DifficultyLevel {
  String get arabicName {
    switch (this) {
      case DifficultyLevel.beginner:
        return 'مبتدئ';
      case DifficultyLevel.intermediate:
        return 'متوسط';
      case DifficultyLevel.advanced:
        return 'متقدم';
    }
  }
}
