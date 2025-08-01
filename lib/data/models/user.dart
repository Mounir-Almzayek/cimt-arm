import 'package:cimt/data/models/workout_section.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class User {
  final String id;
  String name;
  List<WorkoutSection> sections;
  final int? ratingStars;
  final String? ratingFeedback;

  User({
    String? id,
    required this.name,
    required this.sections,
    this.ratingStars,
    this.ratingFeedback,
  })  : id = id ?? _uuid.v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sections': sections.map((section) => section.toJson()).toList(),
    'ratingStars': ratingStars,
    'ratingFeedback': ratingFeedback,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      sections: (json['sections'] as List<dynamic>)
          .map((sectionJson) => WorkoutSection.fromJson(sectionJson as Map<String, dynamic>))
          .toList(),
      ratingStars: json['ratingStars'] as int?,
      ratingFeedback: json['ratingFeedback'] as String?,
    );
  }

  User copyWith({
    String? userId,
    String? name,
    List<WorkoutSection>? sections,
    int? ratingStars,
    String? ratingFeedback,
    bool allowNullRatingStars = false,
    bool allowNullRatingFeedback = false,
  }) {
    return User(
      id: userId ?? this.id,
      name: name ?? this.name,
      sections: sections ?? List<WorkoutSection>.from(this.sections.map((section) => section.copyWith())),
      ratingStars: allowNullRatingStars ? ratingStars : (ratingStars ?? this.ratingStars),
      ratingFeedback: allowNullRatingFeedback ? ratingFeedback : (ratingFeedback ?? this.ratingFeedback),
    );
  }

  bool get isEntireProgramCompleted {
    if (sections.isEmpty) {
      return false;
    }
    return sections.every((section) => section.isCompleted);
  }
}