import 'dart:math';
import '../models/exercise.dart';

class ExerciseGenerator {
  final Random _rnd = Random();

  Exercise generate(ExerciseCategory category, {int difficulty = 1}) {
    switch (category) {
      case ExerciseCategory.wiederholungKlasse3:
        return _generateWiederholung(_rnd.nextInt(6), difficulty);
      case ExerciseCategory.zahlenUndOperationen:
        return _generateZahlen(_rnd.nextInt(12), difficulty);
      case ExerciseCategory.raumUndForm:
        return _generateRaum(_rnd.nextInt(3), difficulty);
      case ExerciseCategory.groessenUndMessen:
        return _generateGroessen(_rnd.nextInt(5), difficulty);
      case ExerciseCategory.datenUndZufall:
        return _generateDaten(_rnd.nextInt(2), difficulty);
    }
  }

  List<Exercise> generateSet(ExerciseCategory category, int count, {int difficulty = 1}) {
    return List.generate(count, (_) => generate(category, difficulty: difficulty));
  }

  // ─────────────────────────────────────────────
  // ZAHLEN UND OPERATIONEN
  // ─────────────────────────────────────────────
  Exercise _generateZahlen(int type, int difficulty) {
    switch (type) {
      case 0:
        return _addition(difficulty);
      case 1:
        return _subtraction(difficulty);
      case 2:
        return _multiplication(difficulty);
      case 3:
        return _division(difficulty);
      case 4:
        return _placeValue(difficulty);
      case 5:
        return _compareNumbers(difficulty);
      case 6:
        return _roundNumbers(difficulty);
      case 7:
        return _numberSequence(difficulty);
      case 8:
        return _writtenAddition(difficulty);
      case 9:
        return _writtenSubtraction(difficulty);
      case 10:
        return _writtenMultiplication(difficulty);
      default:
        return _wordProblem(difficulty);
    }
  }

  Exercise _addition(int d) {
    int a, b;
    if (d == 1) {
      a = _rnd.nextInt(900) + 100;
      b = _rnd.nextInt(900) + 100;
    } else if (d == 2) {
      a = _rnd.nextInt(90000) + 1000;
      b = _rnd.nextInt(90000) + 1000;
    } else {
      a = _rnd.nextInt(400000) + 100000;
      b = _rnd.nextInt(400000) + 100000;
    }
    return Exercise(
      id: 'add_${a}_$b',
      category: ExerciseCategory.zahlenUndOperationen,
      type: ExerciseType.addition,
      question: 'Berechne: $a + $b =',
      correctAnswer: (a + b).toString(),
      difficulty: d,
      explanation: 'Stelle die Zahlen untereinander und addiere von rechts nach links.',
    );
  }

  Exercise _subtraction(int d) {
    int a, b;
    if (d == 1) {
      a = _rnd.nextInt(800) + 200;
      b = _rnd.nextInt(a - 50) + 50;
    } else if (d == 2) {
      a = _rnd.nextInt(80000) + 10000;
      b = _rnd.nextInt(a ~/ 2) + 1000;
    } else {
      a = _rnd.nextInt(700000) + 200000;
      b = _rnd.nextInt(a ~/ 2) + 10000;
    }
    return Exercise(
      id: 'sub_${a}_$b',
      category: ExerciseCategory.zahlenUndOperationen,
      type: ExerciseType.subtraction,
      question: 'Berechne: $a − $b =',
      correctAnswer: (a - b).toString(),
      difficulty: d,
    );
  }

  Exercise _multiplication(int d) {
    int a, b;
    if (d == 1) {
      // Einmaleins
      a = _rnd.nextInt(9) + 2;
      b = _rnd.nextInt(9) + 2;
    } else if (d == 2) {
      a = _rnd.nextInt(90) + 10;
      b = _rnd.nextInt(9) + 2;
    } else {
      a = _rnd.nextInt(90) + 10;
      b = _rnd.nextInt(20) + 11;
    }
    return Exercise(
      id: 'mul_${a}_$b',
      category: ExerciseCategory.zahlenUndOperationen,
      type: ExerciseType.multiplication,
      question: 'Berechne: $a · $b =',
      correctAnswer: (a * b).toString(),
      difficulty: d,
      explanation: d == 1 ? 'Nutze das kleine Einmaleins.' : 'Zerlege oder rechne schriftlich.',
    );
  }

