import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:quizzler/question.dart';
import 'package:quizzler/score.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setTargetPlatformForDesktop();
  await setupHive();
  runApp(Quizzler());
}

Future<String> _localPath(String path) async {
  return new Directory(path).toString();
}

void initDesktopHive() {
  _localPath('.').then((pathValue) {
    Hive.init(pathValue);
  });
}

void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void openHiveBox() async {
//  if (!Hive.isBoxOpen('question')) {
  await Hive.openBox('questions');
//  }
}

//List<Question> questions = [];
void setupHive() async {
  bool isDesktopEnvironment =
      Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  if (isDesktopEnvironment) {
    initDesktopHive();
  } else {
    final appDirectory = await path_provider.getApplicationDocumentsDirectory();
    if (appDirectory != null) Hive.init(appDirectory.path);
  }
  await Hive.registerAdapter(QuestionAdapter());
  if (!Hive.isBoxOpen('questions')) await Hive.openBox('questions');
  final box = await Hive.box('questions');
  if (box.isEmpty) {
    box.add(Question(
        q: 'You can lead a cow down stairs but not up stairs.', a: false));
    box.add(Question(
        q: 'Approximately one quarter of human bones are in the feet.',
        a: true));
    box.add(Question(q: 'A slug\'s blood is green.', a: true));
  }
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
            child: FutureBuilder(
              future: Hive.openBox('questions'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "Error loading data - ${snapshot.error.toString()}"),
                    );
                  }
                  return QuizPage();
                } else {
                  return Center(child: Text("loading"));
                }
              },
            ),
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
  final questions = Hive.box('questions');

//  @override
//  void initState() {
//    // TODO: implement initState
//    if (!Hive.isBoxOpen('questions')) {
//      Hive.openBox('questions');
//    }
//    super.initState();
//  }

  void incrementIndex() {
    if (currentIndex < questions.length - 1) {
      currentIndex += 1;
    } else {
      currentIndex = 0;
    }
  }

  bool checkAnswer(int index, bool selectedValue) {
//    final questions = Hive.box('questions');
    Question obj = questions.getAt(index);
    return obj.questionAnswer == selectedValue;
    //return (questions[index].questionAnswer == selectedValue);
  }

//                Hive.box('questions').getAt(currentIndex).questionText,
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Flexible(
              flex: 0,
              child: AutoSizeText(
                questions.getAt(currentIndex).questionText,
                maxFontSize: 30.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: Wrap(
            children: scoreKeeper,
            direction: Axis.horizontal,
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
        )
      ],
    );
  }
}
