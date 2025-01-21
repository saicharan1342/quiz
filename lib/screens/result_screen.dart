import 'package:flutter/material.dart';
import 'package:quiz/screens/readingmaterial.dart';
import '../models/question_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int score = args['score'] as int;
    final List<Question> questions = args['questions'] as List<Question>;
    final Map<int, int> userAnswers = args['userAnswers'] as Map<int, int>;

    // Determine the badge based on score
    String badgeImage = 'assets/bronze-badge.png'; // Default badge
    if (score >= 30) {
      badgeImage = 'assets/gold-badge.png'; // Gold badge for score >= 30
    } else if (score >= 20) {
      badgeImage = 'assets/silver-badge.png'; // Silver badge for score >= 20
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Results"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score and Badge Display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligning score to the left and badge to the right
                children: [
                  // Score Display
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Final Score",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$score/${questions.length * 4}", // Showing score out of maximum points
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                  ),
                  // Badge Display
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(badgeImage, height: 80), // Show the badge image
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Attempted Questions
            Text(
              "Attempted: ${userAnswers.length} / ${questions.length}",
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            const Text(
              "Review Your Answers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final userAnswer = userAnswers[question.id];
                  final correctAnswer = question.options.firstWhere((option) => option.isCorrect).id;
                  final isCorrect = userAnswer == correctAnswer;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      tileColor: isCorrect ? Colors.green[50] : Colors.red[50],
                      title: Text(
                        "Q${index + 1}: ${question.description}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            "Your Answer: ${question.options.firstWhere((option) => option.id == userAnswer, orElse: () => Option(id: -1, description: 'No Answer', isCorrect: false)).description}",
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Correct Answer: ${question.options.firstWhere((option) => option.isCorrect).description}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          if (!isCorrect && question.readingMaterial != null)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReadingMaterialScreen(
                                        contentSections: question.readingMaterial?.contentSections ?? [],
                                        keywords: question.readingMaterial?.keywords != null
                                            ? (question.readingMaterial!.keywords!.map((e) => e.toString()).toList())
                                            : [],
                                        practiceContent: question.readingMaterial?.practiceMaterial?.content ?? [],
                                        practiceKeywords: question.readingMaterial?.practiceMaterial?.keywords ?? [],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.menu_book, color: Colors.teal),
                                label: const Text("Review Material", style: TextStyle(color: Colors.teal)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Go Home", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
