import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register({
    required String email,
    required String password,
  }) => _auth.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );

  Future<UserCredential> login({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> resetPassword({required String email}) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null)
      throw FirebaseAuthException(code: 'google-cancelled', message: '');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
