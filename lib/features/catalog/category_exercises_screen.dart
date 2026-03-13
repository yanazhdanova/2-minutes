import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../exercises/domain/exercise_models.dart';

class CategoryExercisesScreen extends StatefulWidget {
  final String categoryId;
  final String title;

  const CategoryExercisesScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<CategoryExercisesScreen> createState() => _CategoryExercisesScreenState();
}

class _CategoryExercisesScreenState extends State<CategoryExercisesScreen> {
  String? _expandedExerciseId;

  void _toggle(String id) {
    setState(() {
      _expandedExerciseId = (_expandedExerciseId == id) ? null : id;
    });
  }

  void _snack(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: repo.exercisesByCategory(widget.categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? const <Exercise>[];
          if (items.isEmpty) {
            return const Center(child: Text('Нет упражнений в этой категории'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final e = items[i];
              final isExpanded = _expandedExerciseId == e.id;

              return _ExerciseExpandableCard(
                title: e.title,
                description: e.description,
                isExpanded: isExpanded,
                onTap: () => _toggle(e.id),
                onDo: () => _snack('Пока без перехода'),
                onFav: () => _snack('Избранное пока не реализовано'),
              );
            },
          );
        },
      ),
    );
  }
}

class _ExerciseExpandableCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onDo;
  final VoidCallback onFav;

  const _ExerciseExpandableCard({
    required this.title,
    required this.description,
    required this.isExpanded,
    required this.onTap,
    required this.onDo,
    required this.onFav,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14);

    return Material(
      color: Colors.grey.shade100,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(isExpanded ? 16 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Плейсхолдер под видео
                      Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Видео (добавишь позже)',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: onDo,
                            child: const Text('Выполнить'),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: onFav,
                            icon: const Icon(Icons.favorite_border),
                            tooltip: 'Избранное',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 180),
                sizeCurve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
