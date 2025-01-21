import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/quiz.dart';

Future<Quiz> fetchQuiz() async {
  final url = Uri.parse('https://api.jsonserve.com/Uw5CrX'); // Replace with your API endpoint
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Quiz.fromJson(data);
  } else {
    throw Exception('Failed to load quiz');
  }
}
