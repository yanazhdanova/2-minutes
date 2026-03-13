import 'package:flutter/material.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import 'notif_time_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _problems = <_Problem>[
    _Problem('posture', 'Проблемы с осанкой'),
    _Problem('back', 'Боли в спине и пояснице'),
    _Problem('neck', 'Боли в шее'),
    _Problem('eyes', 'Усталость глаз'),
    _Problem('stress', 'Стресс и тревога'),
    _Problem('focus', 'Трудности с концентрацией'),
    _Problem('energy', 'Нехватка энергии'),
    _Problem('sleep', 'Проблемы со сном'),
  ];

  final Set<String> _selected = {};

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  Future<void> _next() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одну категорию')),
      );
      return;
    }

    await UserPreferences.setSelectedCategories(_selected.toList());

    if (mounted) {
      goTo(context, const NotifTimeScreen());
    }
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

              // Шапка
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
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

              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Выберите, какие\nпроблемы хотите\nисправить',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Список с чекбоксами
              Expanded(
                child: ListView.builder(
                  itemCount: _problems.length,
                  itemBuilder: (context, i) {
                    final p = _problems[i];
                    final isSelected = _selected.contains(p.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _toggle(p.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.grey.shade400
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.label,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                onChanged: (_) => _toggle(p.id),
                                activeColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Текст «список категорий»
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'список категорий',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),

              // Кнопка далее
              SizedBox(
                width: 260,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(width: 1),
                  ),
                  onPressed: _next,
                  child: const Text('Далее'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Problem {
  final String id;
  final String label;
  _Problem(this.id, this.label);
}