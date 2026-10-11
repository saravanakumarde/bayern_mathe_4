import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../services/progress_service.dart';
import 'exercise_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const categories = [
    _Cat(
      category: ExerciseCategory.wiederholungKlasse3,
      title: '1. Lernstandserhebung',
      subtitle: 'Wiederholung 3. Klasse\nZahlenraum bis 1000',
      icon: Icons.assignment_rounded,
      color: Color(0xFFE85D04),
      isHighlight: true,
    ),
    _Cat(
      category: ExerciseCategory.zahlenUndOperationen,
      title: 'Zahlen & Operationen',
      subtitle: 'Rechnen bis 1 000 000\nEinmaleins · Schriftliche Verfahren',
      icon: Icons.calculate_rounded,
      color: Color(0xFF1A5F7A),
    ),
    _Cat(
      category: ExerciseCategory.raumUndForm,
      title: 'Raum & Form',
      subtitle: 'Symmetrie · Würfel & Quader\nFlächen und Körper',
      icon: Icons.architecture_rounded,
      color: Color(0xFF159895),
    ),
    _Cat(
      category: ExerciseCategory.groessenUndMessen,
      title: 'Größen & Messen',
      subtitle: 'Längen · Massen · Zeit\nGeld · Volumen',
      icon: Icons.straighten_rounded,
      color: Color(0xFF57C5B6),
    ),
    _Cat(
      category: ExerciseCategory.datenUndZufall,
      title: 'Daten & Zufall',
      subtitle: 'Diagramme lesen\nWahrscheinlichkeiten',
      icon: Icons.bar_chart_rounded,
      color: Color(0xFF002B5B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A5F7A),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bayern Mathe 4',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF1A5F7A),
                                    ),
                              ),
                              Text(
                                'Übungen nach LehrplanPLUS',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const StatsScreen()),
                          ),
                          icon: const Icon(Icons.insights_rounded),
                          tooltip: 'Statistik',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Progress card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A5F7A), Color(0xFF159895)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A5F7A).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dein Fortschritt',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${progress.totalCorrect} / ${progress.totalAnswered} richtig',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (progress.totalAnswered > 0) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    '${(progress.accuracy * 100).toStringAsFixed(0)} % Trefferquote',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          CircularProgressIndicator(
                            value: progress.totalAnswered == 0 ? 0 : progress.accuracy,
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                            strokeWidth: 7,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Lernbereiche wählen',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Basierend auf dem bayerischen LehrplanPLUS Mathematik 3/4',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cat = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _CategoryCard(cat: cat),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _Cat {
  final ExerciseCategory category;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isHighlight;

  const _Cat({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isHighlight = false,
  });
}

class _CategoryCard extends StatelessWidget {
  final _Cat cat;

  const _CategoryCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    final bg = cat.isHighlight ? cat.color.withOpacity(0.08) : Colors.white;
    return Material(
      color: bg,
      elevation: cat.isHighlight ? 3 : 2,
      shadowColor: cat.color.withOpacity(0.25),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showDifficultyDialog(context),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cat.isHighlight ? cat.color.withOpacity(0.45) : cat.color.withOpacity(0.15),
              width: cat.isHighlight ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(cat.isHighlight ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(cat.icon, color: cat.color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cat.isHighlight)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cat.color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'VORBEREITUNG',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      cat.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: cat.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cat.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cat.color.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Schwierigkeit wählen',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                cat.title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _DifficultyButton(
                label: 'Leicht',
                subtitle: 'Grundlagen & Einmaleins',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(
                        category: cat.category,
                        difficulty: 1,
                        title: cat.title,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _DifficultyButton(
                label: 'Mittel',
                subtitle: 'Größere Zahlen & Sachaufgaben',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(
                        category: cat.category,
                        difficulty: 2,
                        title: cat.title,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _DifficultyButton(
                label: 'Schwer',
                subtitle: 'Zahlenraum bis 1 000 000',
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseScreen(
                        category: cat.category,
                        difficulty: 3,
                        title: cat.title,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.12),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                Text(subtitle, style: TextStyle(fontSize: 13, color: color.withOpacity(0.8))),
              ],
            ),
          ),
          Icon(Icons.play_arrow_rounded, color: color),
        ],
      ),
    );
  }
}
