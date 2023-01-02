import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/community_page/models/user.dart' as model;

import 'package:elective_project/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          confirmPassword.isNotEmpty) {
        if (password == confirmPassword) {
          UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          String profImage =
              await StorageMethods().uploadImageToStorage('profilePictures', file, false);

          model.User user = model.User(
            email: email,
            username: username,
            uid: cred.user!.uid,
            profImage: profImage,
            description: "Hello!",
            followers: [],
            following: [],
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());

          res = "Success";
        } else {
          res = "Password and Confirm Password are not the same";
        }
      }
    } catch (err) {
      res = err.toString();
      print(res);
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error eccoured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      } else {
        res = 'Error Occured';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> EditUser({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required String profImage,
  }) async {
    String res = 'Some error occured';

    List followers = [];
    List following = [];

    String description = "";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          confirmPassword.isNotEmpty) {
        if (password == confirmPassword) {
          User currentUser = _auth.currentUser!;
          var userSnap = await _firestore.collection('users').doc(currentUser.uid).get();

          description = userSnap.data()!['description'];
          followers = userSnap.data()!['followers'];
          following = userSnap.data()!['following'];

          model.User user = model.User(
            email: email,
            username: username,
            uid: currentUser.uid,
            profImage: profImage,
            description: description,
            followers: followers,
            following: following,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .set(user.toJson());

          res = "Success";
        } else {
          res = "Password and Confirm Password are not the same";
        }
      }
    } catch (err) {
      res = err.toString();
      print(res);
    }

    return res;
  }

  Future<String> signOut() async {
    String res = 'signout';
    await FirebaseAuth.instance.signOut();
    return res;
  }

  Future deleteUser() async {
    User currentUser = _auth.currentUser!;
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .delete()
        .then((value) => currentUser.delete());
    print(currentUser.uid);

    // await currentUser.delete();

    signOut();
  }
}
