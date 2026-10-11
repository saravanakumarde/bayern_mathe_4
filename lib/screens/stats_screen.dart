import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../services/progress_service.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5F7A),
        foregroundColor: Colors.white,
        title: const Text('Statistik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Zurücksetzen',
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Statistik zurücksetzen?'),
                  content: const Text('Alle gespeicherten Ergebnisse werden gelöscht.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abbrechen')),
                    ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Zurücksetzen')),
                  ],
                ),
              );
              if (ok == true) progress.reset();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _StatCard(
            title: 'Gesamt',
            value: '${progress.totalCorrect} / ${progress.totalAnswered}',
            subtitle: progress.totalAnswered > 0
                ? '${(progress.accuracy * 100).toStringAsFixed(1)} % richtig'
                : 'Noch keine Aufgaben gelöst',
            color: const Color(0xFF1A5F7A),
          ),
          const SizedBox(height: 16),
          Text(
            'Nach Lernbereich',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...ExerciseCategory.values.map((cat) {
            final total = progress.categoryTotal[cat.name] ?? 0;
            final correct = progress.categoryCorrect[cat.name] ?? 0;
            final name = _categoryName(cat);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StatCard(
                title: name,
                value: total == 0 ? '–' : '$correct / $total',
                subtitle: total == 0
                    ? 'Noch nicht geübt'
                    : '${(correct / total * 100).toStringAsFixed(0)} %',
                color: _categoryColor(cat),
                compact: true,
              ),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'Hinweis',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Die Übungen orientieren sich am LehrplanPLUS Mathematik für die '
            'Jahrgangsstufen 3/4 der bayerischen Grundschule '
            '(Zahlenraum bis 1 000 000, vier Grundrechenarten, Größen, '
            'Raum & Form, Daten & Zufall).',
            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  String _categoryName(ExerciseCategory cat) {
    switch (cat) {
      case ExerciseCategory.wiederholungKlasse3:
        return '1. Lernstandserhebung (bis 1000)';
      case ExerciseCategory.zahlenUndOperationen:
        return 'Zahlen & Operationen';
      case ExerciseCategory.raumUndForm:
        return 'Raum & Form';
      case ExerciseCategory.groessenUndMessen:
        return 'Größen & Messen';
      case ExerciseCategory.datenUndZufall:
        return 'Daten & Zufall';
    }
  }

  Color _categoryColor(ExerciseCategory cat) {
    switch (cat) {
      case ExerciseCategory.wiederholungKlasse3:
        return const Color(0xFFE85D04);
      case ExerciseCategory.zahlenUndOperationen:
        return const Color(0xFF1A5F7A);
      case ExerciseCategory.raumUndForm:
        return const Color(0xFF159895);
      case ExerciseCategory.groessenUndMessen:
        return const Color(0xFF57C5B6);
      case ExerciseCategory.datenUndZufall:
        return const Color(0xFF002B5B);
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final bool compact;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: compact ? 15 : 16)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: compact ? 18 : 22,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