  Exercise _division(int d) {
    int b = d == 1 ? _rnd.nextInt(9) + 2 : _rnd.nextInt(8) + 2;
    int result = d == 1 ? _rnd.nextInt(9) + 2 : _rnd.nextInt(90) + 10;
    int a = b * result;
    // sometimes with remainder
    bool withRest = d >= 2 && _rnd.nextBool();
    int rest = 0;
    if (withRest) {
      rest = _rnd.nextInt(b - 1) + 1;
      a += rest;
    }
    final answer = withRest ? '$result R$rest' : result.toString();
    return Exercise(
      id: 'div_${a}_$b',
      category: ExerciseCategory.zahlenUndOperationen,
      type: ExerciseType.division,
      question: 'Berechne: $a : $b =',
      questionDetail: withRest ? 'Mit Rest (z. B. 17 R2)' : null,
      correctAnswer: answer,
      difficulty: d,
    );
  }

  Exercise _placeValue(int d) {
    int num;
    if (d == 1) {
      num = _rnd.nextInt(9000) + 1000;
    } else if (d == 2) {
      num = _rnd.nextInt(90000) + 10000;
    } else {
      num = _rnd.nextInt(900000) + 100000;
    }
    final variants = [
      () {
        final h = (num ~/ 100) % 10;
        return Exercise(
          id: 'pv_h_$num',
          category: ExerciseCategory.zahlenUndOperationen,
          type: ExerciseType.placeValue,
          question: 'Welche Ziffer steht an der Hunderterstelle von $num?',
          correctAnswer: h.toString(),
          difficulty: d,
        );
      },
      () {
        final t = (num ~/ 1000) % 10;
        return Exercise(
          id: 'pv_t_$num',
          category: ExerciseCategory.zahlenUndOperationen,
          type: ExerciseType.placeValue,
          question: 'Welche Ziffer steht an der Tausenderstelle von $num?',
          correctAnswer: t.toString(),
          difficulty: d,
        );
      },
      () {
        final z = (num ~/ 10) % 10;
        return Exercise(
          id: 'pv_z_$num',
          category: ExerciseCategory.zahlenUndOperationen,
          type: ExerciseType.placeValue,
          question: 'Welche Ziffer steht an der Zehnerstelle von $num?',
          correctAnswer: z.toString(),
          difficulty: d,
        );
      },
      () {
        // expand
        final e = num % 10;
        final z = (num ~/ 10) % 10;
        final h = (num ~/ 100) % 10;
        final t = (num ~/ 1000) % 10;
        final zt = (num ~/ 10000) % 10;
        final ht = (num ~/ 100000) % 10;
        String expand = '';
        if (ht > 0) expand += '$ht Hunderttausender + ';
        if (zt > 0) expand += '$zt Zehntausender + ';
        if (t > 0) expand += '$t Tausender + ';
        if (h > 0) expand += '$h Hunderter + ';
        if (z > 0) expand += '$z Zehner + ';
        expand += '$e Einer';
        return Exercise(
          id: 'pv_exp_$num',
          category: ExerciseCategory.zahlenUndOperationen,
          type: ExerciseType.placeValue,
          question: 'Zerlege $num in Stellenwerte (z. B. 3 Tausender + 4 Hunderter + …):',
          correctAnswer: expand,
          difficulty: d,
          explanation: 'Stelle dir die Stellenwerttafel vor.',
        );
      },
    ];
    return variants[_rnd.nextInt(variants.length)]();
  }

  Exercise _compareNumbers(int d) {
    int a, b;
    if (d == 1) {
      a = _rnd.nextInt(9000) + 1000;
      b = _rnd.nextInt(9000) + 1000;
    } else {
      a = _rnd.nextInt(900000) + 10000;
      b = _rnd.nextInt(900000) + 10000;
    }
    if (a == b) b += 1;
    final symbol = a > b ? '>' : '<';
    return Exercise(
      id: 'cmp_${a}_$b',
      category: ExerciseCategory.zahlenUndOperationen,
      type: ExerciseType.compareNumbers,
      question: 'Vergleiche: $a  ?  $b',
      questionDetail: 'Schreibe < oder >',
      correctAnswer: symbol,
      options: ['<', '>'],
      difficulty: d,
    );
  }

  Exercise _roundNumbers(int d) {
    int num;
    int place;
    String placeName;
    if (d == 1) {
      num = _rnd.nextInt(900) + 100;
      place = 10;
      placeName = 'Zehner';
    } else if (d == 2) {
      num = _rnd.nextInt(9000) + 1000;
      place = _rnd.nextBool() ? 10 : 100;
      placeName = place == 10 ? 'Zehner' : 'Hunderter';
    } else {
      num = _rnd.nextInt(90000) + 10000;
      place = [10, 100, 1000][_rnd.nextInt(3)];
      placeName = place == 10 ? 'Zehner' : place == 100 ? 'Hunderter' : 'Tausender';
    }
    final rounded = ((num + place ~/ 2) ~/ place) * place;
    return Exercise(
      id: 'rnd_$num',
      category: ExerciseCategory.zahlenUndOperationen,
      type: ExerciseType.roundNumbers,
      question: 'Runde $num auf den nächsten $placeName.',
      correctAnswer: rounded.toString(),
      difficulty: d,
    );
  }

