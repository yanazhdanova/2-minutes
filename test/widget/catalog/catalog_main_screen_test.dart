import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/catalog/catalog_main_screen.dart';
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
      wrapWithApp(
        const CatalogMainScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CatalogMainScreen — UI', () {
    testWidgets('показывает заголовок "Каталог"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Каталог'), findsOneWidget);
    });

    testWidgets('показывает подзаголовок', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Все упражнения по категориям'), findsOneWidget);
    });

    testWidgets('показывает карточку "Физические"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Физические'), findsOneWidget);
      expect(find.text('Разминка, растяжка, осанка'), findsOneWidget);
    });

    testWidgets('показывает карточку "Ментальные"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Ментальные'), findsOneWidget);
      expect(find.text('Дыхание, концентрация, релаксация'), findsOneWidget);
    });

    testWidgets('показывает иконки fitness и self_improvement', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
      expect(find.byIcon(Icons.self_improvement), findsOneWidget);
    });

    testWidgets('показывает логотип', (tester) async {
      await pumpScreen(tester);
      expect(find.text('2 минуты'), findsOneWidget);
    });
  });
}
