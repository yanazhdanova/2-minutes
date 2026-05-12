import 'package:flutter/material.dart';
import 'app_scope.dart';
import 'app_theme.dart';
import 'l10n/app_localizations.dart';
import '../features/home/home_main_screen.dart';
import '../features/catalog/catalog_main_screen.dart';
import '../features/settings/settings_main_screen.dart';
import '../shared/tutorial_overlay.dart';

/// Главный экран приложения с нижней навигацией из трёх вкладок:
/// Главная (HomeMainScreen), Каталог (CatalogMainScreen), Настройки (SettingsMainScreen).
/// Использует IndexedStack для сохранения состояния каждой вкладки при переключении.
/// BottomNavigationBar стилизован под тему приложения с акцентным цветом для выбранного элемента.
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});
  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  bool _showTutorial = false;
  final _tabs = [
    const HomeMainScreen(),
    const CatalogMainScreen(),
    const SettingsMainScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = AppScope.of(context).prefs;
      if (!prefs.tutorialHomeSeen) {
        setState(() => _showTutorial = true);
      }
    });
  }

  void _dismissTutorial() {
    AppScope.of(context).prefs.setTutorialHomeSeen();
    setState(() => _showTutorial = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = C(context);
    final t = Tr.of(context);
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _tabs),
          if (_showTutorial)
            TutorialOverlay(
              icon: Icons.rocket_launch,
              title: t.tutorialHomeTitle,
              body: t.tutorialHomeBody,
              onDismiss: _dismissTutorial,
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border, width: 1)),
        ),

        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: c.background,
          selectedItemColor: c.accentLight,
          unselectedItemColor: c.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),

          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),

          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: t.navHome,
            ),

            BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view_outlined),
              activeIcon: const Icon(Icons.grid_view),
              label: t.navCatalog,
            ),

            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: t.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
