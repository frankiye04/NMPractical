import 'package:flutter/material.dart';

void main() {
  runApp(QuickLearnApp());
}

class QuickLearnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickLearn Quiz',
      home: QuizPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> questions = [
    Question(
      questionText: 'What is the capital of France?',
      options: ['Berlin', 'London', 'Paris', 'Madrid'],
      correctIndex: 2,
    ),
    Question(
      questionText: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Who wrote "Romeo and Juliet"?',
      options: ['Shakespeare', 'Hemingway', 'Tolstoy', 'Twain'],
      correctIndex: 0,
    ),
  ];

  int currentQuestion = 0;
  int score = 0;
  bool quizCompleted = false;

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestion].correctIndex) {
      score++;
    }

    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        quizCompleted = true;
      }
    });
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QuickLearn Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: quizCompleted
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Quiz Completed!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Your Score: $score/${questions.length}',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: restartQuiz,
                      child: Text('Restart Quiz'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${currentQuestion + 1}/${questions.length}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  Text(
                    questions[currentQuestion].questionText,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ...questions[currentQuestion].options.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            onPressed: () => answerQuestion(entry.key),
                            child: Text(entry.value),
                          ),
                        ),
                      ),
                ],
              ),
      ),
    );
  }
}
