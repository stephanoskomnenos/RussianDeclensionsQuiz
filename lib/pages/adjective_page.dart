import 'dart:math';
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

class _AdjectivePageState extends State<AdjectivePage>
    with TickerProviderStateMixin {
  Adjective? adj;
  int correctCount = 0, wrongCount = 0;

  @override
  void initState() {
    super.initState();
    getRandomWord();
  }

  void getRandomWord() {
    bool isValidAdj = false;
    late Adjective newAdj;
    while (!isValidAdj) {
      final randomIndex = Random().nextInt(widget.adjectiveDict.length - 2) + 1;
      newAdj =
          Adjective.fromDictList(widget.adjectiveDict.elementAt(randomIndex));
      isValidAdj = newAdj.cases[AdjectiveCase.declMNom] != '';
    }

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
