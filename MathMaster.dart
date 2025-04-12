import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MathMasterApp());
}

class MathMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMaster',
      home: MathPracticePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MathPracticePage extends StatefulWidget {
  @override
  _MathPracticePageState createState() => _MathPracticePageState();
}

class _MathPracticePageState extends State<MathPracticePage> {
  int num1 = 0;
  int num2 = 0;
  String operator = '+';
  final TextEditingController controller = TextEditingController();
  String feedback = '';
  int score = 0;
  int total = 0;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    setState(() {
      num1 = random.nextInt(20);
      num2 = random.nextInt(20);
      operator = ['+', '-', '*'][random.nextInt(3)];
      controller.clear();
      feedback = '';
    });
  }

  int calculateAnswer() {
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      default:
        return 0;
    }
  }

  void checkAnswer() {
    final userAnswer = int.tryParse(controller.text);
    final correctAnswer = calculateAnswer();

    setState(() {
      total++;
      if (userAnswer == correctAnswer) {
        score++;
        feedback = '✅ Correct!';
      } else {
        feedback = '❌ Wrong. Answer: $correctAnswer';
      }
    });
  }

  void restartQuiz() {
    setState(() {
      score = 0;
      total = 0;
      feedback = '';
      generateQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MathMaster')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $score / $total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Text(
              '$num1 $operator $num2 = ?',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Answer',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              child: Text('Check'),
            ),
            SizedBox(height: 10),
            Text(
              feedback,
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateQuestion,
              child: Text('Next Question'),
            ),
            TextButton(
              onPressed: restartQuiz,
              child: Text('Restart'),
            )
          ],
        ),
      ),
    );
  }
}
