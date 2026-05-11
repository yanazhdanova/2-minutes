import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/main_tab_screen.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';

class EndOfTheWorkoutScreen extends StatefulWidget {
  final int exerciseCount;
  final int durationSeconds;

  const EndOfTheWorkoutScreen({
    super.key,
    required this.exerciseCount,
    required this.durationSeconds,
  });

  @override
  State<EndOfTheWorkoutScreen> createState() => _EndOfTheWorkoutScreenState();
}

class _EndOfTheWorkoutScreenState extends State<EndOfTheWorkoutScreen> {
  final _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);

    try {
      final boundary = _cardKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/2min_workout.png');
      await file.writeAsBytes(bytes);

      final t = Tr.of(context);
      final duration = t.formatDuration(widget.durationSeconds);
      final gender = AppScope.of(context).userData.gender;
      final text = t.shareCardResult(widget.exerciseCount, duration, gender: gender);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: text,
        ),
      );
    } catch (_) {
      // Share cancelled or failed — ignore
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    final duration = t.formatDuration(widget.durationSeconds);
    final gender = AppScope.of(context).userData.gender;

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: Padding(
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

                  const Spacer(flex: 3),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: c.accentSurface,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(Icons.check_circle, color: c.accentLight, size: 56),
                  ),

                  const SizedBox(height: 40),
                  Text(
                    t.workoutDoneTitle,
                    style: AppTextStyles.heading1.copyWith(color: c.textPrimary),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    t.workoutDoneSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: c.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(flex: 2),
                  PrimaryButton(
                    label: t.shareButton,
                    width: double.infinity,
                    height: 64,
                    isLoading: _sharing,
                    onPressed: _share,
                  ),

                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: t.goHome,
                    width: double.infinity,
                    height: 64,
                    onPressed: () =>
                        goToAndClearNoAnimation(context, const MainTabScreen()),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Карточка для скриншота — за пределами экрана, но отрисовывается
          Positioned(
            left: -1000,
            top: -1000,
            child: RepaintBoundary(
              key: _cardKey,
              child: _ShareCard(
                exerciseCount: widget.exerciseCount,
                duration: duration,
                gender: gender,
                colors: c,
                tr: t,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Квадратная карточка для шаринга, рендерится оффскрин.
class _ShareCard extends StatelessWidget {
  final int exerciseCount;
  final String duration;
  final String gender;
  final ResolvedColors colors;
  final Tr tr;

  const _ShareCard({
    required this.exerciseCount,
    required this.duration,
    required this.gender,
    required this.colors,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 400,
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.accentSurface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.check_circle,
                color: colors.accentLight,
                size: 40,
              ),
            ),

            const SizedBox(height: 24),
            Text(
              tr.shareCardTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2.copyWith(color: colors.textPrimary),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: colors.accentSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.accentLight, width: 1.5),
              ),
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colors.accentLight,
                    wordSpacing: 2,
                  ),
                  children: [
                    TextSpan(text: '${tr.shareCardResultPrefix(exerciseCount, duration, gender: gender)} '),
                    TextSpan(
                      text: '2mins',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: colors.accentLight,
                        fontWeight: FontWeight.w800,
                        wordSpacing: 2,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
