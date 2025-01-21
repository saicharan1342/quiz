import 'package:quiz/models/question_model.dart';

class Quiz {
  final int id;
  final String title;
  final String description;
  final String topic;
  final int duration; // Duration in minutes
  final double negativeMarks;
  final double correctAnswerMarks;
  final bool shuffle;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.duration,
    required this.negativeMarks,
    required this.correctAnswerMarks,
    required this.shuffle,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'] ?? 'Untitled Quiz',
      description: json['description'] ?? '',
      topic: json['topic'] ?? 'General',
      duration: json['duration'] ?? 15,
      negativeMarks: double.parse(json['negative_marks'] ?? '0'),
      correctAnswerMarks: double.parse(json['correct_answer_marks'] ?? '0'),
      shuffle: json['shuffle'] ?? false,
      questions: (json['questions'] as List<dynamic>)
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }
}
