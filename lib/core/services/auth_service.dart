import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  var auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<User?> loginWithGoogle() async {
    try {
      User? user;

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('error getting google sign in account');
        return null;
      }

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      var result = (await auth.signInWithCredential(credential));
      user = result.user;

      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', user?.email ?? '');
      await prefs.setString('userName', user?.displayName ?? '');
      await prefs.setString('userPhoto', user?.photoURL ?? '');
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> loginWithApple() async {
  try {
    // 1. Get Apple credentials
    final appleCredentials = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // 2. Create Firebase credential
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredentials.identityToken,
      accessToken: appleCredentials.authorizationCode,
    );

    // 3. Sign in to Firebase
    final result = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    final user = result.user;

    // 4. Store user info locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', user?.email ?? '');
    await prefs.setString('userName', user?.displayName ?? '');
    await prefs.setString('userPhoto', user?.photoURL ?? '');

    return user;
  } catch (e) {
    print('Apple Sign-In error: $e');
    return null;
  }
}

  Future<void> logout() async {
    await auth.signOut();
    if (Platform.isAndroid) {
      googleSignIn.disconnect();
    }

    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userPhoto');
  }
}
