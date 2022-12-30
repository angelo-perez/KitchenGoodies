import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:elective_project/create_recipe/add_ingredients.dart';
import 'package:flutter/material.dart';
import 'package:elective_project/util/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'add_ingredients.dart';
import '../util/utils.dart';

class CreatePage extends StatefulWidget {
  CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController recipeName = TextEditingController();
  String? recipePrivacy = "Private";
  String? recipeCategory = "Select a category";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text('Create Recipe'),
        ),
        backgroundColor: mBackgroundColor,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: Text(
                  'Create Your Own Recipe',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 45,
                    color: const Color(0xFF6e3d28),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              Text(
                'Step 1: Start by entering the name of your recipe, its category, and setting its privacy.',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  controller: recipeName,
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
                        backgroundColor: scaffoldBackgroundColor,
                        elevation: 16,
                        shadowColor: appBarColor,
                      )),
                  items: [
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
                  selectedItem: "Select a category",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      showSelectedItems: true,
                      menuProps: MenuProps(
                        backgroundColor: scaffoldBackgroundColor,
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
                  selectedItem: "Private",
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ElevatedButton(
                onPressed: () {
                  String recipe_name = recipeName.text;
                  String toastMessage = "";
                  print(recipe_name);
                  print(recipePrivacy);

                  if (recipeName.text.isEmpty) {
                    toastMessage = "Recipe Name can't be empty";
                    Fluttertoast.showToast(
                        msg:toastMessage,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: splashScreenBgColor,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (recipeCategory == "Select a category") {
                    toastMessage = "Please select a Recipe Category";
                    Fluttertoast.showToast(
                          msg: toastMessage,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: splashScreenBgColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                  }
                  else{
                    pushNewScreen(context,
                          screen: AddIngredients(
                              recipe_name, recipeCategory!, recipePrivacy!),
                          withNavBar: true);
                  }
                },
                child: Text("Next"),
                style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
              ),
            ],
          ),
        ));
  }
}
