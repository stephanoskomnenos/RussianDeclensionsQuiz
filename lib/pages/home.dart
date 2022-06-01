import 'dart:math';
import 'package:flutter/material.dart';

import '../models/noun.dart';
import '../utils/load_dict.dart';
import '../utils/word_accent.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<String>> nounDict = [];
  Noun? noun;
  NounCase correctCase = NounCase.nom;
  List<String> choices = [];
  int correctCount = 0, wrongCount = 0;

  @override
  void initState() {
    super.initState();
    loadNounDict();
  }

  void loadNounDict() async {
    final nounDictAwait = await loadDict('nouns.csv');
    setState(() {
      nounDict = nounDictAwait;
    });
    getChoices();
  }

  void getChoices() {
    bool isValidNoun = false;
    while (!isValidNoun) {
      final randomNoun = Random().nextInt(nounDict.length - 2) + 1;
      noun = Noun.fromDictList(nounDict.elementAt(randomNoun));
      isValidNoun = (noun!.plOnly == false &&
          noun!.indeclinable == false &&
          noun!.sgCases.elementAt(0) != '');
    }
    List<String> newChoices = [];

    // pick a random case as the correct answer
    final correctIndex = Random().nextInt(6);
    final correctAns = noun!.sgCases.elementAt(correctIndex);
    newChoices.add(correctAns);

    // generate choices without duplication of correct answer
    for (int i = 0; i < 3;) {
      final thisCase = noun!.sgCases.elementAt(Random().nextInt(6));

      if (correctAns == thisCase) {
        continue;
      }
      newChoices.add(thisCase);
      i++;
    }

    newChoices.shuffle();

    setState(() {
      choices = newChoices;
      correctCase = NounCase.values.elementAt(correctIndex);
    });
  }

  void onSelected(String choice) {
    if (choice == noun!.sgCases.elementAt(correctCase.index)) {
      correctCount++;
    } else {
      wrongCount++;
    }
    getChoices();
  }

  @override
  Widget build(BuildContext context) {
    final choicesCard = choices
        .map(((e) => Card(
            child: TextButton(child: Text(addAccent(e)), onPressed: () => onSelected(e)))))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Russian Declension Quiz")),
      body: Center(
        child: Column(
          children: [
            Card(child: Text('${correctCase.name} of ${addAccent(noun?.accented ?? '')}')),
            ...choicesCard,
            Text('Correct: $correctCount'),
            Text('Wrong: $wrongCount'),
          ],
        ),
      ),
    );
  }
}
