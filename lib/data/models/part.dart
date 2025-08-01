import 'exercise.dart';

class Part {
  final String name;
  final List<Exercise> exercises;

  Part({required this.name, required this.exercises});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      name: json['name'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  Part copyWith({
    String? name,
    List<Exercise>? exercises,
  }) {
    return Part(
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }
}
