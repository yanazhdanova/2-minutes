import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../mocks/mocks.dart';

/// Тестируемая обёртка над AuthService с внедрёнными зависимостями.
/// Оригинальный AuthService создаёт FirebaseAuth.instance напрямую,
/// поэтому для unit-тестов используем тестируемую версию.
class TestableAuthService {
  final FirebaseAuth auth;
  final MockGoogleSignIn googleSignIn;

  TestableAuthService({required this.auth, required this.googleSignIn});

  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserCredential> register({
    required String email,
    required String password,
  }) => auth.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );

  Future<UserCredential> login({
    required String email,
    required String password,
  }) =>
      auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> resetPassword({required String email}) =>
      auth.sendPasswordResetEmail(email: email.trim());

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'google-cancelled', message: '');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late TestableAuthService authService;
  late MockUserCredential mockCredential;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockCredential = MockUserCredential();
    mockUser = MockUser();
    authService = TestableAuthService(
      auth: mockAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthCredential(providerId: 'fake', signInMethod: 'fake'),
    );
  });

  group('register', () {
    test('регистрация с валидными данными', () async {
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => mockCredential);

      final result = await authService.register(
        email: 'test@test.com',
        password: '123456',
      );

      expect(result, mockCredential);
      verify(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: '123456',
        ),
      ).called(1);
    });

    test('регистрация с невалидным email — бросает исключение', () async {
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'invalid',
          password: '123456',
        ),
      ).thenThrow(FirebaseAuthException(code: 'invalid-email', message: ''));

      expect(
        () => authService.register(email: 'invalid', password: '123456'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('регистрация с коротким паролем — бросает исключение', () async {
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: '123',
        ),
      ).thenThrow(FirebaseAuthException(code: 'weak-password', message: ''));

      expect(
        () => authService.register(email: 'test@test.com', password: '123'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('email уже зарегистрирован — бросает исключение', () async {
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'existing@test.com',
          password: '123456',
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'email-already-in-use', message: ''),
      );

      expect(
        () => authService.register(
          email: 'existing@test.com',
          password: '123456',
        ),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'email-already-in-use',
          ),
        ),
      );
    });

    test('email с пробелами триммится', () async {
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => mockCredential);

      await authService.register(
        email: '  test@test.com  ',
        password: '123456',
      );

      verify(
        () => mockAuth.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: '123456',
        ),
      ).called(1);
    });
  });

  group('login', () {
    test('логин с правильными credentials', () async {
      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => mockCredential);

      final result = await authService.login(
        email: 'test@test.com',
        password: '123456',
      );

      expect(result, mockCredential);
    });

    test('логин с неправильным паролем', () async {
      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'wrong',
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password', message: ''));

      expect(
        () => authService.login(email: 'test@test.com', password: 'wrong'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('логин с несуществующим пользователем', () async {
      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: 'nouser@test.com',
          password: '123456',
        ),
      ).thenThrow(FirebaseAuthException(code: 'user-not-found', message: ''));

      expect(
        () => authService.login(email: 'nouser@test.com', password: '123456'),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'user-not-found',
          ),
        ),
      );
    });
  });

  group('signInWithGoogle', () {
    test('отмена Google Sign-In → FirebaseAuthException', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      expect(
        () => authService.signInWithGoogle(),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'google-cancelled',
          ),
        ),
      );
    });

    test('успешный Google Sign-In', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();

      when(
        () => mockGoogleSignIn.signIn(),
      ).thenAnswer((_) async => mockAccount);
      when(
        () => mockAccount.authentication,
      ).thenAnswer((_) async => mockGoogleAuth);
      when(() => mockGoogleAuth.accessToken).thenReturn('access_token');
      when(() => mockGoogleAuth.idToken).thenReturn('id_token');
      when(
        () => mockAuth.signInWithCredential(any()),
      ).thenAnswer((_) async => mockCredential);

      final result = await authService.signInWithGoogle();

      expect(result, mockCredential);
    });
  });

  group('resetPassword', () {
    test('отправка email для сброса пароля', () async {
      when(
        () => mockAuth.sendPasswordResetEmail(email: 'test@test.com'),
      ).thenAnswer((_) async {});

      await authService.resetPassword(email: 'test@test.com');

      verify(
        () => mockAuth.sendPasswordResetEmail(email: 'test@test.com'),
      ).called(1);
    });

    test('email триммится при сбросе', () async {
      when(
        () => mockAuth.sendPasswordResetEmail(email: 'test@test.com'),
      ).thenAnswer((_) async {});

      await authService.resetPassword(email: '  test@test.com  ');

      verify(
        () => mockAuth.sendPasswordResetEmail(email: 'test@test.com'),
      ).called(1);
    });
  });

  group('logout', () {
    test('выход из аккаунта', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await authService.logout();

      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockAuth.signOut()).called(1);
    });
  });

  group('currentUser', () {
    test('возвращает null если не залогинен', () {
      when(() => mockAuth.currentUser).thenReturn(null);

      expect(authService.currentUser, isNull);
    });

    test('возвращает пользователя если залогинен', () {
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      expect(authService.currentUser, mockUser);
    });
  });

  group('authStateChanges', () {
    test('стрим изменений авторизации', () {
      when(
        () => mockAuth.authStateChanges(),
      ).thenAnswer((_) => Stream.fromIterable([null, mockUser, null]));

      expect(
        authService.authStateChanges,
        emitsInOrder([null, mockUser, null]),
      );
    });
  });
}