  Exercise _numberSequence(int d) {
    int start = _rnd.nextInt(50) + 10;
    int step = d == 1 ? (_rnd.nextInt(5) + 2) : (_rnd.nextInt(20) + 5);
    if (_rnd.nextBool()) step = -step;
    final seq = List.generate(4, (i) => start + i * step);
    final next = start + 4 * step;
    return Exercise(
      id: 'seq_$start',
      category: ExerciseCategory.zahlenUndOperationen,
      type: ExerciseType.numberSequence,
      question: 'Welche Zahl kommt als Nächstes?\n${seq.join('  –  ')}  –  ?',
      correctAnswer: next.toString(),
      difficulty: d,
      explanation: 'Die Differenz beträgt $step.',
    );
  }

  Exercise _writtenAddition(int d) {
    return _addition(d); // same, but marked as written
  }

  Exercise _writtenSubtraction(int d) {
    return _subtraction(d);
  }

  Exercise _writtenMultiplication(int d) {
    return _multiplication(d == 1 ? 2 : 3);
  }

  Exercise _wordProblem(int d) {
    final problems = [
      () {
        final price = (_rnd.nextInt(8) + 2) * 50; // in cent
        final amount = _rnd.nextInt(5) + 2;
        final total = price * amount;
        final euros = total ~/ 100;
        final cents = total % 100;
        return Exercise(
          id: 'wp_price',
          category: ExerciseCategory.zahlenUndOperationen,
          type: ExerciseType.wordProblem,
          question: 'Ein Heft kostet ${price ~/ 100},${(price % 100).toString().padLeft(2, '0')} €. '
              'Wie viel kosten $amount Hefte zusammen?',
          correctAnswer: cents == 0 ? '$euros' : '$euros,${cents.toString().padLeft(2, '0')}',
          questionDetail: 'Antwort in Euro (z. B. 7,50)',
          difficulty: d,
        );
      },
      () {
        final children = _rnd.nextInt(15) + 10;
        final adults = _rnd.nextInt(10) + 5;
        const childPrice = 4;
        const adultPrice = 7;
        final total = children * childPrice + adults * adultPrice;
        return Exercise(
          id: 'wp_cinema',
          category: ExerciseCategory.zahlenUndOperationen,
          type: ExerciseType.wordProblem,
          question: 'Im Kino kostet die Eintrittskarte für Kinder $childPrice € und für Erwachsene $adultPrice €. '
              'Es kommen $children Kinder und $adults Erwachsene. Wie viel Euro kostet der Eintritt insgesamt?',
          correctAnswer: total.toString(),
          difficulty: d,
        );
      },
      () {
        final km = _rnd.nextInt(80) + 20;
        final hours = _rnd.nextInt(3) + 2;
        final speed = km ~/ hours; // approximate
        final realKm = speed * hours;
        return Exercise(
          id: 'wp_speed',
          category: ExerciseCategory.zahlenUndOperationen,
          type: ExerciseType.wordProblem,
          question: 'Ein Auto fährt mit $speed km/h. Wie viele Kilometer legt es in $hours Stunden zurück?',
          correctAnswer: realKm.toString(),
          difficulty: d,
        );
      },
    ];
    return problems[_rnd.nextInt(problems.length)]();
  }

  // ─────────────────────────────────────────────
  // RAUM UND FORM
  // ─────────────────────────────────────────────
  Exercise _generateRaum(int type, int difficulty) {
    switch (type) {
      case 0:
        return _symmetry(difficulty);
      case 1:
        return _shapes(difficulty);
      default:
        return _volumeComparison(difficulty);
    }
  }

