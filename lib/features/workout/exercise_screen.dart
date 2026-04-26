import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/l10n/app_localizations.dart';
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
    _controller.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        _onDone();
      }
    });
    _controller.forward();
    _isPaused = false;
  }

  void _togglePause() {
    setState(() {
      _isPaused ? _controller.forward() : _controller.stop();
      _isPaused = !_isPaused;
    });
  }

  void _adjustTime(int delta) {
    setState(() {
      final rem = (_totalSeconds * (1.0 - _controller.value)).ceil();
      final nr = (rem + delta).clamp(1, _totalSeconds);
      _controller.stop();
      _controller.value = (1.0 - (nr / _totalSeconds)).clamp(0.0, 1.0);
      if (!_isPaused) _controller.forward();
    });
  }

  int get _remaining => (_totalSeconds * (1.0 - _controller.value)).ceil();
  String get _timeStr =>
      '${(_remaining ~/ 60).toString().padLeft(2, '0')}:${(_remaining % 60).toString().padLeft(2, '0')}';

  void _onDone() {
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

  void _skip() {
    _controller.stop();
    _onDone();
  }

  void _end() {
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
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),

            child: Column(
              children: [
                const SizedBox(height: 18),
                Text(
                  t.appName,
                  style: AppTextStyles.logo.copyWith(color: c.textPrimary),
                ),
                const Spacer(flex: 2),
                Text(
                  _timeStr,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w300,
                    color: c.textPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CustomPaint(
                    painter: _TimerPainter(
                      progress: _controller.value,
                      trackColor: c.surface,
                      progressColor: c.accentLight,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _exercise.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: c.textPrimary,
                          ),
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
                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                const Spacer(flex: 1),
                if (!_isPaused) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Round(
                        label: '-15',
                        onTap: () => _adjustTime(15),
                        bg: c.surface,
                        fg: c.textPrimary,
                      ),
                      _Round(
                        label: t.pause,
                        onTap: _togglePause,
                        bg: c.accent,
                        fg: c.white,
                      ),
                      _Round(
                        label: '+15',
                        onTap: () => _adjustTime(-15),
                        bg: c.surface,
                        fg: c.textPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Round(
                    label: '♡',
                    onTap: () => setState(() => _isFavorite = !_isFavorite),
                    bg: _isFavorite ? c.accent : c.surface,
                    fg: _isFavorite ? c.white : c.textPrimary,
                    small: true,
                  ),
                ],

                if (_isPaused) ...[
                  _PauseBtn(
                    label: t.continueWorkout,
                    onTap: _togglePause,
                    bg: c.accent,
                    fg: c.white,
                  ),

                  const SizedBox(height: 12),
                  _PauseBtn(
                    label: t.skipExercise,
                    onTap: _skip,
                    borderColor: c.border,
                    fg: c.textPrimary,
                  ),

                  const SizedBox(height: 12),
                  _PauseBtn(
                    label: t.endWorkout,
                    onTap: _end,
                    borderColor: c.error,
                    fg: c.error,
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Round extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color bg;
  final Color fg;
  final bool small;
  const _Round({
    required this.label,
    required this.onTap,
    required this.bg,
    required this.fg,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final sz = small ? 48.0 : 64.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sz,
        height: sz,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: small ? 18 : 13,
            fontWeight: FontWeight.w500,
            color: fg,
          ),
        ),
      ),
    );
  }
}

class _PauseBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? bg;
  final Color fg;
  final Color? borderColor;
  const _PauseBtn({
    required this.label,
    required this.onTap,
    this.bg,
    required this.fg,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: bg != null

          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                foregroundColor: fg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),
              child: Text(
                label,
                style: AppTextStyles.buttonLarge.copyWith(color: fg),
              ),
            )

          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: fg,
                side: BorderSide(color: borderColor ?? fg, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),

              child: Text(
                label,
                style: AppTextStyles.button.copyWith(color: fg),
              ),
            ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  _TimerPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * (1.0 - progress),
      false,
      Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TimerPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}
