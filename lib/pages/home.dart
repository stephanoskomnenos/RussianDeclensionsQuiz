import 'dart:math';
import 'package:flutter/material.dart';

import '../models/noun.dart';
import '../utils/load_dict.dart';

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
    getChoises();
  }

  void getChoises() {
    bool isValidNoun = false;
    while (!isValidNoun) {
      final randomNoun = Random().nextInt(nounDict.length);
      noun = Noun.fromDictList(nounDict.elementAt(randomNoun));
      isValidNoun = noun!.plOnly == false;
    }
    List<String> newChoices = [];

    // pick a random case as the correct answer
    final correctIndex = Random().nextInt(6);
    newChoices.add(noun!.sgCases.elementAt(correctIndex));

    // generate choices without duplication
    for (int i = 0; i < 3;) {
      final thisCase = noun!.sgCases.elementAt(Random().nextInt(6));
      bool caseDuplicated = false;
      for (final choice in newChoices) {
        if (choice == thisCase) {
          caseDuplicated = true;
          break;
        }
      }
      if (caseDuplicated == true) {
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
    getChoises();
  }

  @override
  Widget build(BuildContext context) {
    final choicesCard = choices
        .map(((e) => Card(
            child: TextButton(child: Text(e), onPressed: () => onSelected(e)))))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Russian Declension Quiz")),
      body: Center(
        child: Column(
          children: [
            Card(child: Text('${correctCase.name} + ${noun?.accented}')),
            ...choicesCard,
            Text('Correct: $correctCount'),
            Text('Wrong: $wrongCount'),
          ],
        ),
      ),
    );
  }
}
