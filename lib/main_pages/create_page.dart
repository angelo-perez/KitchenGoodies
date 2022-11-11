import 'dart:typed_data';

import 'package:elective_project/create_recipe/add_ingredients.dart';
import 'package:flutter/material.dart';
import 'package:elective_project/util/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../create_recipe/add_ingredients.dart';
import '../util/utils.dart';

class CreatePage extends StatefulWidget {
  CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController recipeName = TextEditingController();
  final _validateName = SnackBar(
    content: Text('Recipe Name can\'t be empty'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            'Kitchen Goodies',
            style: GoogleFonts.bebasNeue(
              fontSize: 27,
              color: scaffoldBackgroundColor,
            ),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
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
                'Step 1: Start by entering the name of your recipe.',
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: recipeName,
                keyboardType: TextInputType.name,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  labelText: 'Recipe Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mPrimaryColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mPrimaryColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              ElevatedButton(
                onPressed: () {
                  recipeName.text.isEmpty
                      ? ScaffoldMessenger.of(context).showSnackBar(_validateName)
                      // TOAST
                      // Fluttertoast.showToast(
                      //     msg: "Recipe Name can't be empty",
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.CENTER,
                      //     timeInSecForIosWeb: 1,
                      //     backgroundColor: Colors.red,
                      //     textColor: Colors.white,
                      //     fontSize: 16.0)
                      : pushNewScreen(context,
                          screen: AddIngredients(recipeName.text.toString()), withNavBar: true);
                },
                child: Text("Next"),
                style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
              ),
            ],
          ),
        ));
  }
}
