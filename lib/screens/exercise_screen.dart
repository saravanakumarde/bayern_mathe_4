import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../models/exercise.dart';
import '../services/exercise_generator.dart';
import '../services/progress_service.dart';

class ExerciseScreen extends StatefulWidget {
  final ExerciseCategory category;
  final int difficulty;
  final String title;

  const ExerciseScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.title,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _generator = ExerciseGenerator();
  final _controller = TextEditingController();
  final _confetti = ConfettiController(duration: const Duration(seconds: 1));

  late Exercise _current;
  int _index = 0;
  int _correct = 0;
  final int _total = 10;
  bool _answered = false;
  bool? _isCorrect;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _nextExercise();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confetti.dispose();
    super.dispose();
  }

  void _nextExercise() {
    setState(() {
      _current = _generator.generate(widget.category, difficulty: widget.difficulty);
      _answered = false;
      _isCorrect = null;
      _selectedOption = null;
      _controller.clear();
    });
  }

  void _check() {
    if (_answered) return;
    final userAnswer = _current.isMultipleChoice
        ? (_selectedOption ?? '')
        : _controller.text.trim();
    if (userAnswer.isEmpty) return;

    final correct = _current.checkAnswer(userAnswer);
    setState(() {
      _answered = true;
      _isCorrect = correct;
      if (correct) {
        _correct++;
        _confetti.play();
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.mediumImpact();
      }
    });
    context.read<ProgressService>().recordAnswer(widget.category, correct);
  }

  void _continue() {
    if (_index + 1 >= _total) {
      _showResult();
    } else {
      setState(() => _index++);
      _nextExercise();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          _correct >= 8 ? 'Super gemacht! 🎉' : _correct >= 5 ? 'Gut geübt! 👍' : 'Weiter üben! 💪',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_correct von $_total richtig',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_correct / _total * 100).toStringAsFixed(0)} %',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Zurück'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _index = 0;
                _correct = 0;
              });
              _nextExercise();
            },
            child: const Text('Noch einmal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_index + (_answered ? 1 : 0)) / _total;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5F7A),
        foregroundColor: Colors.white,
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 6,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aufgabe ${_index + 1} von $_total',
                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Richtig: $_correct',
                        style: const TextStyle(
                          color: Color(0xFF159895),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Question card
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A5F7A).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _typeLabel(_current.type),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A5F7A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _current.question,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                            if (_current.questionDetail != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                _current.questionDetail!,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                            const SizedBox(height: 28),

                            // Answer area
                            if (_current.isMultipleChoice)
                              ..._current.options.map((opt) {
                                final selected = _selectedOption == opt;
                                Color? bg;
                                Color? border;
                                if (_answered) {
                                  if (opt == _current.correctAnswer) {
                                    bg = Colors.green.withOpacity(0.15);
                                    border = Colors.green;
                                  } else if (selected) {
                                    bg = Colors.red.withOpacity(0.12);
                                    border = Colors.red;
                                  }
                                } else if (selected) {
                                  bg = const Color(0xFF1A5F7A).withOpacity(0.12);
                                  border = const Color(0xFF1A5F7A);
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    onTap: _answered
                                        ? null
                                        : () => setState(() => _selectedOption = opt),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bg ?? Colors.grey[50],
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: border ?? Colors.grey[300]!,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        opt,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: selected || (_answered && opt == _current.correctAnswer)
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                            else
                              TextField(
                                controller: _controller,
                                enabled: !_answered,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _check(),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: 'Antwort eingeben…',
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF1A5F7A),
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 16,
                                  ),
                                ),
                              ),

                            // Feedback
                            if (_answered) ...[
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: _isCorrect!
                                      ? Colors.green.withOpacity(0.12)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _isCorrect! ? Icons.check_circle : Icons.cancel,
                                          color: _isCorrect! ? Colors.green : Colors.red,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isCorrect! ? 'Richtig!' : 'Leider falsch',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: _isCorrect! ? Colors.green[800] : Colors.red[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!_isCorrect!) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Richtige Antwort: ${_current.correctAnswer}',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                    if (_current.explanation != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        _current.explanation!,
                                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action button
                  ElevatedButton(
                    onPressed: _answered
                        ? _continue
                        : (_current.isMultipleChoice
                            ? (_selectedOption != null ? _check : null)
                            : _check),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5F7A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    child: Text(
                      _answered
                          ? (_index + 1 >= _total ? 'Ergebnis anzeigen' : 'Weiter')
                          : 'Prüfen',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 20,
              maxBlastForce: 15,
              minBlastForce: 5,
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(ExerciseType type) {
    switch (type) {
      case ExerciseType.oralWrittenAddSub:
        return 'Addition / Subtraktion';
      case ExerciseType.mulTensHundreds:
        return 'Multiplikation (Zehner/Hunderter)';
      case ExerciseType.divTensHundredsRest:
        return 'Division (mit Rest)';
      case ExerciseType.numberPuzzle:
        return 'Zahlenrätsel';
      case ExerciseType.moneyHandling:
        return 'Umgang mit Geld';
      case ExerciseType.addition:
      case ExerciseType.writtenAddition:
        return 'Addition';
      case ExerciseType.subtraction:
      case ExerciseType.writtenSubtraction:
        return 'Subtraktion';
      case ExerciseType.multiplication:
      case ExerciseType.writtenMultiplication:
        return 'Multiplikation';
      case ExerciseType.division:
      case ExerciseType.writtenDivision:
        return 'Division';
      case ExerciseType.placeValue:
        return 'Stellenwert';
      case ExerciseType.compareNumbers:
        return 'Vergleichen';
      case ExerciseType.roundNumbers:
        return 'Runden';
      case ExerciseType.numberSequence:
        return 'Zahlenfolge';
      case ExerciseType.wordProblem:
        return 'Sachaufgabe';
      case ExerciseType.symmetry:
        return 'Symmetrie';
      case ExerciseType.shapes:
        return 'Formen & Körper';
      case ExerciseType.volumeComparison:
        return 'Rauminhalt';
      case ExerciseType.lengthConversion:
        return 'Längen';
      case ExerciseType.massConversion:
        return 'Massen';
      case ExerciseType.timeCalculation:
        return 'Zeit';
      case ExerciseType.moneyCalculation:
        return 'Geld';
      case ExerciseType.volumeConversion:
        return 'Volumen';
      case ExerciseType.dataReading:
        return 'Daten';
      case ExerciseType.probability:
        return 'Wahrscheinlichkeit';
    }
  }
}
