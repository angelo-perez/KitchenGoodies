import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/resources/storage_methods.dart';

class UploadRecipe {
  Future<String?> addSubColleciton({
    String? userId,
    String? recipeName,
    String? recipePrivacy,
    List? recipeIngredients,
    List? recipeSteps,
    List? recipeTimer,
    Uint8List? recipeImage,
  }) async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");

    String imageURL =
              await StorageMethods().uploadImageToStorage('recipePictures', recipeImage!, false);

    await users.doc(userId).collection("MyRecipes").add({
      'name': recipeName,
      'privacy': recipePrivacy,
      'ingredients': recipeIngredients,
      'steps': recipeSteps,
      'steps-timer': recipeTimer,
      'imageUrl': imageURL,
      'date' : DateTime.now(),
    });
    return "Recipe was successfully added to $userId";
  }
}
