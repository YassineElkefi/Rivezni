import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final Color color;

  const Subject({
    required this.id,
    required this.name,
    this.color = Colors.orange,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color
    };
  }

  static Subject fromJson(Map<String, dynamic> map) {
    return Subject(
      id: map["id"],
      name: map['name'] ?? '',
      color: map['color'] ?? Colors.blue
    );
  }
}