  Exercise _symmetry(int d) {
    final questions = [
      Exercise(
        id: 'sym1',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.symmetry,
        question: 'Wie viele Symmetrieachsen hat ein Quadrat?',
        correctAnswer: '4',
        options: ['1', '2', '3', '4'],
        difficulty: d,
        explanation: 'Ein Quadrat hat 4 Achsen: 2 Diagonalen und 2 Mittellinien.',
      ),
      Exercise(
        id: 'sym2',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.symmetry,
        question: 'Wie viele Symmetrieachsen hat ein Rechteck, das kein Quadrat ist?',
        correctAnswer: '2',
        options: ['0', '1', '2', '4'],
        difficulty: d,
      ),
      Exercise(
        id: 'sym3',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.symmetry,
        question: 'Wie viele Symmetrieachsen hat ein gleichseitiges Dreieck?',
        correctAnswer: '3',
        options: ['0', '1', '2', '3'],
        difficulty: d,
      ),
      Exercise(
        id: 'sym4',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.symmetry,
        question: 'Ein Kreis hat … Symmetrieachsen.',
        correctAnswer: 'unendlich viele',
        options: ['0', '1', '4', 'unendlich viele'],
        difficulty: d,
      ),
    ];
    return questions[_rnd.nextInt(questions.length)];
  }

  Exercise _shapes(int d) {
    final questions = [
      Exercise(
        id: 'shape1',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.shapes,
        question: 'Wie viele Ecken hat ein Würfel?',
        correctAnswer: '8',
        options: ['4', '6', '8', '12'],
        difficulty: d,
      ),
      Exercise(
        id: 'shape2',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.shapes,
        question: 'Wie viele Flächen hat ein Quader?',
        correctAnswer: '6',
        options: ['4', '5', '6', '8'],
        difficulty: d,
      ),
      Exercise(
        id: 'shape3',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.shapes,
        question: 'Wie viele Kanten hat ein Würfel?',
        correctAnswer: '12',
        options: ['6', '8', '10', '12'],
        difficulty: d,
      ),
      Exercise(
        id: 'shape4',
        category: ExerciseCategory.raumUndForm,
        type: ExerciseType.shapes,
        question: 'Welche Aussage ist richtig?',
        correctAnswer: 'Jedes Quadrat ist ein Rechteck',
        options: [
          'Jedes Rechteck ist ein Quadrat',
          'Jedes Quadrat ist ein Rechteck',
          'Kein Rechteck ist ein Quadrat',
          'Quadrat und Rechteck sind dasselbe'
        ],
        difficulty: d,
      ),
    ];
    return questions[_rnd.nextInt(questions.length)];
  }

  Exercise _volumeComparison(int d) {
    final a = _rnd.nextInt(5) + 2;
    final b = _rnd.nextInt(5) + 2;
    final c = _rnd.nextInt(5) + 2;
    final vol = a * b * c;
    return Exercise(
      id: 'vol_$a$b$c',
      category: ExerciseCategory.raumUndForm,
      type: ExerciseType.volumeComparison,
      question: 'Ein Quader besteht aus $a × $b × $c Einheitswürfeln. '
          'Wie viele Einheitswürfel braucht man insgesamt?',
      correctAnswer: vol.toString(),
      difficulty: d,
      explanation: 'Rauminhalt = Länge × Breite × Höhe',
    );
  }

  // ─────────────────────────────────────────────
  // GRÖSSEN UND MESSEN
  // ─────────────────────────────────────────────
  Exercise _generateGroessen(int type, int difficulty) {
    switch (type) {
      case 0:
        return _lengthConversion(difficulty);
      case 1:
        return _massConversion(difficulty);
      case 2:
        return _timeCalculation(difficulty);
      case 3:
        return _moneyCalculation(difficulty);
      default:
        return _volumeConversion(difficulty);
    }
  }

  Exercise _lengthConversion(int d) {
    final variants = [
      () {
        final m = _rnd.nextInt(9) + 1;
        final cm = m * 100;
        return Exercise(
          id: 'len_m_cm',
          category: ExerciseCategory.groessenUndMessen,
          type: ExerciseType.lengthConversion,
          question: 'Wie viele Zentimeter sind $m Meter?',
          correctAnswer: cm.toString(),
          difficulty: d,
        );
      },
      () {
        final km = _rnd.nextInt(5) + 1;
        final m = km * 1000;
        return Exercise(
          id: 'len_km_m',
          category: ExerciseCategory.groessenUndMessen,
          type: ExerciseType.lengthConversion,
          question: 'Wie viele Meter sind $km Kilometer?',
          correctAnswer: m.toString(),
          difficulty: d,
        );
      },
      () {
        final cm = (_rnd.nextInt(9) + 1) * 10;
        final mm = cm * 10;
        return Exercise(
          id: 'len_cm_mm',
          category: ExerciseCategory.groessenUndMessen,
          type: ExerciseType.lengthConversion,
          question: 'Wie viele Millimeter sind $cm cm?',
          correctAnswer: mm.toString(),
          difficulty: d,
        );
      },
      () {
        final totalCm = _rnd.nextInt(400) + 150;
        final m = totalCm ~/ 100;
        final cm = totalCm % 100;
        return Exercise(
          id: 'len_mix',
          category: ExerciseCategory.groessenUndMessen,
          type: ExerciseType.lengthConversion,
          question: 'Wandle um: $totalCm cm = ? m und ? cm',
          correctAnswer: '$m m $cm cm',
          questionDetail: 'Format: z. B. 2 m 35 cm',
          difficulty: d,
        );
      },
    ];
    return variants[_rnd.nextInt(variants.length)]();
  }

