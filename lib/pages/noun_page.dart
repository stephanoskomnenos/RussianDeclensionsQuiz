import 'package:flutter/material.dart';

import '../models/noun.dart';
import 'components/quiz_body.dart';

class NounPage extends StatefulWidget {
  const NounPage({Key? key, required this.nounDict}) : super(key: key);
  final List<List<String>> nounDict;

  @override
  State<NounPage> createState() => _NounPageState();
}

class _NounPageState extends State<NounPage> {
  late Noun noun;
  int correctCount = 0, wrongCount = 0;

  @override
  void initState() {
    super.initState();
    getRandomWord();
  }

  void getRandomWord() {
    final newNoun = Noun.getRandomWord(widget.nounDict);

    setState(() {
      noun = newNoun;
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
        word: noun,
        onSelected: onSelected,
        correctCount: correctCount,
        wrongCount: wrongCount,
      ),
    );
  }
}
