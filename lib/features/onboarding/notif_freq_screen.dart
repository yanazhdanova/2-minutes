import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/navigation.dart';
import '../../app/user_preferences.dart';
import '../../app/l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'final_screen.dart';

class NotifFreqScreen extends StatefulWidget {
  const NotifFreqScreen({super.key});
  @override
  State<NotifFreqScreen> createState() => _NotifFreqScreenState();
}

class _NotifFreqScreenState extends State<NotifFreqScreen> {
  String _selected = '01:00';
  List<(String, String)> _options(Tr t) => [('00:30', t.freqEvery30min), ('01:00', t.freqEveryHour), ('02:00', t.freqEvery2hours), ('04:00', t.freqEvery4hours)];

  Future<void> _next() async { await UserPreferences.setNotifFrequency(_selected); if (mounted) goTo(context, const FinalScreen()); }

  @override
  Widget build(BuildContext context) {
    final c = C(context); final t = Tr.of(context); final opts = _options(t);
    return Scaffold(backgroundColor: c.background, body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal), child: Column(children: [
      AppHeader(onBack: () => Navigator.pop(context)), const Spacer(flex: 2),
      Text(t.notifFreqTitle, textAlign: TextAlign.center, style: AppTextStyles.heading2.copyWith(color: c.textPrimary)),
      const SizedBox(height: 36),
      ...opts.map((o) { final sel = _selected == o.$1; return Padding(padding: const EdgeInsets.only(bottom: 12), child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium), onTap: () => setState(() => _selected = o.$1),
        child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), decoration: BoxDecoration(
          color: sel ? c.accentSurface : c.surface, borderRadius: BorderRadius.circular(AppRadius.medium),
          border: sel ? Border.all(color: c.accentLight, width: 1.5) : null,
        ), child: Row(children: [
          Expanded(child: Text(o.$2, style: AppTextStyles.bodyLarge.copyWith(color: sel ? c.accentLight : c.textPrimary))),
          if (sel) Icon(Icons.check_circle, color: c.accentLight, size: 24),
        ])),
      )); }),
      const Spacer(flex: 3),
      OutlineButton(label: t.next, width: 260, onPressed: _next),
      const SizedBox(height: 32),
    ]))));
  }
}