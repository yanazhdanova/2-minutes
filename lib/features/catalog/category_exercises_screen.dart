import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../app/app_theme.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../exercises/domain/exercise_models.dart';

class CategoryExercisesScreen extends StatefulWidget {
  final String categoryId; final String title;
  const CategoryExercisesScreen({super.key, required this.categoryId, required this.title});
  @override
  State<CategoryExercisesScreen> createState() => _State();
}

class _State extends State<CategoryExercisesScreen> {
  String? _expandedId;
  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).exerciseRepo; final c = C(context); final t = Tr.of(context);
    return Scaffold(backgroundColor: c.background, body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal), child: AppHeader(onBack: () => Navigator.pop(context))),
      const SizedBox(height: 16),
      Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal), child: Text(widget.title, style: AppTextStyles.heading2.copyWith(color: c.textPrimary))),
      const SizedBox(height: 24),
      Expanded(child: FutureBuilder<List<Exercise>>(future: repo.exercisesByCategory(widget.categoryId), builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator(color: c.accentLight));
        final items = snap.data ?? [];
        if (items.isEmpty) return Center(child: Text(t.noExercisesInCategory, style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary)));
        return ListView.separated(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal), itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) { final e = items[i]; final exp = _expandedId == e.id;
            return InkWell(onTap: () => setState(() => _expandedId = exp ? null : e.id), borderRadius: BorderRadius.circular(AppRadius.medium),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: exp ? c.accentSurface : c.surface, borderRadius: BorderRadius.circular(AppRadius.medium), border: exp ? Border.all(color: c.accentLight, width: 1.5) : null),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Expanded(child: Text(e.title, style: AppTextStyles.bodyLarge.copyWith(color: exp ? c.accentLight : c.textPrimary))),
                        AnimatedRotation(turns: exp ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: Icon(Icons.keyboard_arrow_down, color: exp ? c.accentLight : c.textSecondary))]),
                      AnimatedCrossFade(firstChild: const SizedBox.shrink(), secondChild: Padding(padding: const EdgeInsets.only(top: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(height: 160, width: double.infinity, decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(AppRadius.small)), alignment: Alignment.center,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.play_circle_outline, color: c.textSecondary, size: 48), const SizedBox(height: 8), Text(t.video, style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary))])),
                        const SizedBox(height: 16), Text(e.description, style: AppTextStyles.body.copyWith(color: c.textPrimary)),
                        const SizedBox(height: 8), Text(t.durationSec(e.defaultDurationSec), style: AppTextStyles.bodySmall.copyWith(color: c.textSecondary)),
                      ])), crossFadeState: exp ? CrossFadeState.showSecond : CrossFadeState.showFirst, duration: const Duration(milliseconds: 200), sizeCurve: Curves.easeOut),
                    ])));
            });
      })),
    ])));
  }
}