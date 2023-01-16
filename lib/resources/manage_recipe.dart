// import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/resources/storage_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/user_provider.dart';
import '../util/colors.dart';

class ManageRecipe {
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  Future<String?> uploadRecipe(
      {String? userId,
      String? profImage,
      String? username,
      String? recipeName,
      String? recipeDescription,
      String? recipeCategory,
      String? recipePrivacy,
      List? recipeIngredients,
      List? recipeSteps,
      List? recipeTimer,
      Uint8List? recipeImage}) async {
    CollectionReference userRecipes =
        _firebaseInstance.collection("user-recipes");

    String recipeImageUrl = await StorageMethods()
        .uploadImageToStorage('userRecipePictures', recipeImage!, true);

    String error = "";

    String recipeId = const Uuid().v1();

    try {
      await userRecipes.doc(recipeId).set({
        'uid': userId,
        'profImage': profImage,
        'name': recipeName,
        'source': username,
        'collection': recipeCategory?.toLowerCase(),
        'description': recipeDescription, //
        'privacy': recipePrivacy?.toLowerCase(),
        'ingredients': recipeIngredients,
        'steps': recipeSteps,
        'steps-timer': recipeTimer,
        'imageUrl': recipeImageUrl,
        'rating': [],
        'rating-count': 0, //
        'rating-mean': 0, //
        'date': DateTime.now(),
        'recipeId': recipeId,
      }).whenComplete(() {
        Fluttertoast.showToast(
            msg: "Your recipe was succesfully saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: splashScreenBgColor,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } catch (e) {
      error = e.toString();
    }

    return error;
  }

  Future<String> deleteRecipe(
      String userId, String recipeId, String recipeImage) async {
    CollectionReference userRecipes =
        _firebaseInstance.collection("user-recipes");

    String error = "";

    try {
      await userRecipes.doc(recipeId).delete().onError((error, stackTrace) =>
          Fluttertoast.showToast(
              msg: "Something went wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: splashScreenBgColor,
              textColor: Colors.white,
              fontSize: 16.0));

      await FirebaseStorage.instance.refFromURL(recipeImage).delete();
    } catch (err) {
      error = err.toString();
    }
    return error;
  }

  Future<String> toggleRecipePrivacy(
      String userId, String recipeId, String recipePrivacy) async {
    CollectionReference userRecipes =
        _firebaseInstance.collection("user-recipes");

    String error = "";

    try {
      await userRecipes
          .doc(recipeId)
          .update({
            'privacy': recipePrivacy.toLowerCase(),
          })
          .whenComplete(() => Fluttertoast.showToast(
              msg:
                  "Your recipe is now in ${recipePrivacy[0].toUpperCase() + recipePrivacy.substring(1)}",
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
    String? recipeDescription,
    String? recipeCategory,
    String? recipePrivacy,
    List? recipeIngredients,
    List? recipeSteps,
    List? recipeTimer,
    Uint8List? recipeImage,
  }) async {
    CollectionReference userRecipes =
        _firebaseInstance.collection("user-recipes");
    String error = "";

    try {
      if (recipeImage == null) {
        await userRecipes
            .doc(recipeId)
            .update({
              'name': recipeName,
              'collection': recipeCategory?.toLowerCase(),
              'privacy': recipePrivacy?.toLowerCase(),
              'description': recipeDescription,
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
      } else {
        String imageURL = await StorageMethods()
            .uploadImageToStorage('userRecipePictures', recipeImage, false);
        await userRecipes
            .doc(recipeId)
            .update({
              'name': recipeName,
              'collection': recipeCategory,
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
      }
    } catch (e) {
      error = e.toString();
    }

    return error;
  }

  Future<String?> rateRecipe(
    String recipeId,
    String collectionName,
    List recipeArray,
    double recipeRating,
  ) async {

    CollectionReference collection =
        _firebaseInstance.collection(collectionName);

    recipeArray.add(recipeRating);

    await collection.doc(recipeId).update({
      'rating': recipeArray,
      'rating-count': recipeArray.length,
      'rating-mean': recipeArray.reduce((a, b) => a + b) / recipeArray.length
    });
  }

  /// WARNING: Don't enable and call these functions 'til necessary as this may overwrite all the data of recipes in Firebase! ////

  // Future<String?> updateRatingFields(
  //   String? recipeId,
  //   String collectionName,
  // ) async {
  //   CollectionReference collection =
  //       _firebaseInstance.collection(collectionName);
  //   await collection
  //       .doc(recipeId)
  //       .update({'rating': [], 'rating-mean': 0, 'rating-count': 0});
  // }

  // Future<String?> migrateToAnotherCollection(
  //   DocumentSnapshot documentSnapshot,
  // ) async {
  //   // HOW TO USE? APPLY THE CODE BELOW IN STREAM BUILDER
  //   // for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
  //   //   DocumentSnapshot tempSnapshot = streamSnapshot.data!.docs[i];
  //   //   ManageRecipe().migrateToAnotherCollection(tempSnapshot);
  //   // }

  //   String newRecipeId = const Uuid().v1();

  //   CollectionReference premadeCollection =
  //       _firebaseInstance.collection('premade-recipes');
  //   await premadeCollection.doc(newRecipeId).set({
  //     'collection': documentSnapshot['collection'],
  //     'description': documentSnapshot['description'],
  //     'imageUrl': documentSnapshot['imageUrl'],
  //     'ingredients': documentSnapshot['ingredients'],
  //     'name': documentSnapshot['name'],
  //     'privacy': documentSnapshot['privacy'],
  //     'rating': documentSnapshot['rating'],
  //     'rating-count': documentSnapshot['rating-count'],
  //     'rating-mean': documentSnapshot['rating-mean'],
  //     'source': documentSnapshot['source'],
  //     'steps': documentSnapshot['steps'],
  //     'steps-timer': documentSnapshot['steps-timer']
  //   });
  // }
}