  Exercise _massConversion(int d) {
    final kg = _rnd.nextInt(8) + 1;
    final g = kg * 1000;
    if (_rnd.nextBool()) {
      return Exercise(
        id: 'mass_kg_g',
        category: ExerciseCategory.groessenUndMessen,
        type: ExerciseType.massConversion,
        question: 'Wie viele Gramm sind $kg kg?',
        correctAnswer: g.toString(),
        difficulty: d,
      );
    } else {
      final totalG = _rnd.nextInt(4000) + 1500;
      final k = totalG ~/ 1000;
      final gr = totalG % 1000;
      return Exercise(
        id: 'mass_mix',
        category: ExerciseCategory.groessenUndMessen,
        type: ExerciseType.massConversion,
        question: 'Wandle um: $totalG g = ? kg und ? g',
        correctAnswer: '$k kg $gr g',
        questionDetail: 'Format: z. B. 2 kg 350 g',
        difficulty: d,
      );
    }
  }

  Exercise _timeCalculation(int d) {
    final h1 = _rnd.nextInt(10) + 8;
    final m1 = _rnd.nextInt(5) * 10;
    final durationH = _rnd.nextInt(3) + 1;
    final durationM = _rnd.nextInt(5) * 10;
    int endH = h1 + durationH;
    int endM = m1 + durationM;
    if (endM >= 60) {
      endH += 1;
      endM -= 60;
    }
    if (endH >= 24) endH -= 24;
    return Exercise(
      id: 'time_$h1$m1',
      category: ExerciseCategory.groessenUndMessen,
      type: ExerciseType.timeCalculation,
      question: 'Ein Film beginnt um ${h1.toString().padLeft(2, '0')}:${m1.toString().padLeft(2, '0')} Uhr '
          'und dauert $durationH Stunde${durationH > 1 ? 'n' : ''} und $durationM Minuten. '
          'Wann endet der Film?',
      correctAnswer: '${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}',
      questionDetail: 'Format: z. B. 14:30',
      difficulty: d,
    );
  }

  Exercise _moneyCalculation(int d) {
    final euros = _rnd.nextInt(20) + 5;
    final cents = _rnd.nextInt(9) * 10 + 5;
    final pay = euros + 5;
    final changeCents = (pay * 100) - (euros * 100 + cents);
    final changeE = changeCents ~/ 100;
    final changeC = changeCents % 100;
    return Exercise(
      id: 'money_$euros',
      category: ExerciseCategory.groessenUndMessen,
      type: ExerciseType.moneyCalculation,
      question: 'Du kaufst etwas für $euros,${cents.toString().padLeft(2, '0')} € und gibst einen $pay-Euro-Schein. '
          'Wie viel Euro bekommst du zurück?',
      correctAnswer: changeC == 0 ? '$changeE' : '$changeE,${changeC.toString().padLeft(2, '0')}',
      questionDetail: 'Format: z. B. 2,50',
      difficulty: d,
    );
  }

  Exercise _volumeConversion(int d) {
    final l = _rnd.nextInt(5) + 1;
    final ml = l * 1000;
    return Exercise(
      id: 'vol_l_ml',
      category: ExerciseCategory.groessenUndMessen,
      type: ExerciseType.volumeConversion,
      question: 'Wie viele Milliliter sind $l Liter?',
      correctAnswer: ml.toString(),
      difficulty: d,
    );
  }

  // ─────────────────────────────────────────────
  // DATEN UND ZUFALL
  // ─────────────────────────────────────────────
  Exercise _generateDaten(int type, int difficulty) {
    if (type == 0) return _dataReading(difficulty);
    return _probability(difficulty);
  }

