import 'package:uuid/uuid.dart';
import 'difficulty_level.dart';
import 'session.dart';

var _uuid = Uuid();

class Stage {
  final String id;
  DifficultyLevel difficulty;
  List<Session> sessions;

  Stage({
    String? id,
    required this.difficulty,
    required this.sessions,
  }) : id = id ?? _uuid.v4();

  bool get isCompleted {
    if (sessions.isEmpty) {
      return false;
    }
    return sessions.every((session) => session.parts.every((part) =>
        part.exercises.every((exercise) => exercise.hasBeenCompleted)));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'difficulty': difficulty.toJson(),
        'sessions': sessions.map((s) => s.toJson()).toList(),
      };

  factory Stage.fromJson(Map<String, dynamic> json) {
    var sessionsJson = json['sessions'] as List?;
    List<Session> sessionsList = sessionsJson
            ?.map((s) => Session.fromJson(s as Map<String, dynamic>))
            .toList() ??
        [];

    return Stage(
      id: json['id'] as String?,
      difficulty: DifficultyLevel.fromJson(json['difficulty'] as String),
      sessions: sessionsList,
    );
  }

  Stage copyWith({
    String? id,
    DifficultyLevel? difficulty,
    List<Session>? sessions,
  }) {
    return Stage(
      id: id ?? this.id,
      difficulty: difficulty ?? this.difficulty,
      sessions: sessions ?? this.sessions,
    );
  }
}
