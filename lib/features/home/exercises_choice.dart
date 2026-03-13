import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../../app/main_tab_screen.dart';
import '../exercises/domain/exercise_models.dart';
import '../workout/exercise_screen.dart';
import 'home_phys_mental_screen.dart';

class ExercisesChoiceScreen extends StatefulWidget {
  const ExercisesChoiceScreen({super.key});

  @override
  State<ExercisesChoiceScreen> createState() => _ExercisesChoiceScreenState();
}

class _ExercisesChoiceScreenState extends State<ExercisesChoiceScreen> {

  final List<Exercise?> _slots = [null, null, null];

  bool get _allSelected => _slots.every((e) => e != null);

  Future<void> _pickExercise(int slotIndex) async {
    // Открываем экран выбора типа, ждём результат (Exercise)
    final Exercise? result = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(builder: (_) => const HomePhysMentalScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _slots[slotIndex] = result;
      });
    }
  }

  void _startWorkout() {
    final selected = _slots.whereType<Exercise>().toList();
    goToAndClear(
      context,
      ExerciseScreen(exercises: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => goToAndClear(
                      context,
                      const MainTabScreen(),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '2 минуты',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 32),

              // Три слота
              for (int i = 0; i < 3; i++) ...[
                _ExerciseSlot(
                  index: i + 1,
                  exercise: _slots[i],
                  onTap: () => _pickExercise(i),
                ),
                const SizedBox(height: 16),
              ],

              const Spacer(),

              // Кнопка "Начать"
              SizedBox(
                width: 260,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: _allSelected ? _startWorkout : null,
                  child: const Text('Начать'),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseSlot extends StatelessWidget {
  final int index;
  final Exercise? exercise;
  final VoidCallback onTap;

  const _ExerciseSlot({
    required this.index,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = exercise != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade300 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: Colors.black54, width: 1.5)
              : null,
        ),
        child: Text(
          isSelected ? exercise!.title : '$index упражнение',
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}