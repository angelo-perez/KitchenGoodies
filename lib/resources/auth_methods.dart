import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
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

          String photoUrl =
              await StorageMethods().uploadImageToStorage('profilePictures', file, false);

          await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
            'uid': cred.user!.uid,
            'email': email,
            'username': username,
            'password': password,
            'photoUrl': photoUrl,
          });

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
}
