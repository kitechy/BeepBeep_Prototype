import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  // connection to the auth service
  final AuthService _authService;
  AuthRepository(this._authService);

  // pass login to service
  Future<UserCredential> signIn() async {
    return await _authService.signInWithGoogle();
  }

  // guest login
  Future<UserCredential> signInAsGuest() async {
    return await _authService.signInAsGuest();
  }

  Future<UserCredential> upgradeGuestToGoogle() async {
    return await _authService.upgradeGuestToGoogle();
  }

  // pass sign out to service
  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('No signed-in user to delete.');
    }
    await user.delete();
  }

  // pass get current user to service
  User? get currentUser {
    return _authService.currentUser;
  }
}
