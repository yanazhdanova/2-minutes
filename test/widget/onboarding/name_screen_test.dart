import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/onboarding/name_screen.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockExerciseSqliteRepository mockRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockExerciseSqliteRepository();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    final prefs = await createTestPrefsService();
    await tester.pumpWidget(
      wrapWithApp(const NameScreen(), prefs: prefs, exerciseRepo: mockRepo),
    );
    await tester.pumpAndSettle();
  }

  group('NameScreen — UI', () {
    testWidgets('показывает заголовок "Как вас зовут?"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Как вас зовут?'), findsOneWidget);
    });

    testWidgets('показывает поле ввода с hint "Введите имя"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Введите имя'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Далее"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Далее'), findsOneWidget);
    });

    testWidgets('показывает логотип', (tester) async {
      await pumpScreen(tester);
      expect(find.text('2 минуты'), findsOneWidget);
    });
  });

  group('NameScreen — валидация', () {
    testWidgets('кнопка "Далее" отключена при пустом поле', (tester) async {
      await pumpScreen(tester);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('кнопка "Далее" включена после ввода имени', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(find.byType(TextField), 'Анна');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('пробелы не считаются валидным именем', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('NameScreen — навигация', () {
    testWidgets('ввод имени и нажатие "Далее" → переход на CategoriesScreen', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.enterText(find.byType(TextField), 'Анна');
      await tester.pump();

      await tester.tap(find.text('Далее'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Выберите'), findsOneWidget);
    });
  });
}
