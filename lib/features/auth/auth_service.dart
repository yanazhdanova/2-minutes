import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Сервис аутентификации. Инкапсулирует работу с FirebaseAuth и GoogleSignIn.
/// Поддерживает три способа входа: регистрация по email/паролю, логин по email/паролю
/// и вход через Google. Также предоставляет сброс пароля и выход из обоих сервисов.
/// Экземпляр создаётся на каждом экране авторизации (не singleton).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Текущий аутентифицированный пользователь или null.
  User? get currentUser => _auth.currentUser;
  /// Поток изменений состояния авторизации.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Регистрирует нового пользователя по email и паролю.
  Future<UserCredential> register({
    required String email,
    required String password,
  }) => _auth.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );

  /// Входит по email и паролю.
  Future<UserCredential> login({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  /// Отправляет письмо для сброса пароля.
  Future<void> resetPassword({required String email}) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  /// Входит через Google Sign-In.
  /// @throws FirebaseAuthException с кодом 'google-cancelled' если пользователь отменил
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'google-cancelled', message: '');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  /// Выходит из Google и Firebase одновременно.
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
