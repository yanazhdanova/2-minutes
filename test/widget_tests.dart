import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/app/app_theme.dart';
import 'package:two_mins/shared/widgets.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('отображает label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(label: 'Начать', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Начать'), findsOneWidget);
    });

    testWidgets('вызывает onPressed при нажатии', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Нажми',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Нажми'));
      expect(pressed, isTrue);
    });

    testWidgets('не реагирует если onPressed == null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(label: 'Disabled', onPressed: null),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('показывает индикатор загрузки', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Загрузка',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Загрузка'), findsNothing);
    });
  });

  group('OutlineButton', () {
    testWidgets('отображает label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineButton(label: 'Далее', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Далее'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });

  group('AppHeader', () {
    testWidgets('показывает логотип "2 минуты"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppHeader()),
        ),
      );

      expect(find.text('2 минуты'), findsOneWidget);
    });

    testWidgets('показывает кнопку назад если onBack задан', (tester) async {
      var backPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppHeader(onBack: () => backPressed = true),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(backPressed, isTrue);
    });

    testWidgets('не показывает кнопку назад без onBack', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppHeader()),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });
  });

  group('AppTextField', () {
    testWidgets('отображает hint текст', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(hintText: 'Email'),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('принимает ввод текста', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(controller: controller, hintText: 'Имя'),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Иван');
      expect(controller.text, 'Иван');

      controller.dispose();
    });

    testWidgets('скрывает текст при obscureText: true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(hintText: 'Пароль', obscureText: true),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });
  });

  group('AppListTile', () {
    testWidgets('отображает title и subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppListTile(
              title: 'Шея',
              subtitle: '3 упражнения',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Шея'), findsOneWidget);
      expect(find.text('3 упражнения'), findsOneWidget);
    });

    testWidgets('применяет стиль selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppListTile(
              title: 'Выбрано',
              selected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Проверяем что цвет текста = accent при selected
      final text = tester.widget<Text>(find.text('Выбрано'));
      expect(
        (text.style?.color),
        AppColors.accent,
      );
    });
  });

  group('PremiumIcon', () {
    testWidgets('отображает иконку и реагирует на нажатие', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumIcon(onTap: () => tapped = true),
          ),
        ),
      );

      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);

      await tester.tap(find.byType(PremiumIcon));
      expect(tapped, isTrue);
    });
  });
}