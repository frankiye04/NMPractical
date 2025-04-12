import 'package:flutter/material.dart';

void main() => runApp(WordGuessApp());

class WordGuessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordGuess',
      home: WordGuessGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordGuessGame extends StatefulWidget {
  @override
  _WordGuessGameState createState() => _WordGuessGameState();
}

class _WordGuessGameState extends State<WordGuessGame> {
  final List<String> wordList = ['FLUTTER', 'DART', 'MOBILE', 'WIDGET'];
  late String wordToGuess;
  List<String> guessedLetters = [];
  int attemptsLeft = 6;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    wordToGuess = (wordList.toList()..shuffle()).first;
    guessedLetters.clear();
    attemptsLeft = 6;
    setState(() {});
  }

  void guessLetter(String letter) {
    if (guessedLetters.contains(letter) || attemptsLeft == 0) return;

    setState(() {
      guessedLetters.add(letter);
      if (!wordToGuess.contains(letter)) {
        attemptsLeft--;
      }
    });
  }

  bool get isGameWon =>
      wordToGuess.split('').every((letter) => guessedLetters.contains(letter));

  bool get isGameOver => attemptsLeft == 0 || isGameWon;

  Widget buildWordDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: wordToGuess.split('').map((letter) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            guessedLetters.contains(letter) ? letter : '_',
            style: TextStyle(fontSize: 32, letterSpacing: 2),
          ),
        );
      }).toList(),
    );
  }

  Widget buildKeyboard() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: alphabet.split('').map((letter) {
        final guessed = guessedLetters.contains(letter);
        return ElevatedButton(
          onPressed: guessed || isGameOver ? null : () => guessLetter(letter),
          child: Text(letter),
          style: ElevatedButton.styleFrom(
            backgroundColor: guessed ? Colors.grey : Colors.blue,
            minimumSize: Size(40, 40),
            padding: EdgeInsets.zero,
          ),
        );
      }).toList(),
    );
  }

  Widget buildStatus() {
    if (isGameWon) return Text('🎉 You Won!', style: TextStyle(fontSize: 24));
    if (attemptsLeft == 0) return Text('❌ Game Over\nWord was: $wordToGuess', textAlign: TextAlign.center, style: TextStyle(fontSize: 20));
    return Text('Attempts Left: $attemptsLeft', style: TextStyle(fontSize: 18));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WordGuess')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildWordDisplay(),
            SizedBox(height: 20),
            buildStatus(),
            SizedBox(height: 20),
            buildKeyboard(),
            SizedBox(height: 20),
            if (isGameOver)
              ElevatedButton(
                onPressed: resetGame,
                child: Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}
