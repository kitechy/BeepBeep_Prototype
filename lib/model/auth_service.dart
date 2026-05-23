import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  // 1. Ensure initialization
  final googleSignIn = GoogleSignIn.instance;

  // 2. Authentication (Identity)
  // Triggers the account picker / Credential Manager sheet
  final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

  // 3. Authorization (Permissions)
  // Request scopes to retrieve the Access Token
  final List<String> scopes = ['email', 'profile'];
  final clientAuth = await googleUser.authorizationClient.authorizeScopes(
    scopes,
  );

  // 4. Create Firebase Credential
  final credential = GoogleAuthProvider.credential(
    idToken: googleUser.authentication.idToken,
    accessToken: clientAuth.accessToken,
  );

  // 5. Sign in to Firebase
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> signOut() async {
  await GoogleSignIn.instance.signOut();
  await FirebaseAuth.instance.signOut();
}
