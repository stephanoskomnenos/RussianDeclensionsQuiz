class Noun {
  const Noun(this.indeclinable, this.sgOnly, this.plOnly, this.accented,
      this.translation, this.sgCases, this.plCases);

  factory Noun.fromDictList(List<String> dictLine) {
    bool indeclinable = dictLine.elementAt(7) == '0' ? false : true;
    bool sgOnly = dictLine.elementAt(8) == '0' ? false : true;
    bool plOnly = dictLine.elementAt(9) == '0' ? false : true;

    List<String> sgCases = [];
    List<String> plCases = [];

    int lineIndex = 10;

    if (indeclinable == false) {
      if (plOnly == false) {
        for (int i = 0; i < 6; i++) {
          sgCases.add(dictLine.elementAt(lineIndex));
          lineIndex++;
        }
      }

      if (sgOnly == false) {
        for (int i = 0; i < 6; i++) {
          plCases.add(dictLine.elementAt(lineIndex));
          lineIndex++;
        }
      }
    }

    return Noun(indeclinable, sgOnly, plOnly, dictLine.elementAt(1),
        dictLine.elementAt(2), sgCases, plCases);
  }

  final bool indeclinable, sgOnly, plOnly;
  final String accented, translation;
  final List<String> sgCases, plCases;
}

enum NounCase {
  nom,
  gen,
  dat,
  acc,
  inst,
  prep,
}
