import 'package:flutter/material.dart';

/// Открывает экран поверх текущего с помощью Navigator.push.
/// Добавляет новый маршрут в стек - кнопка «назад» вернёт на предыдущий экран.
/// @param context BuildContext для доступа к Navigator.
/// @param screen Виджет нового экрана.
void goTo(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

/// Заменяет текущий экран новым с помощью Navigator.pushReplacement.
/// Убирает текущий маршрут из стека и ставит новый на его место.
/// Кнопка «назад» перейдёт к экрану, который был до замённого.
/// @param context BuildContext для доступа к Navigator.
/// @param screen Виджет нового экрана.
void goToReplace(BuildContext context, Widget screen) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
}

/// Очищает весь стек навигации и открывает экран как единственный корневой.
/// Используется при переходах, откуда нет возврата: после логина - главный экран,
/// после тренировки - экран завершения. Предикат (_) => false удаляет все маршруты.
/// @param context BuildContext для доступа к Navigator.
/// @param screen Виджет нового корневого экрана.
void goToAndClear(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => screen),
    (_) => false,
  );
}

/// Очищает стек и открывает экран с коротким fade-переходом.
/// Используется после фоновой подготовки данных, чтобы новый экран появлялся
/// уже в финальной теме/локали без слайда и промежуточных скачков.
void goToAndClearFade(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (_, _, _) => screen,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    ),
    (_) => false,
  );
}

/// Очищает весь стек навигации и открывает экран без анимации.
/// Используется там, где переходы между завершёнными сценариями не должны
/// выглядеть как движение вперёд или назад.
void goToAndClearNoAnimation(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (_, _, _) => screen,
      transitionsBuilder: (_, _, _, child) => child,
    ),
    (_) => false,
  );
}
