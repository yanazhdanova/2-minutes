import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/navigation.dart';

void main() {
  group('goTo', () {
    testWidgets('открывает новый экран', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  goTo(context, const Scaffold(body: Text('Новый экран'))),
              child: const Text('Перейти'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Перейти'));
      await tester.pumpAndSettle();

      expect(find.text('Новый экран'), findsOneWidget);
    });

    testWidgets('можно вернуться назад', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => goTo(
                  context,
                  Scaffold(
                    body: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Назад'),
                    ),
                  ),
                ),
                child: const Text('Главный'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Главный'));
      await tester.pumpAndSettle();
      expect(find.text('Назад'), findsOneWidget);

      await tester.tap(find.text('Назад'));
      await tester.pumpAndSettle();
      expect(find.text('Главный'), findsOneWidget);
    });
  });

  group('goToReplace', () {
    testWidgets('заменяет текущий экран', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => goToReplace(
                context,
                const Scaffold(body: Text('Заменённый экран')),
              ),
              child: const Text('Заменить'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Заменить'));
      await tester.pumpAndSettle();

      expect(find.text('Заменённый экран'), findsOneWidget);
      expect(find.text('Заменить'), findsNothing);
    });
  });

  group('goToAndClear', () {
    testWidgets('очищает стек и открывает экран', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  goTo(
                    context,
                    Builder(
                      builder: (ctx) => Scaffold(
                        body: ElevatedButton(
                          onPressed: () => goToAndClear(
                            ctx,
                            const Scaffold(body: Text('Финальный')),
                          ),
                          child: const Text('Очистить стек'),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Первый'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Первый'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Очистить стек'));
      await tester.pumpAndSettle();

      expect(find.text('Финальный'), findsOneWidget);
      expect(find.text('Первый'), findsNothing);
      expect(find.text('Очистить стек'), findsNothing);
    });
  });
}
