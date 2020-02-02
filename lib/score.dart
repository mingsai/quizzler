import 'package:flutter/material.dart';

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
