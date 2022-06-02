import 'dart:math';

import 'package:russian_declensions_quiz/constants/constants.dart';

import 'word.dart';

class Adjective extends Word {
  const Adjective(accented, translation, this.cases)
      : super(accented, translation);

  final Map<AdjectiveCase, String> cases;

  factory Adjective.fromDictList(List<String> dictLine) {
    Map<AdjectiveCase, String> cases = {};
    int caseStart = 5;
    for (int i = 0; i < 23; i++) {
      cases[AdjectiveCase.values[i]] = dictLine.elementAt(caseStart + i);
    }

    return Adjective(dictLine.elementAt(1), dictLine.elementAt(2), cases);
  }

  @override
  MapEntry<String, String> generateAnswer() {
    while (true) {
      var answerCase =
          AdjectiveCase.values[Random().nextInt(adjectiveCasesCount)];
      if (cases[answerCase] != null && cases[answerCase] != '') {
        return MapEntry(
            adjectiveCasesNames[answerCase.index], cases[answerCase]!);
      }
    }
  }

  @override
  List<String> generateChoices(String correctAnswer) {
    List<String> choices = [];
    choices.add(correctAnswer);

    // generate choices without duplication of correct answer
    for (int i = 0; i < 3;) {
      final thisCaseName =
          AdjectiveCase.values[Random().nextInt(adjectiveCasesCount)];
      final thisCase = cases[thisCaseName];

      if (thisCase == null || thisCase == '' || correctAnswer == thisCase) {
        continue;
      }
      choices.add(thisCase);
      i++;
    }

    choices.shuffle();

    return choices;
  }
}

enum AdjectiveCase {
  comparative,
  superlative,
  shortM,
  shortF,
  shortN,
  shortPl,
  declMNom,
  declMGen,
  declMDat,
  declMAcc,
  declMInst,
  declMPrep,
  declFNom,
  declFGen,
  declFDat,
  declFAcc,
  declFInst,
  declFPrep,
  declNNom,
  declNGen,
  declNDat,
  declNAcc,
  declNInst,
  declNPrep,
}
