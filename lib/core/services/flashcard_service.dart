import 'dart:convert';
import 'package:http/http.dart' as httpClient;
import 'package:http/http.dart';
import 'package:rivezni/data/models/flashcard.dart';

class FlashcardService {
  static const String baseUrl = "http://10.0.2.2:3000/";

  FlashcardService();

  Future<List<Flashcard>> fetchFlashcards(int subjectId) async {
    String path = '${baseUrl}flashcards/$subjectId';

    final response = await httpClient.get(Uri.parse(path));

    if (response.statusCode != 200) {
      throw Exception('Failed to load flashcards: ${response.body}');
    }

    final List<dynamic> responseBody = jsonDecode(response.body);

    return responseBody.map((json) => Flashcard.fromJson(json)).toList();
  }

  Future<void> addFlashcard(Map<String, dynamic> flashcard) async {
    const String path = '${baseUrl}flashcard';
      try{
      await httpClient.post(
        Uri.parse(path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(flashcard),
      );

    }catch (e){
        throw Exception('Failed to add flashcard: $e');
    }
  }

  Future<Response> deleteFlashcard(int id) async {
    String path = '${baseUrl}flashcard/$id';
    try{
      final response = await httpClient.delete(
        Uri.parse(path),
        headers: {'Content-Type': 'application/json'},
        
      );
      return response;
    }catch (e){
        throw Exception('Failed to delete flashcard: $e');
    }
  }
  
}
