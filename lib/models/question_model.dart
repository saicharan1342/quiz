import 'dart:convert';

class Question {
  final int id;
  final String description;
  final String topic;
  final List<Option> options;
  final ReadingMaterial? readingMaterial;

  Question({
    required this.id,
    required this.description,
    required this.topic,
    required this.options,
    this.readingMaterial,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      description: json['description'],
      topic: json['topic'] ?? '',
      options: (json['options'] as List<dynamic>)
          .map((item) => Option.fromJson(item))
          .toList(),
      readingMaterial: json['reading_material'] != null
          ? ReadingMaterial.fromJson(json['reading_material'])
          : null,
    );
  }
}

class Option {
  final int id;
  final String description;
  final bool isCorrect;

  Option({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      description: json['description'],
      isCorrect: json['is_correct'] ?? false,
    );
  }
}

class ReadingMaterial {
  final int id;
  final List<String>? keywords; // List of keywords
  final String? content; // Optional content
  final List<String>? contentSections; // List of content sections as HTML strings
  final PracticeMaterial? practiceMaterial; // Practice material if available

  ReadingMaterial({
    required this.id,
    this.keywords,
    this.content,
    this.contentSections,
    this.practiceMaterial,
  });

  factory ReadingMaterial.fromJson(Map<String, dynamic> json) {
    return ReadingMaterial(
      id: json['id'],
      keywords: (json['keywords'] != null
          ? (jsonDecode(json['keywords']) as List<dynamic>)
          .map((keyword) => keyword.toString())
          .toList()
          : null),
      content: json['content'],
      contentSections: (json['content_sections'] as List<dynamic>?)
          ?.map((section) => section.toString())
          .toList(),
      practiceMaterial: json['practice_material'] != null
          ? PracticeMaterial.fromJson(json['practice_material'])
          : null,
    );
  }
}

class PracticeMaterial {
  final List<String>? content; // List of content sections for practice
  final List<String>? keywords; // List of keywords for practice material

  PracticeMaterial({
    this.content,
    this.keywords,
  });

  factory PracticeMaterial.fromJson(Map<String, dynamic> json) {
    return PracticeMaterial(
      content: (json['content'] as List<dynamic>?)
          ?.map((section) => section.toString())
          .toList(),
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((keyword) => keyword.toString())
          .toList(),
    );
  }
}
