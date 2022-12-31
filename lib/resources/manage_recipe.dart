import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/resources/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../util/colors.dart';

class ManageRecipe {
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  Future<String?> uploadRecipe({
    String? userId,
    String? username,
    String? recipeName,
    String? recipeCategory,
    String? recipePrivacy,
    List? recipeIngredients,
    List? recipeSteps,
    List? recipeTimer,
    Uint8List? recipeImage,
  }) async {
    CollectionReference users = _firebaseInstance.collection("users");

    String imageURL = await StorageMethods()
        .uploadImageToStorage('recipePictures', recipeImage!, true);

    String error = "";

    try {
      await users.doc(userId).collection("MyRecipes").add({
        'name': recipeName,
        'source': username,
        'category': recipeCategory,
        'privacy': recipePrivacy,
        'ingredients': recipeIngredients,
        'steps': recipeSteps,
        'steps-timer': recipeTimer,
        'imageUrl': imageURL,
        'date': DateTime.now(),
      }).whenComplete(() => Fluttertoast.showToast(
                msg: "Your recipe was succesfully saved",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: splashScreenBgColor,
                textColor: Colors.white,
                fontSize: 16.0));

    } catch (e) {
      error = e.toString();
    }

    return error;
  }

  Future<String> deleteRecipe(String userId, String recipeId) async {
    CollectionReference users = _firebaseInstance.collection("users");

    String error = "";

    try {
      await users
          .doc(userId)
          .collection('MyRecipes')
          .doc(recipeId)
          .delete()
          .onError((error, stackTrace) => Fluttertoast.showToast(
              msg: "Something went wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: splashScreenBgColor,
              textColor: Colors.white,
              fontSize: 16.0));
    } catch (err) {
      error = err.toString();
    }
    return error;
  }

  Future<String> toggleRecipePrivacy(
      String userId, String recipeId, String recipePrivacy) async {
    CollectionReference users = _firebaseInstance.collection("users");

    String error = "";

    try {
      await users
          .doc(userId)
          .collection("MyRecipes")
          .doc(recipeId)
          .update({
            'privacy': recipePrivacy,
          })
          .whenComplete(() => Fluttertoast.showToast(
              msg: "Your recipe is now in ${recipePrivacy}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: splashScreenBgColor,
              textColor: Colors.white,
              fontSize: 16.0))
          .onError((error, stackTrace) => Fluttertoast.showToast(
              msg: "Something went wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: splashScreenBgColor,
              textColor: Colors.white,
              fontSize: 16.0));
      //status = 'success';
    } catch (err) {
      error = err.toString();
    }
    return error;
  }

  Future<String?> updateRecipe({
    String? userId,
    String? recipeId,
    String? recipeName,
    String? recipeCategory,
    String? recipePrivacy,
    List? recipeIngredients,
    List? recipeSteps,
    List? recipeTimer,
    Uint8List? recipeImage,
  }) async {
    CollectionReference users = _firebaseInstance.collection("users");
    String error = "";

    if (recipeImage == null) {
      try {
        await users
            .doc(userId)
            .collection("MyRecipes")
            .doc(recipeId)
            .update({
              'name': recipeName,
              'category': recipeCategory,
              'privacy': recipePrivacy,
              'ingredients': recipeIngredients,
              'steps': recipeSteps,
              'steps-timer': recipeTimer,
              'date': DateTime.now(),
            })
            .whenComplete(() => Fluttertoast.showToast(
                msg: "Your recipe was succesfully saved",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: splashScreenBgColor,
                textColor: Colors.white,
                fontSize: 16.0))
            .onError((error, stackTrace) => Fluttertoast.showToast(
                msg: "Something went wrong",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: splashScreenBgColor,
                textColor: Colors.white,
                fontSize: 16.0));
      } catch (e) {
        error = e.toString();
      }
    } else {
      try {
        String imageURL = await StorageMethods()
            .uploadImageToStorage('recipePictures', recipeImage, false);
        await users
            .doc(userId)
            .collection("MyRecipes")
            .doc(recipeId)
            .update({
              'name': recipeName,
              'category': recipeCategory,
              'privacy': recipePrivacy,
              'ingredients': recipeIngredients,
              'steps': recipeSteps,
              'steps-timer': recipeTimer,
              'imageUrl': imageURL,
              'date': DateTime.now(),
            })
            .whenComplete(() => Fluttertoast.showToast(
                msg: "Your recipe was succesfully saved",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: splashScreenBgColor,
                textColor: Colors.white,
                fontSize: 16.0))
            .onError((error, stackTrace) => Fluttertoast.showToast(
                msg: "Something went wrong",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: splashScreenBgColor,
                textColor: Colors.white,
                fontSize: 16.0));
      } catch (e) {
        error = e.toString();
      }
    }

    return error;
  }
}
