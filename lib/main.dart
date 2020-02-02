import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzler/question.dart';
import 'package:quizzler/score.dart';

void main() {
  _setTargetPlatformForDesktop();
  loadData();
  runApp(Quizzler());
}

void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

List<Question> questions = [];
void loadData() {
  questions.add(Question(
      q: 'You can lead a cow down stairs but not up stairs.', a: false));
  questions.add(Question(
      q: 'Approximately one quarter of human bones are in the feet.', a: true));
  questions.add(Question(q: 'A slug\'s blood is green.', a: true));
}

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: new AppBar(
          title: Text('Quizzler'),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];
  int currentIndex = 0;

  void incrementIndex() {
    if (currentIndex < questions.length - 1) {
      currentIndex += 1;
    } else {
      currentIndex = 0;
    }
  }

  bool checkAnswer(int index, bool selectedValue) {
    return (questions[index].questionAnswer == selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.center,
              child: Wrap(
                children: [
                  Text(
                    questions[currentIndex].questionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        ButtonTheme(
          height: 70,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  scoreKeeper.add(
                    Score(
                      isRightAnswer: checkAnswer(currentIndex, true),
                    ),
                  );
                  incrementIndex();
                });
                //The user picked true.
              },
            ),
          ),
        ),
        ButtonTheme(
          height: 70.0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  scoreKeeper.add(
                    Score(
                      isRightAnswer: checkAnswer(currentIndex, false),
                    ),
                  );
                  incrementIndex();
                });
                //The user picked false.
              },
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: Wrap(
            children: scoreKeeper,
            direction: Axis.horizontal,
          ),
        )
      ],
    );
  }
}
