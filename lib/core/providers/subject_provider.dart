import 'package:flutter/material.dart';
import 'package:rivezni/core/services/subject_service.dart';
import 'package:rivezni/data/models/subject.dart';

class SubjectProvider with ChangeNotifier {
  final subjectService = SubjectService();
  List subjects = [];

  Future<void> getSubjects() async {
    try{
    subjects = await subjectService.fetchSubjects();
    }catch (e) {
      throw Exception("fetch failed: $e");
    }

    notifyListeners();
  }

Future<void> addSubject(Subject subject) async {
  final subjectJson = subject.toJson();
  try {
    await subjectService.addSubject(subjectJson);
    await getSubjects();
  } catch (e) {
    print("Error adding subject: $e");
    throw Exception("Add failed: $e");
  }
}


}
