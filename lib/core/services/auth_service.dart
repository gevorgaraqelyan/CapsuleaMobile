import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
   var auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
  Future<User?>  loginWithGoogle()async{
    
   try {
 
      User? user;
     
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('error getting google sign in account');
        return null;
      }

      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

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

Future<void> logout() async {
    
    await auth.signOut();
    googleSignIn.disconnect();
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userPhoto');
  }

}