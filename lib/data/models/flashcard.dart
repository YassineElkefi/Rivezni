class Flashcard {
  final int? id;
  final String question;
  final String answer;
  final int subjectId;

  const Flashcard({
    this.id,
    required this.question,
    required this.answer,
    required this.subjectId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'question': question,
      'answer': answer,
      'subjectId': subjectId,
    };
  }

  static Flashcard fromJson(Map<String, dynamic> map) {
    return Flashcard(
      id: map["id"],
      question: map['question'] ?? '',
      answer: map['answer'],
      subjectId: map['subjectId'],
    );
  }
}
