import 'package:flutter/material.dart';
import 'package:rivezni/core/services/flashcard_service.dart';
import 'package:rivezni/data/models/flashcard.dart';
import 'package:rivezni/data/models/subject.dart';

class FlashcardProvider with ChangeNotifier {
  final flashcardService = FlashcardService();
  bool loading = true;
  List flashcards = [];
  Subject? subject;

  Future<void> getFlashcards(Subject? subject) async {
    if (subject == null) return;
    this.subject = subject;

    await Future.delayed(Duration(seconds: 1));

    try {
      flashcards = await flashcardService.fetchFlashcards(subject.id!);
      loading = false;
      notifyListeners();

    } catch (e) {
      throw Exception("Fetch failed: $e");
    }
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final flashcardJson = flashcard.toJson();
    try {
      await flashcardService.addFlashcard(flashcardJson);
      await getFlashcards(subject);
    } catch (e) {
      print("Error adding flashcard: $e");
      throw Exception("Add failed: $e");
    }
  }

  Future<void> deleteFlashcard(int id) async {
    try {
      final response = await flashcardService.deleteFlashcard(id);
      if (response.statusCode == 200 || response.statusCode == 204) {
        await getFlashcards(subject);
      } else {
        throw Exception("Failed to delete flashcard: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error deleting flashcard: $e");
      rethrow;
    }
  }
}
