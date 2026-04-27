import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/settings/program_settings_screen.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    Map<String, Object> initialPrefs = const {},
  }) async {
    final prefs = await createTestPrefsService(initialPrefs);
    await tester.pumpWidget(
      wrapWithApp(
        const ProgramSettingsScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ProgramSettingsScreen — UI', () {
    testWidgets('показывает заголовок "Моя программа"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Моя программа'), findsOneWidget);
    });

    testWidgets('показывает подзаголовок', (tester) async {
      await pumpScreen(tester);
      expect(
        find.text('Выберите проблемы, которые хотите решать'),
        findsOneWidget,
      );
    });

    testWidgets('показывает первые видимые проблемы', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Проблемы с осанкой'), findsOneWidget);
      expect(find.text('Боли в спине и пояснице'), findsOneWidget);
      expect(find.text('Боли в шее'), findsOneWidget);
      expect(find.text('Усталость глаз'), findsOneWidget);
    });

    testWidgets('показывает остальные проблемы при скролле', (tester) async {
      await pumpScreen(tester);

      await tester.scrollUntilVisible(
        find.text('Проблемы со сном'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Проблемы со сном'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('ProgramSettingsScreen — загрузка из prefs', () {
    testWidgets('отображает ранее сохранённые категории', (tester) async {
      await pumpScreen(
        tester,
        initialPrefs: {
          'selected_categories': ['neck', 'eyes'],
        },
      );
      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });
  });

  group('ProgramSettingsScreen — выбор/отмена', () {
    testWidgets('тап на проблему выделяет её', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Боли в шее'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('кнопка "Сохранить" появляется после изменения', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.text('Сохранить'), findsNothing);

      await tester.tap(find.text('Боли в шее'));
      await tester.pumpAndSettle();

      expect(find.text('Сохранить'), findsOneWidget);
    });
  });
}
