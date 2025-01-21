import 'package:flutter/material.dart';
import 'package:quiz/screens/homescreen.dart';
import 'package:quiz/screens/instructions.dart';
import 'package:quiz/screens/quiz.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/instructions':(context)=>const InstructionsScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}
