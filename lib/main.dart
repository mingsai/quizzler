import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(Quizzler());
}

List<String> questions = [
  'You can lead a cow down stairs but not up stairs.',
  'Approximately one quarter of human bones are in the feet.',
  'A slug\'s blood is green.'
];
List<bool> answers = [false, true, true];

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
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
    return (answers[index] == selectedValue);
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
            child: Center(
              child: Text(
                questions[currentIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
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

class Score extends StatefulWidget {
  final bool isRightAnswer;
  Score({Key key, this.isRightAnswer}) : super(key: key);
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    if (widget.isRightAnswer == true) {
      return Icon(Icons.check, color: Colors.green);
    }
    return Icon(Icons.close, color: Colors.red);
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
