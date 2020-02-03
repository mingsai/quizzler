import 'package:hive/hive.dart';

part 'question.g.dart';

@HiveType(typeId: 0)
class Question extends HiveObject {
  @HiveField(0)
  String questionText;
  @HiveField(1)
  bool questionAnswer;

  Question({String q, bool a}) {
    questionAnswer = a;
    questionText = q;
  }
}
