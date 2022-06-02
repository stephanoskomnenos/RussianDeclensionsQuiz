import 'dart:math';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/noun.dart';
import '../utils/load_dict.dart';
import '../utils/word_accent.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<List<String>> nounDict = [];
  Noun? noun;
  NounCase correctCase = NounCase.nom;
  List<String> choices = [];
  int correctCount = 0, wrongCount = 0;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    loadNounDict();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
    final correctIndex = Random().nextInt(5) + 1;
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
        .map(((e) => Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
                width: 250,
                height: 80,
                child: Card(
                    child: TextButton(
                        child: Text(
                          addAccent(e),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => onSelected(e)))))))
        .toList();

    final pageBodyChoices = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${nounCasesNames.elementAt(correctCase.index)} case of ${addAccent(noun?.accented ?? '')}',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Text(
          addAccent(noun?.translation ?? ''),
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.all(5)),
        ...choicesCard,
        const Padding(padding: EdgeInsets.all(5)),
        Text('Correct: $correctCount'),
        Text('Wrong: $wrongCount'),
      ],
    );

    final pageBody = choices.isEmpty
        ? CircularProgressIndicator(value: controller.value)
        : pageBodyChoices;

    return Scaffold(
      appBar: AppBar(title: const Text("Russian Declension Quiz")),
      body: Center(
        child: pageBody,
      ),
    );
  }
}
