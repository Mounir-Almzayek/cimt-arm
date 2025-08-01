import 'package:cimt/data/models/part.dart';

class Session {
  final String name;
  final List<Part> parts;

  Session({required this.name, required this.parts});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      name: json['name'] as String,
      parts: (json['parts'] as List)
          .map((p) => Part.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'parts': parts.map((p) => p.toJson()).toList(),
      };

  Session copyWith({
    String? name,
    List<Part>? parts,
  }) {
    return Session(
      name: name ?? this.name,
      parts: parts ?? this.parts,
    );
  }
}
