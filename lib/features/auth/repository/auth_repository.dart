import 'package:beepbeep_prototype/features/auth/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<UserCredential> signIn() async {
    return await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> saveRole(String role) async {
    await _authService.saveRole(role);
  }


  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  bool get isLoggedIn {
    return currentUser != null;
  }
}
