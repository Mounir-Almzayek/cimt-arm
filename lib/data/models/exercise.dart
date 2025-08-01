import 'package:uuid/uuid.dart';
import 'media_item.dart';

var _uuid = Uuid();

class Exercise {
  final String id;
  String name;
  String details;
  List<String> requirements;
  String? warnings;
  Duration executionTime;
  Duration restTime;
  List<MediaItem> media;
  List<DateTime> completionTimestamps;

  Exercise({
    String? id,
    required this.name,
    required this.details,
    required this.requirements,
    this.warnings,
    required this.executionTime,
    required this.restTime,
    required this.media,
    List<DateTime>? initialCompletionTimestamps,
  })  : this.id = id ?? _uuid.v4(),
        completionTimestamps = initialCompletionTimestamps ?? [];

  bool get hasBeenCompleted => completionTimestamps.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'details': details,
        'requirements': requirements,
        'warnings': warnings,
        'executionTime': executionTime.inSeconds,
        'restTime': restTime.inSeconds,
        'media': media.map((m) => m.toJson()).toList(),
        'completionTimestamps': completionTimestamps
            .map((timestamp) => timestamp.toIso8601String())
            .toList(),
      };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    List<DateTime> timestamps = [];
    if (json['completionTimestamps'] != null) {
      var timestampsJson = json['completionTimestamps'] as List;
      timestamps = timestampsJson
          .map((tsString) => DateTime.parse(tsString as String))
          .toList();
    }
    return Exercise(
      id: json['id'] as String?,
      name: json['name'] as String,
      details: json['details'] as String,
      requirements: List<String>.from(json['requirements'] as List),
      warnings: json['warnings'] as String?,
      executionTime: Duration(seconds: json['executionTime'] as int),
      restTime: Duration(seconds: json['restTime'] as int),
      media: (json['media'] as List)
          .map((m) => MediaItem.fromJson(m as Map<String, dynamic>))
          .toList(),
      initialCompletionTimestamps: timestamps,
    );
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? details,
    List<String>? requirements,
    String? warnings,
    Duration? executionTime,
    Duration? restTime,
    List<MediaItem>? media,
    List<DateTime>? completionTimestamps,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
      requirements: requirements ?? this.requirements,
      warnings: warnings ?? this.warnings,
      executionTime: executionTime ?? this.executionTime,
      restTime: restTime ?? this.restTime,
      media: media ?? this.media,
      initialCompletionTimestamps:
          completionTimestamps ?? this.completionTimestamps,
    );
  }

  void markAsCompletedNow() {
    completionTimestamps.add(DateTime.now());
  }
}