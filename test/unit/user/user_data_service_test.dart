import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_mins/features/user/user_data_service.dart';

void main() {
  const uid = 'test_user_123';
  late FakeFirebaseFirestore fakeFirestore;
  late UserDataService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = UserDataService(
      firestore: fakeFirestore,
      uidProvider: () => uid,
    );
  });

  /// Хелпер: читает документ пользователя из фейкового Firestore.
  Future<Map<String, dynamic>?> readDoc() async {
    final snap = await fakeFirestore.collection('users').doc(uid).get();
    return snap.data();
  }

  group('init', () {
    test('создаёт документ с дефолтами если документа нет', () async {
      await service.init();

      final data = await readDoc();
      expect(data, isNotNull);
      expect(data!['userName'], '');
      expect(data['onboardingDone'], false);
      expect(data['selectedCategories'], <String>[]);
      expect(data['favoriteIds'], <String>[]);
      expect(data['stats']['totalWorkouts'], 0);
      expect(data['stats']['streakDays'], 0);
    });

    test('загружает существующий документ в кэш', () async {
      await fakeFirestore.collection('users').doc(uid).set({
        'userName': 'Анна',
        'onboardingDone': true,
        'selectedCategories': ['neck', 'back'],
        'favoriteIds': ['ex_01'],
        'stats': {
          'totalWorkouts': 5,
          'totalExercises': 15,
          'totalSeconds': 600,
          'streakDays': 3,
          'lastWorkoutDate': '2026-04-26',
        },
      });

      await service.init();

      expect(service.userName, 'Анна');
      expect(service.isOnboardingDone, true);
      expect(service.selectedCategories, ['neck', 'back']);
      expect(service.favoriteIds, ['ex_01']);
      expect(service.totalWorkouts, 5);
      expect(service.totalExercises, 15);
      expect(service.totalSeconds, 600);
      expect(service.streakDays, 3);
    });

    test('дефолтные значения до вызова init', () {
      expect(service.userName, '');
      expect(service.isOnboardingDone, false);
      expect(service.selectedCategories, isEmpty);
      expect(service.favoriteIds, isEmpty);
      expect(service.totalWorkouts, 0);
    });
  });

  group('userName', () {
    test('setUserName обновляет кэш и Firestore', () async {
      await service.init();
      await service.setUserName('Иван');

      expect(service.userName, 'Иван');
      final data = await readDoc();
      expect(data!['userName'], 'Иван');
    });

    test('повторная установка перезаписывает имя', () async {
      await service.init();
      await service.setUserName('Анна');
      await service.setUserName('Мария');

      expect(service.userName, 'Мария');
    });
  });

  group('onboardingDone', () {
    test('setOnboardingDone(true) сохраняется', () async {
      await service.init();
      await service.setOnboardingDone(true);

      expect(service.isOnboardingDone, true);
      final data = await readDoc();
      expect(data!['onboardingDone'], true);
    });

    test('setOnboardingDone(false) сбрасывает', () async {
      await service.init();
      await service.setOnboardingDone(true);
      await service.setOnboardingDone(false);

      expect(service.isOnboardingDone, false);
    });
  });

  group('selectedCategories', () {
    test('setSelectedCategories сохраняет список', () async {
      await service.init();
      await service.setSelectedCategories(['neck', 'stress', 'eyes']);

      expect(service.selectedCategories, ['neck', 'stress', 'eyes']);
      final data = await readDoc();
      expect(data!['selectedCategories'], ['neck', 'stress', 'eyes']);
    });

    test('перезапись заменяет старый список', () async {
      await service.init();
      await service.setSelectedCategories(['neck']);
      await service.setSelectedCategories(['back', 'eyes']);

      expect(service.selectedCategories, ['back', 'eyes']);
    });

    test('пустой список допустим', () async {
      await service.init();
      await service.setSelectedCategories(['neck']);
      await service.setSelectedCategories([]);

      expect(service.selectedCategories, isEmpty);
    });
  });

  group('favoriteIds', () {
    test('isFavorite возвращает false для нового сервиса', () async {
      await service.init();
      expect(service.isFavorite('ex_01'), false);
    });

    test('toggleFavorite добавляет в избранное', () async {
      await service.init();
      final result = await service.toggleFavorite('ex_01');

      expect(result, true);
      expect(service.isFavorite('ex_01'), true);
      expect(service.favoriteIds, ['ex_01']);
    });

    test('toggleFavorite убирает из избранного', () async {
      await service.init();
      await service.toggleFavorite('ex_01');
      final result = await service.toggleFavorite('ex_01');

      expect(result, false);
      expect(service.isFavorite('ex_01'), false);
      expect(service.favoriteIds, isEmpty);
    });

    test('toggleFavorite сохраняет в Firestore', () async {
      await service.init();
      await service.toggleFavorite('ex_01');
      await service.toggleFavorite('ex_02');

      final data = await readDoc();
      expect(data!['favoriteIds'], ['ex_01', 'ex_02']);
    });

    test('removeFavorite удаляет из избранного', () async {
      await service.init();
      await service.toggleFavorite('ex_01');
      await service.toggleFavorite('ex_02');

      await service.removeFavorite('ex_01');

      expect(service.favoriteIds, ['ex_02']);
      expect(service.isFavorite('ex_01'), false);
    });

    test('removeFavorite ничего не делает если id нет', () async {
      await service.init();
      await service.toggleFavorite('ex_01');

      await service.removeFavorite('ex_99');

      expect(service.favoriteIds, ['ex_01']);
    });
  });

  group('stats — recordWorkout', () {
    test('первая тренировка увеличивает счётчики', () async {
      await service.init();
      await service.recordWorkout(
        exerciseCount: 3,
        durationSeconds: 120,
        now: DateTime(2026, 4, 27),
      );

      expect(service.totalWorkouts, 1);
      expect(service.totalExercises, 3);
      expect(service.totalSeconds, 120);
      expect(service.streakDays, 1);
    });

    test('вторая тренировка в тот же день — streak не растёт', () async {
      await service.init();
      final day = DateTime(2026, 4, 27);

      await service.recordWorkout(
        exerciseCount: 3,
        durationSeconds: 120,
        now: day,
      );
      await service.recordWorkout(
        exerciseCount: 2,
        durationSeconds: 80,
        now: day,
      );

      expect(service.totalWorkouts, 2);
      expect(service.totalExercises, 5);
      expect(service.totalSeconds, 200);
      expect(service.streakDays, 1);
    });

    test('тренировка на следующий день — streak++', () async {
      await service.init();

      await service.recordWorkout(
        exerciseCount: 3,
        durationSeconds: 120,
        now: DateTime(2026, 4, 27),
      );
      await service.recordWorkout(
        exerciseCount: 2,
        durationSeconds: 80,
        now: DateTime(2026, 4, 28),
      );

      expect(service.streakDays, 2);
      expect(service.totalWorkouts, 2);
    });

    test('пропуск дня сбрасывает streak в 1', () async {
      await service.init();

      await service.recordWorkout(
        exerciseCount: 3,
        durationSeconds: 120,
        now: DateTime(2026, 4, 27),
      );
      // Пропускаем 28 апреля
      await service.recordWorkout(
        exerciseCount: 2,
        durationSeconds: 80,
        now: DateTime(2026, 4, 29),
      );

      expect(service.streakDays, 1);
    });

    test('три дня подряд — streak = 3', () async {
      await service.init();

      await service.recordWorkout(
        exerciseCount: 1, durationSeconds: 40, now: DateTime(2026, 4, 25),
      );
      await service.recordWorkout(
        exerciseCount: 1, durationSeconds: 40, now: DateTime(2026, 4, 26),
      );
      await service.recordWorkout(
        exerciseCount: 1, durationSeconds: 40, now: DateTime(2026, 4, 27),
      );

      expect(service.streakDays, 3);
      expect(service.totalWorkouts, 3);
      expect(service.totalExercises, 3);
      expect(service.totalSeconds, 120);
    });

    test('recordWorkout сохраняет stats в Firestore', () async {
      await service.init();
      await service.recordWorkout(
        exerciseCount: 3,
        durationSeconds: 120,
        now: DateTime(2026, 4, 27),
      );

      final data = await readDoc();
      final stats = data!['stats'] as Map<String, dynamic>;
      expect(stats['totalWorkouts'], 1);
      expect(stats['totalExercises'], 3);
      expect(stats['totalSeconds'], 120);
      expect(stats['streakDays'], 1);
      expect(stats['lastWorkoutDate'], '2026-04-27');
    });
  });

  group('clearAll', () {
    test('сбрасывает всё к дефолтам', () async {
      await service.init();
      await service.setUserName('Анна');
      await service.setOnboardingDone(true);
      await service.setSelectedCategories(['neck']);
      await service.toggleFavorite('ex_01');
      await service.recordWorkout(
        exerciseCount: 3,
        durationSeconds: 120,
        now: DateTime(2026, 4, 27),
      );

      await service.clearAll();

      expect(service.userName, '');
      expect(service.isOnboardingDone, false);
      expect(service.selectedCategories, isEmpty);
      expect(service.favoriteIds, isEmpty);
      expect(service.totalWorkouts, 0);
      expect(service.streakDays, 0);
    });

    test('clearAll обновляет Firestore', () async {
      await service.init();
      await service.setUserName('Анна');
      await service.clearAll();

      final data = await readDoc();
      expect(data!['userName'], '');
      expect(data['onboardingDone'], false);
    });
  });
}
