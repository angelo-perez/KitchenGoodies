import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/resources/storage_methods.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

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
    });
    return "Recipe was successfully added to $userId";
  }

  Future<String> deleteRecipe(String userId, String recipeId) async {

    CollectionReference users = _firebaseInstance.collection("users");

    String res = "Some error occurred";

    try {
      await users.doc(userId).collection('MyRecipes').doc(recipeId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> toggleRecipePrivacy(String userId, String recipeId, String recipePrivacy) async {

    CollectionReference users = _firebaseInstance.collection("users");

    String res = "Some error occurred";

    try {
      await users.doc(userId).collection("MyRecipes").doc(recipeId).update({
      'privacy': recipePrivacy,
    });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
