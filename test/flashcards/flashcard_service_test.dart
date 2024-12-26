import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rivezni/core/services/flashcard_service.dart';
import 'package:rivezni/data/models/flashcard.dart';

import '../subjects/subject_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])

void main() {
  late FlashcardService underTest;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    underTest = FlashcardService(client: mockClient);
  });

  test('Fetch Flashcards successfully', () async {
    const mockSubjectId = 1;

    when(mockClient.get(Uri.parse('http://10.0.2.2:3000/flashcards/$mockSubjectId'),headers: null,))
        .thenAnswer((_) async => http.Response(
            '[{"id": 1, "question": "Why me?", "answer": "Because life is like this.", "subjectId": 1 }]',
            200));
    
    

    expect(await underTest.fetchFlashcards(mockSubjectId), isA<List<Flashcard>>());
  });

  test('Add Flashcard successfully', () async {
    const mockFlashcard = {
      'id': 1,
      "question": "Why me?",
      "answer": "Because life is like this.",
      'subjectId': 1,
    };

    when(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/flashcard'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mockFlashcard),
    )).thenAnswer((_) async => http.Response('{"success": true}', 200));

    await underTest.addFlashcard(mockFlashcard);

    verify(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/flashcard'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mockFlashcard),
    )).called(1);
  });

  test('Add Flashcard fails due to missing fields', () async {
    const mockFlashcard = {
      'id': 1,
      "question": "Why me?",
      'subjectId': '1',
    };

    when(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/flashcard'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mockFlashcard),
    )).thenAnswer((_) async => http.Response('{"success": true}', 200));

    await underTest.addFlashcard(mockFlashcard);

    verify(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/flashcard'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mockFlashcard),
    )).called(1);
  });
}
