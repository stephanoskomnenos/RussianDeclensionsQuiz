import 'dart:math';

import '../constants/constants.dart';
import 'word.dart';

class Noun extends Word {
  const Noun(accent, translation, this.indeclinable, this.sgOnly, this.plOnly,
      this.cases)
      : super(accent, translation);

  final bool indeclinable, sgOnly, plOnly;
  final Map<NounCase, String> cases;

  factory Noun.fromDictList(List<String> dictLine) {
    bool indeclinable = dictLine.elementAt(7) == '0' ? false : true;
    bool sgOnly = dictLine.elementAt(8) == '0' ? false : true;
    bool plOnly = dictLine.elementAt(9) == '0' ? false : true;

    Map<NounCase, String> cases = {};

    int sgIndex = 10, plIndex = 16;

    if (indeclinable == false) {
      if (plOnly == false) {
        final sgCases = {
          NounCase.sgNom: dictLine.elementAt(sgIndex),
          NounCase.sgGen: dictLine.elementAt(sgIndex + 1),
          NounCase.sgDat: dictLine.elementAt(sgIndex + 2),
          NounCase.sgAcc: dictLine.elementAt(sgIndex + 3),
          NounCase.sgInst: dictLine.elementAt(sgIndex + 4),
          NounCase.sgPrep: dictLine.elementAt(sgIndex + 5),
        };
        cases.addEntries(sgCases.entries);
      }

      if (sgOnly == false) {
        final plCases = {
          NounCase.plNom: dictLine.elementAt(plIndex),
          NounCase.plGen: dictLine.elementAt(plIndex + 1),
          NounCase.plDat: dictLine.elementAt(plIndex + 2),
          NounCase.plAcc: dictLine.elementAt(plIndex + 3),
          NounCase.plInst: dictLine.elementAt(plIndex + 4),
          NounCase.plPrep: dictLine.elementAt(plIndex + 5),
        };
        cases.addEntries(plCases.entries);
      }
    }

    return Noun(dictLine.elementAt(1), dictLine.elementAt(2), indeclinable,
        sgOnly, plOnly, cases);
  }

  factory Noun.getRandomWord(List<List<String>> nounDict) {
    bool isValidNoun = false;
    late Noun newNoun;
    while (!isValidNoun) {
      final randomIndex = Random().nextInt(nounDict.length - 1);
      newNoun = Noun.fromDictList(nounDict.elementAt(randomIndex));
      isValidNoun =
          !newNoun.indeclinable && newNoun.cases[NounCase.sgNom] != '';
    }

    return newNoun;
  }

  @override
  MapEntry<String, String> generateAnswer() {
    while (true) {
      var answerCase = NounCase.values[Random().nextInt(12)];
      if (cases.containsKey(answerCase)) {
        return MapEntry(nounCasesNames[answerCase.index], cases[answerCase]!);
      }
    }
  }

  @override
  List<String> generateChoices(String correctAnswer) {
    List<String> choices = [];
    choices.add(correctAnswer);

    // generate choices without duplication of correct answer
    for (int i = 0; i < 3;) {
      final thisCaseName = NounCase.values[Random().nextInt(nounCasesCount)];
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

enum NounCase {
  sgNom,
  sgGen,
  sgDat,
  sgAcc,
  sgInst,
  sgPrep,
  plNom,
  plGen,
  plDat,
  plAcc,
  plInst,
  plPrep,
}
