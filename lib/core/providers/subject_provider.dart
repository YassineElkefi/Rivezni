
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rivezni/core/services/subject_service.dart';
import 'package:rivezni/data/models/subject.dart';
import 'package:http/http.dart' as httpClient;

class SubjectProvider with ChangeNotifier {
  final subjectService = SubjectService(client: httpClient.Client());
  bool loading = true;
  List subjects = [];
  User? user;

  Future<void> getSubjects(User? user) async {
    if (user == null) return;
    this.user = user;

    await Future.delayed(Duration(seconds: 1));

    try {
      subjects = await subjectService.fetchSubjects(user.uid);
      loading = false;
      notifyListeners();

    } catch (e) {
      throw Exception("Fetch failed: $e");
    }
  }

  Future<void> addSubject(Subject subject) async {
    final subjectJson = subject.toJson();
    try {
      await subjectService.addSubject(subjectJson);
      await getSubjects(user);
    } catch (e) {
      print("Error adding subject: $e");
      throw Exception("Add failed: $e");
    }
  }

  Future<void> deleteSubject(int id) async {
    try {
      final response = await subjectService.deleteSubject(id);
      if (response.statusCode == 200 || response.statusCode == 204) {
        await getSubjects(user);
      } else {
        throw Exception("Failed to delete subject: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error deleting subject: $e");
      rethrow;
    }
  }
}
