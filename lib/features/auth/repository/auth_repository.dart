import 'package:beepbeep_prototype/features/auth/service/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthRepository {
  final GoogleAuthService _authService;

  AuthRepository(this._authService);

  Future<UserCredential> signIn() async {
    return await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  bool get isLoggedIn {
    return currentUser != null;
  }
}
