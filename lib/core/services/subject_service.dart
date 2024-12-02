import 'dart:convert';
import 'package:http/http.dart' as httpClient;
import 'package:http/http.dart';
import 'package:rivezni/data/models/subject.dart';

class SubjectService {
  static const String baseUrl = "http://10.0.2.2:3000/";

  SubjectService();

  Future<List<Subject>> fetchSubjects() async {
    const String path = '${baseUrl}subjects';

    final response = await httpClient.get(Uri.parse(path));

    if (response.statusCode != 200) {
      throw Exception('Failed to load subjects: ${response.body}');
    }

    final List<dynamic> responseBody = jsonDecode(response.body);

    return responseBody.map((json) => Subject.fromJson(json)).toList();
  }

  Future<void> addSubject(Map<String, dynamic> subject) async {
    const String path = '${baseUrl}subject';
      try{
      await httpClient.post(
        Uri.parse(path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(subject),
      );

    }catch (e){
        throw Exception('Failed to add subject: $e');
    }
  }

  Future<Response> deleteSubject(int id) async {
    String path = '${baseUrl}subject/$id';
    try{
      final response = await httpClient.delete(
        Uri.parse(path),
        headers: {'Content-Type': 'application/json'},
        
      );
      return response;
    }catch (e){
        throw Exception('Failed to delete subject: $e');
    }
  }
  
}
