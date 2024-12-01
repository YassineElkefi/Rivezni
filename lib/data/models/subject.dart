class Subject {
  final int? id;
  final String name;
  final String color;
  final String userId;

  const Subject({
    this.id,
    required this.name,
    this.color = "#FF2196F3",
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'color': color,
      'userId': userId,
    };
  }

  static Subject fromJson(Map<String, dynamic> map) {
    return Subject(
      id: map["id"],
      name: map['name'] ?? '',
      color: map['color'],
      userId: map['userId'],
    );
  }
}
