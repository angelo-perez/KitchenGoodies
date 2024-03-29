import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:elective_project/edit_recipe/edit_ingredients.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:star_menu/star_menu.dart';
import '../providers/user_provider.dart';
import '../util/colors.dart';
import '../util/utils.dart';
import '../community_page/models/user.dart' as model;

class EditNamePicture extends StatefulWidget {
  EditNamePicture(
      this.userId,
      this.recipeId,
      this.recipeImage,
      this.recipeName,
      this.recipeDescription,
      this.recipeCategory,
      this.recipePrivacy,
      this.recipeIngredients,
      this.recipeSteps,
      this.recipeStepTimer);

  final String userId;
  final String recipeId;
  final String recipeImage;
  final String recipeName;
  final String recipeDescription;
  final String recipeCategory;
  final String recipePrivacy;
  final List recipeIngredients;
  final List recipeSteps;
  final List recipeStepTimer;

  @override
  State<EditNamePicture> createState() => _EditNamePictureState();
}

class _EditNamePictureState extends State<EditNamePicture> {
  Uint8List? _image;

  // void initState() {
  //   recipeImgPlaceholder();
  //   super.initState();
  // }

  void recipeImgPlaceholder() async {
    final ByteData bytes = await rootBundle.load('images/test-images/recipe-image-placeholder.jpg');
    final Uint8List list = bytes.buffer.asUint8List();
    setState(() {
      _image = list;
    });
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery, false);
    setState(() {
      _image = im;
    });
  }

  void captureImage() async {
    Uint8List im = await pickImage(ImageSource.camera, false);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    print(user.uid);
    print(user.username);

    TextEditingController _nameController = TextEditingController(text: widget.recipeName);
    TextEditingController _descriptionController =
        TextEditingController(text: widget.recipeDescription);
    String? recipePrivacy = widget.recipePrivacy;
    String? recipeCategory = widget.recipeCategory;

    //final recipeAuthor = username;

    List<Widget> imageSource = [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FloatingActionButton(
          onPressed: captureImage,
          backgroundColor: mBackgroundColor,
          child: Icon(FluentIcons.camera_28_filled, color: appBarColor),
        ),
        const Padding(padding: EdgeInsets.only(top: 4.0)),
        Center(
          widthFactor: double.minPositive,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(4),
              color: mBackgroundColor,
              child: Text(
                "Camera",
                style: TextStyle(color: mPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        )
      ]),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: selectImage,
            backgroundColor: mBackgroundColor,
            child: Icon(
              FluentIcons.image_28_filled,
              color: appBarColor,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 4.0)),
          Center(
            widthFactor: double.minPositive,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(4),
                color: mBackgroundColor,
                child: Text(
                  "Gallery",
                  style: TextStyle(color: mPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
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
        title: const Text('Edit Recipe'),
      ),
      backgroundColor: mBackgroundColor,
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          StarMenu(
              params: StarMenuParameters(
                backgroundParams:
                    BackgroundParams(sigmaX: 3, sigmaY: 3, backgroundColor: mPrimaryColor),
                useScreenCenter: true,
              ),
              onItemTapped: (index, controller) {
                controller.closeMenu!();
              },
              controller: centerStarMenuController,
              items: imageSource,
              child: _image != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              _image!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Stack(alignment: Alignment.center, children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              widget.recipeImage,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )),
                        Center(
                          widthFactor: double.maxFinite,
                          child: Container(
                            color: Colors.black45,
                            child: const Text(
                              "Tap to change",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ]),
                    )),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                labelText: 'Recipe Name',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mPrimaryColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mPrimaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: mBackgroundColor,
                    elevation: 16,
                    shadowColor: appBarColor,
                  )),
              items: const [
                'Chicken',
                'Pork',
                'Beef',
                'Fish',
                'Crustacean',
                'Vegetables',
                'Dessert',
                'Others'
              ],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Recipe Category",
                  hintText: "Recipe Category",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: mPrimaryColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: mPrimaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              onChanged: (value) {
                recipeCategory = value;
                print(recipeCategory);
              },
              selectedItem: widget.recipeCategory[0].toUpperCase() +
                  widget.recipeCategory.substring(1), //capitalize the first letter
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: TextField(
              controller: _descriptionController,
              maxLines: 3,
              minLines: 1,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                labelText: 'Recipe Desciption (Optional)',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mPrimaryColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mPrimaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: mBackgroundColor,
                    elevation: 16,
                    shadowColor: appBarColor,
                  )),
              items: ["Private", "Public"],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Recipe Privacy",
                  hintText: "Recipe Privacy",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: mPrimaryColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: mPrimaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              onChanged: (value) {
                recipePrivacy = value;
                print(recipePrivacy);
              },
              selectedItem: widget.recipePrivacy[0].toUpperCase() +
                  widget.recipePrivacy.substring(1), //capitalize the first letter
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          ElevatedButton(
            onPressed: () {
              String recipe_name = _nameController.text;
              String recipe_description = _descriptionController.text;
              String toastMessage = "";
              print(recipe_name);
              print(recipe_description);
              print(recipeCategory);
              print(recipePrivacy);

              if (_nameController.text.isEmpty) {
                toastMessage = "Recipe Name can't be empty";
                Fluttertoast.showToast(
                    msg: toastMessage,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: splashScreenBgColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                pushNewScreen(context,
                    screen: EditIngredients(
                        widget.userId,
                        widget.recipeId,
                        _image,
                        recipe_name,
                        recipe_description,
                        recipeCategory!,
                        recipePrivacy!,
                        widget.recipeIngredients,
                        widget.recipeSteps,
                        widget.recipeStepTimer),
                    withNavBar: true);
              }
            },
            child: Text("Next"),
            style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
          ),
        ],
      )),
    );
  }
}
