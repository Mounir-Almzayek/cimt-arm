import 'package:cimt/data/models/stage.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class WorkoutSection {
  final String id;
  String name;
  String? imageUrl;
  List<Stage> stages;

  WorkoutSection({
    String? id,
    required this.name,
    this.imageUrl,
    required this.stages,
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'stages': stages.map((s) => s.toJson()).toList(),
      };

  factory WorkoutSection.fromJson(Map<String, dynamic> json) {
    var stagesJson = json['stages'] as List;
    List<Stage> stagesList = stagesJson
        .map((s) => Stage.fromJson(s as Map<String, dynamic>))
        .toList();

    return WorkoutSection(
      id: json['id'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      stages: stagesList,
    );
  }

  WorkoutSection copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<Stage>? stages,
  }) {
    return WorkoutSection(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      stages: stages ??
          List<Stage>.from(this.stages.map((stage) => stage.copyWith())),
    );
  }

  bool get isCompleted {
    if (stages.isEmpty) {
      return false;
    }
    return stages.every((stage) => stage.isCompleted);
  }
}
