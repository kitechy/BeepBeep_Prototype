import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  final googleSignIn = GoogleSignIn.instance;

  final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

  final List<String> scopes = ['email', 'profile'];
  final clientAuth = await googleUser.authorizationClient.authorizeScopes(
    scopes,
  );

  final credential = GoogleAuthProvider.credential(
    idToken: googleUser.authentication.idToken,
    accessToken: clientAuth.accessToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> signOut() async {
  await GoogleSignIn.instance.signOut();
  await FirebaseAuth.instance.signOut();
}
