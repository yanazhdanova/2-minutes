import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:two_mins/features/exercises/data/prefs_service.dart';
import 'package:two_mins/features/exercises/data/exercise_sqlite_repository.dart';
import 'package:two_mins/features/exercises/data/db/app_db.dart';

// Firebase Auth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

// Notifications
class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

//  Repositories
class MockExerciseSqliteRepository extends Mock
    implements ExerciseSqliteRepository {}

class MockAppDb extends Mock implements AppDb {}

// Services
class MockPrefsService extends Mock implements PrefsService {}