  Exercise _dataReading(int d) {
    final a = _rnd.nextInt(30) + 10;
    final b = _rnd.nextInt(30) + 10;
    final c = _rnd.nextInt(30) + 10;
    final total = a + b + c;
    final questions = [
      Exercise(
        id: 'data_sum',
        category: ExerciseCategory.datenUndZufall,
        type: ExerciseType.dataReading,
        question: 'In einer Klasse haben $a Kinder braune, $b Kinder blonde und $c Kinder schwarze Haare. '
            'Wie viele Kinder sind es insgesamt?',
        correctAnswer: total.toString(),
        difficulty: d,
      ),
      Exercise(
        id: 'data_diff',
        category: ExerciseCategory.datenUndZufall,
        type: ExerciseType.dataReading,
        question: 'In einer Klasse haben $a Kinder braune und $b Kinder blonde Haare. '
            'Wie viele Kinder mehr haben braune Haare?',
        correctAnswer: (a - b).abs().toString(),
        difficulty: d,
      ),
    ];
    return questions[_rnd.nextInt(questions.length)];
  }

  Exercise _probability(int d) {
    final questions = [
      Exercise(
        id: 'prob1',
        category: ExerciseCategory.datenUndZufall,
        type: ExerciseType.probability,
        question: 'Ein Würfel wird geworfen. Wie groß ist die Wahrscheinlichkeit, eine 6 zu würfeln?',
        correctAnswer: '1/6',
        options: ['1/2', '1/3', '1/6', '1/4'],
        difficulty: d,
        explanation: 'Es gibt 6 mögliche Augenzahlen, davon ist eine die 6.',
      ),
      Exercise(
        id: 'prob2',
        category: ExerciseCategory.datenUndZufall,
        type: ExerciseType.probability,
        question: 'In einem Beutel sind 3 rote und 5 blaue Kugeln. '
            'Wie groß ist die Wahrscheinlichkeit, eine rote Kugel zu ziehen?',
        correctAnswer: '3/8',
        options: ['3/5', '3/8', '5/8', '1/2'],
        difficulty: d,
      ),
      Exercise(
        id: 'prob3',
        category: ExerciseCategory.datenUndZufall,
        type: ExerciseType.probability,
        question: 'Ein Glücksrad hat 4 gleiche Felder: rot, blau, grün, gelb. '
            'Wie groß ist die Wahrscheinlichkeit, auf „blau“ zu landen?',
        correctAnswer: '1/4',
        options: ['1/2', '1/3', '1/4', '1/5'],
        difficulty: d,
      ),
    ];
    return questions[_rnd.nextInt(questions.length)];
  }

  // ─────────────────────────────────────────────
  // WIEDERHOLUNG KLASSE 3 – Lernstandserhebung
  // Zahlenraum bis 1000 (laut Elternbrief)
  // ─────────────────────────────────────────────
  Exercise _generateWiederholung(int type, int difficulty) {
    switch (type) {
      case 0:
        return _oralWrittenAddSub(difficulty);
      case 1:
        return _mulTensHundreds(difficulty);
      case 2:
        return _divTensHundredsRest(difficulty);
      case 3:
        return _numberPuzzle(difficulty);
      case 4:
        return _sachaufgabeBis1000(difficulty);
      default:
        return _moneyHandling(difficulty);
    }
  }

  /// Mündliche und schriftliche Addition und Subtraktion (Zahlenraum bis 1000)
  Exercise _oralWrittenAddSub(int d) {
    final isAdd = _rnd.nextBool();
    int a, b;
    if (d == 1) {
      a = _rnd.nextInt(400) + 100;
      b = _rnd.nextInt(400) + 100;
    } else {
      a = _rnd.nextInt(700) + 200;
      b = _rnd.nextInt(700) + 100;
    }
    if (!isAdd && b > a) {
      final t = a;
      a = b;
      b = t;
    }
    final result = isAdd ? a + b : a - b;
    final op = isAdd ? '+' : '−';
    final written = d >= 2;
    return Exercise(
      id: 'w3_addsub_${a}_$b',
      category: ExerciseCategory.wiederholungKlasse3,
      type: ExerciseType.oralWrittenAddSub,
      question: written
          ? 'Rechne schriftlich: $a $op $b ='
          : 'Berechne (mündlich oder halbschriftlich): $a $op $b =',
      questionDetail: written
          ? 'Achte auf die richtige Form des schriftlichen Verfahrens!'
          : null,
      correctAnswer: result.toString(),
      difficulty: d,
      explanation: written
          ? 'Stelle die Zahlen untereinander. Beginne rechts bei den Einern.'
          : null,
    );
  }

