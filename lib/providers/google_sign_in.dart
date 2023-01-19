// import 'dart:html';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/providers/user_provider.dart';
import 'package:elective_project/start_up_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:elective_project/community_page/models/user.dart' as model;

import '../resources/storage_methods.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAccount? _user; // For current user's data

  GoogleSignInAccount get user => _user!; // To get user's data

  late UserCredential cred;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      cred = await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // TODO
      print(e.toString());
    }

    notifyListeners();
  }

  Future saveUserData() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (googleSignIn.currentUser != null) {
      //to avoid overwritting data of non-google accounts
      QuerySnapshot<Map<String, dynamic>> newGoogleUser = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: cred.user?.email)
          .get();

      if (!(newGoogleUser.docs.length > 0)) {
        await FirebaseFirestore.instance.collection('users').doc(cred.user?.uid).set({
          'uid': user?.uid,
          'email': user?.email,
          'username': user?.displayName,
          'profImage': user?.photoURL,
          'description': "",
          'followers': [],
          'following': []
        });
        // await FirebaseFirestore.instance.collection('users').doc(cred.user?.uid).set({
        //   'uid': user?.uid,
        //   'email': user?.email,
        //   'username': user?.displayName,
        //   'profImage': user?.photoURL,
        // }, SetOptions(merge: true));
      }
      // else {
      //   await FirebaseFirestore.instance.collection('users').doc(cred.user?.uid).set({
      //     'uid': user?.uid,
      //     'email': user?.email,
      //     'username': user?.displayName,
      //     'profImage': user?.photoURL,
      //     'description': "",
      //     'followers': [],
      //     'following': []
      //   });
      // }
    }
  }

  Future logout(BuildContext context) async {
    if (googleSignIn.currentUser != null) {
      //logout for
      await googleSignIn.disconnect();
    } else {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => new LoginPage()), (route) => false);
    }
  }
}
