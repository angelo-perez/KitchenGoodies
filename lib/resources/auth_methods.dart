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

  Future<String> editUser({
    required String email,
    required String username,
    required String profImage,
    required String description,
    required String password,
    required context,
  }) async {
    String res = 'Some error occured';
    List followers = [];
    List following = [];
    try {
      if (email.isNotEmpty && username.isNotEmpty && description.isNotEmpty) {
        User currentUser = _auth.currentUser!;
        var userSnap = await _firestore.collection('users').doc(currentUser.uid).get();

        // gets the data in firebase for model user
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

        await _auth.signInWithEmailAndPassword(
          email: userSnap.data()!['email'],
          password: password,
        );
        currentUser.updateEmail(email);

        // send the new data to the firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set(user.toJson());

        // updates the data in the User model
        UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);
        await _userProvider.refreshUser();
        res = "Success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      }
    } catch (err) {
      res = err.toString();
      print(res);
    }

    return res;
  }

  Future<String> changeUserPassword({
    required String password,
    required String newPassword,
    required String confirmNewPassword,
    required context,
  }) async {
    String res = "";
    try {
      User currentUser = _auth.currentUser!;
      var userSnap = await _firestore.collection('users').doc(currentUser.uid).get();
      String emailAddress = userSnap.data()!['email'];
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (newPassword == confirmNewPassword) {
        await currentUser.updatePassword(newPassword);
        res = "Success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      }
    } catch (e) {
      res = e.toString();
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
