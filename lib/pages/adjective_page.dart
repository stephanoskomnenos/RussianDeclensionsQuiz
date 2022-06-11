import 'package:flutter/material.dart';

import '../models/adjective.dart';
import 'components/quiz_body.dart';

class AdjectivePage extends StatefulWidget {
  const AdjectivePage({Key? key, required this.adjectiveDict})
      : super(key: key);

  final List<List<String>> adjectiveDict;

  @override
  State<AdjectivePage> createState() => _AdjectivePageState();
}

class _AdjectivePageState extends State<AdjectivePage> {
  Adjective? adj;
  int correctCount = 0, wrongCount = 0;

  @override
  void initState() {
    super.initState();
    getRandomWord();
  }

  void getRandomWord() {
    final newAdj = Adjective.getRandomWord(widget.adjectiveDict);

    setState(() {
      adj = newAdj;
    });
  }

  void onSelected(String choice, String correctAnswer) {
    if (choice == correctAnswer) {
      correctCount++;
    } else {
      wrongCount++;
    }
    getRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QuizBody(
        word: adj!,
        onSelected: onSelected,
        correctCount: correctCount,
        wrongCount: wrongCount,
      ),
    );
  }
}