  /// Multiplikation, auch mit Zehner- und Hunderterzahlen
  Exercise _mulTensHundreds(int d) {
    int a, b;
    if (d == 1) {
      // Einmaleins oder ×10 / ×100
      a = _rnd.nextInt(9) + 2;
      b = [10, 20, 30, 40, 50, 100][_rnd.nextInt(6)];
    } else if (d == 2) {
      a = _rnd.nextInt(9) + 2;
      b = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300][_rnd.nextInt(12)];
    } else {
      a = _rnd.nextInt(20) + 5;
      b = [10, 20, 30, 40, 50, 100, 200][_rnd.nextInt(7)];
    }
    return Exercise(
      id: 'w3_mul_${a}_$b',
      category: ExerciseCategory.wiederholungKlasse3,
      type: ExerciseType.mulTensHundreds,
      question: 'Berechne: $a · $b =',
      correctAnswer: (a * b).toString(),
      difficulty: d,
      explanation: b % 10 == 0
          ? 'Tipp: $a · ${b ~/ 10} = ${a * (b ~/ 10)}, dann mit 10 multiplizieren.'
          : null,
    );
  }

  /// Division, auch mit Zehner- und Hunderterzahlen und Rest
  Exercise _divTensHundredsRest(int d) {
    final withRest = d >= 2 && _rnd.nextBool();
    int divisor;
    int quotient;
    if (d == 1) {
      divisor = [2, 3, 4, 5, 10][_rnd.nextInt(5)];
      quotient = _rnd.nextInt(20) + 5;
    } else {
      divisor = [2, 3, 4, 5, 6, 10, 20, 25, 50, 100][_rnd.nextInt(10)];
      quotient = _rnd.nextInt(15) + 3;
    }
    int dividend = divisor * quotient;
    int rest = 0;
    if (withRest && divisor > 1) {
      rest = _rnd.nextInt(divisor - 1) + 1;
      dividend += rest;
    }
    final answer = withRest ? '$quotient R$rest' : quotient.toString();
    return Exercise(
      id: 'w3_div_${dividend}_$divisor',
      category: ExerciseCategory.wiederholungKlasse3,
      type: ExerciseType.divTensHundredsRest,
      question: 'Berechne: $dividend : $divisor =',
      questionDetail: withRest ? 'Mit Rest (z. B. 17 R2)' : null,
      correctAnswer: answer,
      difficulty: d,
    );
  }

  /// Zahlenrätsel
  Exercise _numberPuzzle(int d) {
    final puzzles = [
      () {
        final x = _rnd.nextInt(50) + 20;
        final add = _rnd.nextInt(40) + 10;
        return Exercise(
          id: 'w3_puzzle_add_$x',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.numberPuzzle,
          question: 'Ich denke mir eine Zahl. Addiere ich $add, erhalte ich ${x + add}. '
              'Welche Zahl habe ich mir gedacht?',
          correctAnswer: x.toString(),
          difficulty: d,
        );
      },
      () {
        final x = _rnd.nextInt(40) + 30;
        final sub = _rnd.nextInt(20) + 5;
        return Exercise(
          id: 'w3_puzzle_sub_$x',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.numberPuzzle,
          question: 'Ich denke mir eine Zahl. Subtrahiere ich $sub, erhalte ich ${x - sub}. '
              'Welche Zahl habe ich mir gedacht?',
          correctAnswer: x.toString(),
          difficulty: d,
        );
      },
      () {
        final x = _rnd.nextInt(15) + 5;
        final mul = [2, 3, 4, 5, 10][_rnd.nextInt(5)];
        return Exercise(
          id: 'w3_puzzle_mul_$x',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.numberPuzzle,
          question: 'Ich denke mir eine Zahl. Multipliziere ich sie mit $mul, erhalte ich ${x * mul}. '
              'Welche Zahl habe ich mir gedacht?',
          correctAnswer: x.toString(),
          difficulty: d,
        );
      },
      () {
        // Rechenquadrat-ähnlich / Lücken
        final a = _rnd.nextInt(30) + 10;
        final b = _rnd.nextInt(30) + 10;
        final c = a + b;
        return Exercise(
          id: 'w3_puzzle_luecke_$a',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.numberPuzzle,
          question: 'Welche Zahl fehlt?\n$a + ? = $c',
          correctAnswer: b.toString(),
          difficulty: d,
        );
      },
    ];
    return puzzles[_rnd.nextInt(puzzles.length)]();
  }

  /// Sachaufgaben (Zahlenraum bis 1000)
  Exercise _sachaufgabeBis1000(int d) {
    final problems = [
      () {
        final price = _rnd.nextInt(8) + 2; // Euro
        final amount = _rnd.nextInt(6) + 3;
        return Exercise(
          id: 'w3_sach_hefte',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.wordProblem,
          question: 'Ein Heft kostet $price €. Wie viel Euro kosten $amount Hefte zusammen?',
          correctAnswer: (price * amount).toString(),
          difficulty: d,
        );
      },
      () {
        final children = _rnd.nextInt(12) + 8;
        final adults = _rnd.nextInt(8) + 4;
        const childP = 3;
        const adultP = 6;
        return Exercise(
          id: 'w3_sach_kino',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.wordProblem,
          question: 'Im Schwimmbad kostet der Eintritt für Kinder $childP € und für Erwachsene $adultP €. '
              'Es kommen $children Kinder und $adults Erwachsene. Wie viel Euro kostet der Eintritt insgesamt?',
          correctAnswer: (children * childP + adults * adultP).toString(),
          difficulty: d,
        );
      },
      () {
        final total = _rnd.nextInt(200) + 300;
        final used = _rnd.nextInt(150) + 50;
        return Exercise(
          id: 'w3_sach_rest',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.wordProblem,
          question: 'In einer Kiste sind $total Äpfel. $used Äpfel werden verkauft. '
              'Wie viele Äpfel sind noch übrig?',
          correctAnswer: (total - used).toString(),
          difficulty: d,
        );
      },
      () {
        final perBox = _rnd.nextInt(8) + 4;
        final boxes = _rnd.nextInt(10) + 5;
        return Exercise(
          id: 'w3_sach_box',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.wordProblem,
          question: 'In jeder Schachtel sind $perBox Stifte. Wie viele Stifte sind in $boxes Schachteln?',
          correctAnswer: (perBox * boxes).toString(),
          difficulty: d,
        );
      },
    ];
    return problems[_rnd.nextInt(problems.length)]();
  }

  /// Umgang mit Geld
  Exercise _moneyHandling(int d) {
    final variants = [
      () {
        final e1 = _rnd.nextInt(5) + 1;
        final c1 = _rnd.nextInt(9) * 10 + 5; // 5,15,25...
        final e2 = _rnd.nextInt(4) + 1;
        final c2 = _rnd.nextInt(9) * 10;
        final totalC = e1 * 100 + c1 + e2 * 100 + c2;
        final te = totalC ~/ 100;
        final tc = totalC % 100;
        return Exercise(
          id: 'w3_geld_add',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.moneyHandling,
          question: 'Wie viel Euro sind $e1,${c1.toString().padLeft(2, '0')} € + $e2,${c2.toString().padLeft(2, '0')} € zusammen?',
          correctAnswer: tc == 0 ? '$te' : '$te,${tc.toString().padLeft(2, '0')}',
          questionDetail: 'Antwort z. B. 7,50 oder 8',
          difficulty: d,
        );
      },
      () {
        final priceE = _rnd.nextInt(8) + 2;
        final priceC = _rnd.nextInt(9) * 10 + 5;
        final pay = priceE + _rnd.nextInt(5) + 2;
        final changeC = pay * 100 - (priceE * 100 + priceC);
        final ce = changeC ~/ 100;
        final cc = changeC % 100;
        return Exercise(
          id: 'w3_geld_wechsel',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.moneyHandling,
          question: 'Ein Artikel kostet $priceE,${priceC.toString().padLeft(2, '0')} €. '
              'Du gibst einen $pay-Euro-Schein. Wie viel Euro bekommst du zurück?',
          correctAnswer: cc == 0 ? '$ce' : '$ce,${cc.toString().padLeft(2, '0')}',
          questionDetail: 'Antwort z. B. 2,50',
          difficulty: d,
        );
      },
      () {
        final items = _rnd.nextInt(4) + 2;
        final priceC = (_rnd.nextInt(6) + 1) * 50; // 50,100,150... cent
        final totalC = items * priceC;
        final te = totalC ~/ 100;
        final tc = totalC % 100;
        final priceStr = priceC >= 100
            ? '${priceC ~/ 100},${(priceC % 100).toString().padLeft(2, '0')}'
            : '0,${priceC.toString().padLeft(2, '0')}';
        return Exercise(
          id: 'w3_geld_mehrere',
          category: ExerciseCategory.wiederholungKlasse3,
          type: ExerciseType.moneyHandling,
          question: 'Ein Radierer kostet $priceStr €. Wie viel Euro kosten $items Radierer?',
          correctAnswer: tc == 0 ? '$te' : '$te,${tc.toString().padLeft(2, '0')}',
          difficulty: d,
        );
      },
    ];
    return variants[_rnd.nextInt(variants.length)]();
  }
}
