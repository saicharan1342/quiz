import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../actions/quiz_actions.dart'; // Ensure fetchQuiz is defined in this file

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  Map<int, int> userAnswers = {}; // Map to store user-selected answers
  int currentQuestionIndex = 0;
  int score = 0;
  int remainingTime = 15 * 60; // 15 minutes in seconds
  late Timer _timer;

  bool shuffleQuestions = false; // Shuffle questions based on quiz data

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  /// Loads questions and handles shuffling.
  Future<void> _loadQuestions() async {
    try {
      final fetchedQuiz = await fetchQuiz(); // Fetch the quiz data
      setState(() {
        shuffleQuestions = fetchedQuiz.shuffle;
        questions = fetchedQuiz.questions;

        if (shuffleQuestions) {
          questions.shuffle();
          for (var question in questions) {
            question.options.shuffle();
          }
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $error')),
      );
    }
  }

  /// Starts the countdown timer.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        _endQuiz();
      }
    });
  }

  /// Ends the quiz and navigates to the result screen.
  void _endQuiz() {
    _timer.cancel(); // Stop the timer
    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: {
        'score': score,
        'questions': questions,
        'userAnswers': userAnswers,
      },
    );
  }

  /// Moves to the next question.
  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _endQuiz();
    }
  }

  /// Moves to the previous question.
  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  /// Submits the user's answer and calculates the score.
  void _submitAnswer(int optionId) {
    final currentQuestion = questions[currentQuestionIndex];
    final selectedOption =
    currentQuestion.options.firstWhere((option) => option.id == optionId);

    if (userAnswers[currentQuestion.id] != optionId) {
      if (selectedOption.isCorrect) {
        score += 4; // Correct answer points
      } else {
        // Adjust score when changing answers
        if (userAnswers[currentQuestion.id] != null) {
          score -= 4;
        }
        score -= 1; // Incorrect answer penalty
      }
    }

    userAnswers[currentQuestion.id] = optionId;
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel(); // Clean up the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.teal),
              SizedBox(height: 20),
              Text(
                "Loading Questions...",
                style: TextStyle(fontSize: 18, color: Colors.teal),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text("Time Left: $minutes:$seconds"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header with full width
            _buildQuestionHeader(currentQuestionIndex, currentQuestion.description),
            const SizedBox(height: 20),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  final option = currentQuestion.options[index];
                  final isSelected = userAnswers[currentQuestion.id] == option.id;

                  return GestureDetector(
                    onTap: () => _submitAnswer(option.id),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: isSelected ? Colors.teal[100] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          option.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the question header with full width
  Widget _buildQuestionHeader(int index, String description) {
    return Center(
      child: Container(
        width: double.infinity, // Makes the question take up the full width
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${index + 1}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify, // Ensures the text stretches across the width
            ),
          ],
        ),
      ),
    );
  }

  /// Builds navigation buttons with proper styling
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentQuestionIndex > 0)
          ElevatedButton.icon(
            onPressed: _previousQuestion,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            label: const Text("Previous", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ElevatedButton.icon(
          onPressed: _nextQuestion,
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          label: const Text("Next", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}
