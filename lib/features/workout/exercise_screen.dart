import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../exercises/domain/exercise_models.dart';
import 'end_of_the_workout_screen.dart';

class ExerciseScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const ExerciseScreen({super.key, required this.exercises});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late int _totalSeconds;
  int _currentIndex = 0;
  bool _isPaused = false;
  bool _isFavorite = false;

  Exercise get _exercise => widget.exercises[_currentIndex];

  @override
  void initState() {
    super.initState();
    _totalSeconds = _exercise.defaultDurationSec;
    _initTimer();
  }

  void _initTimer() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalSeconds),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        _onExerciseDone();
      }
    });
    _controller.forward();
    _isPaused = false;
  }

  void _togglePause() {
    setState(() {
      if (_isPaused) {
        _controller.forward();
      } else {
        _controller.stop();
      }
      _isPaused = !_isPaused;
    });
  }

  void _adjustTime(int delta) {
    setState(() {
      final currentRemaining = _remainingSeconds;
      final newRemaining = (currentRemaining + delta).clamp(1, _totalSeconds);

      _controller.stop();
      final progress = 1.0 - (newRemaining / _totalSeconds);
      _controller.value = progress.clamp(0.0, 1.0);

      if (!_isPaused) _controller.forward();
    });
  }

  int get _remainingSeconds =>
      (_totalSeconds * (1.0 - _controller.value)).ceil();

  String get _timeString {
    final s = _remainingSeconds;
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _onExerciseDone() {
    if (_currentIndex >= widget.exercises.length - 1) {
      goToAndClear(context, const EndOfTheWorkoutScreen());
    } else {
      _controller.dispose();
      _currentIndex++;
      _totalSeconds = _exercise.defaultDurationSec;
      _initTimer();
      setState(() {});
    }
  }

  void _skipExercise() {
    _controller.stop();
    _onExerciseDone();
  }

  void _endWorkout() {
    _controller.stop();
    goToAndClear(context, const EndOfTheWorkoutScreen());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
              child: Column(
                children: [
                  const SizedBox(height: 18),

                  const Text('2 минуты', style: AppTextStyles.logo),

                  const Spacer(flex: 2),


                  Text(
                    _timeString,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),

                  const SizedBox(height: 32),


                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: _TimerPainter(progress: _controller.value),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _exercise.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),


                  if (!_isPaused)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _exercise.description,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const Spacer(flex: 1),


                  if (!_isPaused) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _RoundButton(
                          label: '-15',
                          onTap: () => _adjustTime(15),
                        ),
                        _RoundButton(
                          label: 'пауза',
                          onTap: _togglePause,
                          isPrimary: true,
                        ),
                        _RoundButton(
                          label: '+15',
                          onTap: () => _adjustTime(-15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _RoundButton(
                      label: '♡',
                      onTap: () => setState(() => _isFavorite = !_isFavorite),
                      isSmall: true,
                      filled: _isFavorite,
                    ),
                  ],


                  if (_isPaused) ...[
                    _PauseButton(
                      label: 'Продолжить',
                      onTap: _togglePause,
                      isPrimary: true,
                    ),
                    const SizedBox(height: 12),
                    _PauseButton(
                      label: 'Пропустить упражнение',
                      onTap: _skipExercise,
                    ),
                    const SizedBox(height: 12),
                    _PauseButton(
                      label: 'Закончить тренировку',
                      onTap: _endWorkout,
                      isDestructive: true,
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSmall;
  final bool filled;
  final bool isPrimary;

  const _RoundButton({
    required this.label,
    required this.onTap,
    this.isSmall = false,
    this.filled = false,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmall ? 48.0 : 64.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary
              ? AppColors.accent
              : (filled ? AppColors.accent : AppColors.surface),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmall ? 18 : 13,
            fontWeight: FontWeight.w500,
            color: (isPrimary || filled) ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isDestructive;

  const _PauseButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isPrimary
          ? ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
        child: Text(label, style: AppTextStyles.buttonLarge.copyWith(color: AppColors.white)),
      )
          : OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDestructive ? AppColors.error : AppColors.textPrimary,
          side: BorderSide(
            color: isDestructive ? AppColors.error : AppColors.border,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;

  _TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 8.0;


    final bgPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);


    final progressPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * (1.0 - progress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerPainter old) => old.progress != progress;
}