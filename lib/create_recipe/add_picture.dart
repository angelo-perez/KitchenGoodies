import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/main_pages/main_page.dart';
import 'package:elective_project/resources/manage_recipe.dart';
import 'package:elective_project/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:star_menu/star_menu.dart';

import '../providers/user_provider.dart';
import '../util/utils.dart';
import '../community_page/models/user.dart' as model;

class AddPicture extends StatefulWidget {
  AddPicture(this.recipeName, this.recipeCategory, this.recipePrivacy,
      this.recipeIngredients, this.recipeSteps, this.recipeTimer);

  final String recipeName;
  final String recipeCategory;
  final String recipePrivacy;
  final List recipeIngredients;
  final List recipeSteps;
  final List recipeTimer;

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Uint8List? _image;

  void initState() {
    recipeImgPlaceholder();
    super.initState();
  }

  void recipeImgPlaceholder() async {
    final ByteData bytes = await rootBundle
        .load('images/test-images/recipe-image-placeholder.jpg');
    final Uint8List list = bytes.buffer.asUint8List();
    setState(() {
      _image = list;
    });
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void captureImage() async {
    Uint8List im = await pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final User? user = auth.currentUser;
    // final uid = user!.uid;
    // final username = user.displayName;
    final model.User user = Provider.of<UserProvider>(context).getUser;
    print(user.uid);
    print(user.username);

    //final recipeAuthor = username;

    List<Widget> imageSource = [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(padding: EdgeInsets.only(top: 250.0)),
        FloatingActionButton(
          onPressed: captureImage,
          child: Icon(FluentIcons.camera_28_filled, color: appBarColor),
          backgroundColor: Colors.white,
        ),
        Padding(padding: EdgeInsets.only(top: 4.0)),
        Center(
          widthFactor: double.minPositive,
          child: Container(
            color: appBarColor,
            child: Text(
              "Camera",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ]),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 245.0)),
          FloatingActionButton(
            onPressed: selectImage,
            child: Icon(
              Icons.photo_size_select_actual_rounded,
              color: appBarColor,
            ),
            backgroundColor: Colors.white,
          ),
          Padding(padding: EdgeInsets.only(top: 4.0)),
          Center(
            widthFactor: double.minPositive,
            child: Container(
              color: appBarColor,
              child: Text(
                "Gallery",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    ];

    StarMenuController centerStarMenuController = StarMenuController();

    return Scaffold(

        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            'Create Recipe',
          ),
        ),
        body: SafeArea(
            child: ListView(padding: EdgeInsets.all(10.0), children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Text(
              'Add a Picture',
              style: GoogleFonts.bebasNeue(
                fontSize: 45,
                color: const Color(0xFF6e3d28),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //Padding(padding: EdgeInsets.all(8.0)),
          Text(
            'Step 4: Finally, add a picture of your recipe.',
            style: TextStyle(fontSize: 20),
          ),
          //Padding(padding: EdgeInsets.all(8.0)),
          Text(
            widget.recipeName,
            style: GoogleFonts.bebasNeue(
              fontSize: 30,
              color: const Color(0xFF6e3d28),
            ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          StarMenu(
            params: StarMenuParameters(
              backgroundParams: BackgroundParams(
                sigmaX: 3,
                sigmaY: 3,
              ),
              useScreenCenter: true,
            ),
            onItemTapped: (index, controller) {
              controller.closeMenu!();
            },
            controller: centerStarMenuController,
            items: imageSource,
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.memory(
                      _image!,
                      height: 400,
                      width: 150,
                      fit: BoxFit.cover,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'images/test-images/recipe-image-placeholder.jpg',
                      height: 400,
                      width: 150,
                      fit: BoxFit.fill,
                      color: Colors.white,
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          ElevatedButton(
              onPressed: () {
                print(widget.recipeName);
                print(widget.recipeCategory);
                print(widget.recipePrivacy);
                print(widget.recipeIngredients);
                print(widget.recipeSteps);
                print(widget.recipeTimer);
                print(_image);
                print(user.uid);
                print(user.username);

                ManageRecipe uploadRecipe = ManageRecipe();
                uploadRecipe.uploadRecipe(
                  userId: user.uid,
                  recipeName: widget.recipeName,
                  username: user.username,
                  recipeCategory: widget.recipeCategory,
                  recipePrivacy: widget.recipePrivacy,
                  recipeIngredients: widget.recipeIngredients,
                  recipeSteps: widget.recipeSteps,
                  recipeTimer: widget.recipeTimer,
                  recipeImage: _image!,
                );

                Fluttertoast.showToast(
                    msg: "Your recipe was succesfully saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: splashScreenBgColor,
                    textColor: Colors.white,
                    fontSize: 16.0);

                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage()), //should go to "myrecipe tab" not in homepage
                    (route) => false);
              },
              child: Text("Save Recipe"),
              style: ElevatedButton.styleFrom(backgroundColor: appBarColor))
        ])));
  }
}
