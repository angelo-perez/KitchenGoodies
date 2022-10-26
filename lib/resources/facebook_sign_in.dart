import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignIn {
  facebookLogin() async {
    try {
      final result =
      await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print('facebook_login_data:-');
        print(userData);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(image: userData['picture']['data']['url'],
        //   name: userData['name'], email: userData['email'])));
      }
    } catch (error) {
      print(error);
    }
  }
  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance
  //       .login(permissions: ['email', 'public_profile']);

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //   if (loginResult.status == LoginStatus.success) {
  //     final userData = await FacebookAuth.instance.getUserData();
  //     print('facebook_login_data:-');
  //     print(userData);
  //   }
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }
}
