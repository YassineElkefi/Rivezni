import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rivezni/core/services/subject_service.dart';
import 'package:rivezni/data/models/subject.dart';
import 'subject_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])

void main() {
  late SubjectService underTest;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    underTest = SubjectService(client: mockClient);
  });

  test('Fetch Subjects successfully', () async {
    const mockUserId = "1";

    when(mockClient.get(Uri.parse('http://10.0.2.2:3000/subjects/$mockUserId'),headers: null,))
        .thenAnswer((_) async => http.Response(
            '[{"id": 1, "name": "Ionic", "color": "#FF2196F3", "userId": "1" }]',
            200));
    
    

    expect(await underTest.fetchSubjects(mockUserId), isA<List<Subject>>());
  });

  test('Add Subject successfully', () async {
    const mockSubject = {
      'id': 1,
      'name': 'Physics',
      'color': '#FF5733',
      'userId': '1',
    };

    when(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/subject'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mockSubject),
    )).thenAnswer((_) async => http.Response('{"success": true}', 200));

    await underTest.addSubject(mockSubject);

    verify(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/subject'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mockSubject),
    )).called(1);
  });

  test('Add Subject fails due to missing fields', () async {
    const incompleteSubject = {
      'id': 1,
      'color': '#FF5733',
      'userId': '1',
    };

    when(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/subject'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incompleteSubject),
    )).thenAnswer((_) async => http.Response('{"error": "Missing fields"}', 400));

    expect(
      () async => await underTest.addSubject(incompleteSubject),
      throwsA(isA<Exception>()),
    );

    verify(mockClient.post(
      Uri.parse('http://10.0.2.2:3000/subject'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incompleteSubject),
    )).called(1);
  });
}
