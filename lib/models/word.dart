abstract class Word {
  const Word(this.accented, this.translation);

  final String accented, translation;

  MapEntry<String, String> generateAnswer();

  List<String> generateChoices(String correctAnswer);
}
