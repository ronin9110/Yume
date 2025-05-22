import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoggle() async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gauth = await guser!.authentication;
    final cred = GoogleAuthProvider.credential(
        accessToken: gauth.accessToken, idToken: gauth.idToken);
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(cred);
  }
}
