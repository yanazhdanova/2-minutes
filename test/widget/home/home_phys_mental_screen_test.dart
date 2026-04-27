import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/home/home_phys_mental_screen.dart';
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
        const HomePhysMentalScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HomePhysMentalScreen — UI', () {
    testWidgets('показывает заголовок "Выберите тип упражнения"', (
      tester,
    ) async {
      await pumpScreen(tester);
      expect(find.textContaining('Выберите тип'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Физическое"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Физическое'), findsOneWidget);
    });

    testWidgets('показывает подзаголовок физического', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Разминка, растяжка, осанка'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Ментальное"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Ментальное'), findsOneWidget);
    });

    testWidgets('показывает подзаголовок ментального', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Дыхание, концентрация'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Случайное"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Случайное'), findsOneWidget);
    });

    testWidgets('показывает подзаголовок случайного', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Мы выберем за вас'), findsOneWidget);
    });

    testWidgets('показывает иконки для каждого типа', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
      expect(find.byIcon(Icons.self_improvement), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('показывает chevron_right для каждой кнопки', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(3));
    });
  });
}
