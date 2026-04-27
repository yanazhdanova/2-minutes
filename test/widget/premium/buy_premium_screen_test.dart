import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_mins/features/premium/buy_premium_screen.dart';
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
        const BuyPremiumScreen(),
        prefs: prefs,
        exerciseRepo: mockRepo,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('BuyPremiumScreen — UI', () {
    testWidgets('показывает заголовок "Премиум"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Премиум'), findsOneWidget);
    });

    testWidgets('показывает описание', (tester) async {
      await pumpScreen(tester);
      expect(find.textContaining('\$1'), findsOneWidget);
    });

    testWidgets('показывает кнопку "Купить"', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Купить'), findsOneWidget);
    });

    testWidgets('показывает иконку premium', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    testWidgets('показывает кнопку назад', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('BuyPremiumScreen — действия', () {
    testWidgets('нажатие "Купить" показывает snackbar "Скоро будет доступно"', (
      tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Купить'));
      await tester.pumpAndSettle();

      expect(find.text('Скоро будет доступно'), findsOneWidget);
    });
  });
}
