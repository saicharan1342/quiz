import 'package:flutter/material.dart';

class ReadingMaterialScreen extends StatelessWidget {
  final List<String> contentSections;
  final List<String>? keywords;
  final List<String>? practiceContent;
  final List<String>? practiceKeywords;

  const ReadingMaterialScreen({
    Key? key,
    required this.contentSections,
    this.keywords,
    this.practiceContent,
    this.practiceKeywords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if all provided data is empty
    final bool isEmpty = contentSections.every((section) => section.trim().isEmpty) &&
        (keywords == null || keywords!.every((keyword) => keyword.trim().isEmpty)) &&
        (practiceContent == null || practiceContent!.every((content) => content.trim().isEmpty)) &&
        (practiceKeywords == null || practiceKeywords!.every((keyword) => keyword.trim().isEmpty));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading Material"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEmpty
            ? const Center(
          child: Text(
            "No reading material available.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView(
          children: [
            // Content Sections
            if (contentSections.any((section) => section.trim().isNotEmpty)) ...[
              _buildSectionHeader("Content Sections"),
              ...contentSections
                  .where((section) => section.trim().isNotEmpty)
                  .map((section) => _buildCard(section)),
            ],

            // Keywords
            if (keywords != null && keywords!.any((keyword) => keyword.trim().isNotEmpty)) ...[
              _buildSectionHeader("Keywords"),
              _buildKeywordChips(
                  keywords!.where((keyword) => keyword.trim().isNotEmpty).toList()),
            ],

            // Practice Content
            if (practiceContent != null &&
                practiceContent!.any((content) => content.trim().isNotEmpty)) ...[
              _buildSectionHeader("Practice Content"),
              ...practiceContent!
                  .where((content) => content.trim().isNotEmpty)
                  .map((practice) => _buildCard(practice)),
            ],

            // Practice Keywords
            if (practiceKeywords != null &&
                practiceKeywords!.any((keyword) => keyword.trim().isNotEmpty)) ...[
              _buildSectionHeader("Practice Answers"),
              _buildPracticeKeywords(
                  practiceKeywords!.where((keyword) => keyword.trim().isNotEmpty).toList()),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  /// Builds a card to display content sections or practice material
  Widget _buildCard(String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _stripHtmlTags(content),
          style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
        ),
      ),
    );
  }

  /// Builds keyword chips
  Widget _buildKeywordChips(List<String> keywords) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: keywords
          .map(
            (keyword) => Chip(
          label: Text(keyword),
          backgroundColor: Colors.deepPurple[50],
        ),
      )
          .toList(),
    );
  }

  /// Builds practice keywords in a single line
  Widget _buildPracticeKeywords(List<String> practiceKeywords) {
    final String keywordString = practiceKeywords.join(", ");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        keywordString,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Utility function to strip HTML tags from content
  String _stripHtmlTags(String htmlContent) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    return htmlContent.replaceAll(exp, '').trim();
  }
}
