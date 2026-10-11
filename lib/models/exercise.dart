enum ExerciseCategory {
  wiederholungKlasse3, // 1. Lernstandserhebung – Zahlenraum bis 1000
  zahlenUndOperationen,
  raumUndForm,
  groessenUndMessen,
  datenUndZufall,
}

enum ExerciseType {
  // Wiederholung Klasse 3 / Lernstandserhebung (Zahlenraum bis 1000)
  oralWrittenAddSub,
  mulTensHundreds,
  divTensHundredsRest,
  numberPuzzle,
  moneyHandling,

  // Zahlen und Operationen
  addition,
  subtraction,
  multiplication,
  division,
  placeValue,
  compareNumbers,
  roundNumbers,
  numberSequence,
  writtenAddition,
  writtenSubtraction,
  writtenMultiplication,
  writtenDivision,
  wordProblem,

  // Raum und Form
  symmetry,
  shapes,
  volumeComparison,

  // Größen und Messen
  lengthConversion,
  massConversion,
  timeCalculation,
  moneyCalculation,
  volumeConversion,

  // Daten und Zufall
  dataReading,
  probability,
}

class Exercise {
  final String id;
  final ExerciseCategory category;
  final ExerciseType type;
  final String question;
  final String? questionDetail; // extra info / unit
  final List<String> options; // for multiple choice, empty if free input
  final String correctAnswer;
  final String? explanation;
  final int difficulty; // 1-3

  Exercise({
    required this.id,
    required this.category,
    required this.type,
    required this.question,
    this.questionDetail,
    this.options = const [],
    required this.correctAnswer,
    this.explanation,
    this.difficulty = 1,
  });

  bool get isMultipleChoice => options.isNotEmpty;

  bool checkAnswer(String userAnswer) {
    final cleaned = userAnswer.trim().replaceAll(' ', '').toLowerCase();
    final correct = correctAnswer.trim().replaceAll(' ', '').toLowerCase();
    return cleaned == correct;
  }
}


