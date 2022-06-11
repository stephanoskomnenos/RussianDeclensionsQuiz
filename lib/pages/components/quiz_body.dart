import 'package:flutter/material.dart';

import '../../models/word.dart';
import '../../utils/word_accent.dart';

class QuizBody<T extends Word> extends StatelessWidget {
  const QuizBody({
    Key? key,
    required this.word,
    required this.onSelected,
    required this.correctCount,
    required this.wrongCount,
  }) : super(key: key);

  final T word;
  final int correctCount, wrongCount;
  final Function(String selection, String correctAnswer) onSelected;

  @override
  Widget build(BuildContext context) {
    // correctAnswer: MapEntry<CaseName, Case>
    final correctAnswer = word.generateAnswer();
    final choices = word.generateChoices(correctAnswer.value);

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
                        onPressed: () =>
                            onSelected(e, correctAnswer.value)))))))
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${correctAnswer.key} of ${addAccent(word.accented)}',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Text(
          addAccent(word.translation),
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.all(5)),
        ...choicesCard,
        const Padding(padding: EdgeInsets.all(5)),
        Text('Correct: $correctCount'),
        Text('Wrong: $wrongCount'),
      ],
    );
  }
}
