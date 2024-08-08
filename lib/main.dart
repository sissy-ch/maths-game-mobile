import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MathsGame());
}

class MathsGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maths Game',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          primary: Color(0xFF62BFD1),
          secondary: Color(0xFF8DC41F),
          background: Color(0xFFFFFFFF),
          surface: Color(0xFFFFFFFF),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF797979)),
        ),
      ),
      home: MathsGameHomePage(),
    );
  }
}

class MathsGameHomePage extends StatefulWidget {
  @override
  _MathsGameHomePageState createState() => _MathsGameHomePageState();
}

class _MathsGameHomePageState extends State<MathsGameHomePage> {
  bool playing = false;
  int score = 0;
  int timeRemaining = 60;
  String question = '';
  late int correctAnswer;
  String selectedOperation = 'add';
  Timer? _timer;
  bool isCorrect = false;
  bool isWrong = false;

  final random = Random();
  List<int> choices = [];

  void startGame(String operation) {
    setState(() {
      selectedOperation = operation;
      playing = true;
      score = 0;
      timeRemaining = 60;
      generateQA();
      startTimer();
    });
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          _timer?.cancel();
          playing = false;
          showGameOverDialog();
        }
      });
    });
  }

  void generateQA() {
    setState(() {
      isCorrect = false;
      isWrong = false;
    });
    int x = random.nextInt(9) + 1;
    int y = random.nextInt(9) + 1;

    switch (selectedOperation) {
      case 'add':
        correctAnswer = x + y;
        question = '$x + $y';
        break;
      case 'subtract':
        correctAnswer = x - y;
        question = '$x - $y';
        break;
      case 'multiply':
        correctAnswer = x * y;
        question = '$x × $y';
        break;
      case 'divide':
        correctAnswer = (x / y).round();
        question = '$x ÷ $y';
        break;
    }

    choices = [correctAnswer];
    while (choices.length < 4) {
      int wrongAnswer = 0;
      switch (selectedOperation) {
        case 'add':
          wrongAnswer = random.nextInt(18) + 2;
          break;
        case 'subtract':
          wrongAnswer = random.nextInt(18) - 9;
          break;
        case 'multiply':
          wrongAnswer = (random.nextInt(9) + 1) * (random.nextInt(9) + 1);
          break;
        case 'divide':
          wrongAnswer = random.nextInt(9) + 1;
          break;
      }
      if (!choices.contains(wrongAnswer)) {
        choices.add(wrongAnswer);
      }
    }
    choices.shuffle();
  }

  void handleAnswer(int choice) {
    setState(() {
      if (choice == correctAnswer) {
        score++;
        isCorrect = true;
        isWrong = false;
        Future.delayed(const Duration(seconds: 1), generateQA);
      } else {
        if (score > 0) {
          score--;
        }
        isCorrect = false;
        isWrong = true;
      }
    });
  }

  void showOperationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Operation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame('add');
                  },
                  child: Text('Addition'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DC41F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame('subtract');
                  },
                  child: Text('Subtraction'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DC41F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame('multiply');
                  },
                  child: Text('Multiplication'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DC41F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame('divide');
                  },
                  child: Text('Division'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DC41F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Your score is: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  playing = false;
                  score = 0;
                  timeRemaining = 60;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maths Game'),
        backgroundColor: Color(0xFF62BFD1),
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF8DC41F),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: Colors.white),
                      SizedBox(width: 5),
                      Text('$timeRemaining sec',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF8DC41F),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.score, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Score: $score',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Visibility(
              visible: isCorrect,
              child: Text(
                'Correct ⭕',
                style: TextStyle(fontSize: 24, color: Color(0xFF8DC41F)),
              ),
            ),
            Visibility(
              visible: isWrong,
              child: Text(
                'You lost 1 point.Try again !',
                style: TextStyle(fontSize: 24, color: Color(0xFFDB6796)),
              ),
            ),
            SizedBox(height: 20),
            if (!playing)
              Column(
                children: [
                  Text(
                    "Let's Practice ✊",
                    style: TextStyle(fontSize: 24, color: Color(0xFF797979)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            if (playing) ...[
              SizedBox(height: 20),
              Text(
                question,
                style: TextStyle(fontSize: 32, color: Color(0xFF797979)),
              ),
              SizedBox(height: 20),
              Text(
                'Click on the correct answer 😉',
                style: TextStyle(fontSize: 20, color: Color(0xFF797979)),
              ),
              SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                children: choices.map((choice) {
                  return ElevatedButton(
                    onPressed: () => handleAnswer(choice),
                    child: Text(
                      choice.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: Size(80, 50),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!playing) {
                  showOperationDialog();
                } else {
                  setState(() {
                    playing = false;
                    _timer?.cancel();
                  });
                }
              },
              child: Text(playing ? 'Restart' : 'Start Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF62BFD1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 4,
                shadowColor: Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
