import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/shared/widgets.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('отображает текст', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const Scaffold(body: PrimaryButton(label: 'Нажми'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Нажми'), findsOneWidget);
    });

    testWidgets('включён когда onPressed не null', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(
            body: PrimaryButton(label: 'Нажми', onPressed: () => tapped = true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Нажми'));
      expect(tapped, true);
    });

    testWidgets('отключён когда onPressed == null', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Scaffold(body: PrimaryButton(label: 'Нажми', onPressed: null)),
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('показывает CircularProgressIndicator при isLoading', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(
            body: PrimaryButton(
              label: 'Загрузка',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Загрузка'), findsNothing);
    });

    testWidgets('не вызывает onPressed при isLoading', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(
            body: PrimaryButton(
              label: 'Загрузка',
              isLoading: true,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, false);
    });

    testWidgets('использует заданную ширину', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(
            body: PrimaryButton(label: 'Тест', width: 260, onPressed: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 260);
    });
  });

  group('OutlineButton', () {
    testWidgets('отображает текст', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const Scaffold(body: OutlineButton(label: 'Далее'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Далее'), findsOneWidget);
    });

    testWidgets('реагирует на тап', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(
            body: OutlineButton(label: 'Далее', onPressed: () => tapped = true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Далее'));
      expect(tapped, true);
    });

    testWidgets('использует OutlinedButton стиль', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(
            body: OutlineButton(label: 'Далее', onPressed: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });

  group('SecondaryButton', () {
    testWidgets('отображает текст', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Scaffold(body: SecondaryButton(label: 'Вторичная')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Вторичная'), findsOneWidget);
    });
  });

  group('AppTextField', () {
    testWidgets('отображает hint text', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Scaffold(body: AppTextField(hintText: 'Введите текст')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Введите текст'), findsOneWidget);
    });

    testWidgets('принимает ввод текста', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrapWithTheme(Scaffold(body: AppTextField(controller: controller))),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Тестовый текст');
      expect(controller.text, 'Тестовый текст');
    });

    testWidgets('obscureText скрывает текст', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Scaffold(
            body: AppTextField(obscureText: true, hintText: 'Пароль'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('вызывает onChanged при изменении текста', (tester) async {
      String? changedValue;
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(body: AppTextField(onChanged: (v) => changedValue = v)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test');
      expect(changedValue, 'test');
    });
  });

  group('AppHeader', () {
    testWidgets('отображает логотип "2 минуты"', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const Scaffold(body: AppHeader())));
      await tester.pumpAndSettle();

      expect(find.text('2 минуты'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад если onBack задан', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(Scaffold(body: AppHeader(onBack: () {}))),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('вызывает onBack при нажатии', (tester) async {
      bool backPressed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          Scaffold(body: AppHeader(onBack: () => backPressed = true)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(backPressed, true);
    });

    testWidgets('не показывает кнопку назад без onBack', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const Scaffold(body: AppHeader())));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });
  });

  group('PremiumIcon', () {
    testWidgets('отображает иконку премиума', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const Scaffold(body: PremiumIcon())),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    testWidgets('вызывает onTap при нажатии', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(Scaffold(body: PremiumIcon(onTap: () => tapped = true))),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, true);
    });
  });
}
