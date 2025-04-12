import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(TapPuzzleApp());

class TapPuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TapPuzzle',
      home: TapGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TapGame extends StatefulWidget {
  @override
  _TapGameState createState() => _TapGameState();
}

class _TapGameState extends State<TapGame> {
  int score = 0;
  int timeLeft = 30;
  int activeTile = -1;
  bool gameRunning = false;
  Timer? timer;

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      gameRunning = true;
      nextTile();
    });

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        timeLeft--;
        if (timeLeft == 0) {
          gameRunning = false;
          activeTile = -1;
          timer?.cancel();
        }
      });
    });
  }

  void nextTile() {
    if (!gameRunning) return;
    setState(() {
      activeTile = Random().nextInt(9);
    });
  }

  void tapTile(int index) {
    if (!gameRunning) return;
    if (index == activeTile) {
      score++;
      nextTile();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildTile(int index) {
    final isActive = index == activeTile;
    return GestureDetector(
      onTap: () => tapTile(index),
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TapPuzzle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!gameRunning)
              ElevatedButton(
                onPressed: startGame,
                child: Text('Start Game'),
              ),
            SizedBox(height: 10),
            Text('Time Left: $timeLeft sec', style: TextStyle(fontSize: 20)),
            Text('Score: $score', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (_, index) => buildTile(index),
              ),
            ),
            if (!gameRunning && score > 0)
              Text(
                'Final Score: $score',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
          ],
        ),
      ),
    );
  }
}
