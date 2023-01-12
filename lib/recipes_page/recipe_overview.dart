import 'dart:ffi';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:elective_project/recipe_steps/recipe_step_page.dart';
import 'package:elective_project/util/colors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RecipeOverview extends StatefulWidget {
  RecipeOverview(
      this.recipeId,
      this.collection_name,
      this.recipe_image,
      this.recipe_name,
      this.recipe_source,
      this.recipe_description,
      this.recipe_ingredients,
      this.recipe_steps,
      this.recipe_stepstimer,
      this.recipe_rating,
      this.recipe_type); //optional argument to know if it is a premade recipe or a user's created recipe

  final String recipeId;
  final String collection_name;
  final String recipe_image;
  final String recipe_name;
  final String recipe_source;
  final String recipe_description;
  final List recipe_ingredients;
  final List recipe_steps;
  final List recipe_stepstimer;
  final List recipe_rating;
  String recipe_type;

  @override
  State<RecipeOverview> createState() => _RecipeOverviewState();
}

class _RecipeOverviewState extends State<RecipeOverview> {
  TextEditingController _reportTextController = TextEditingController();

  String reportTextCurrentValue = "";
  late String reportTextFinal;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Report ${widget.recipe_name}",
              maxLines: 1,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: TextField(
              maxLines: 5,
              minLines: 1,
              onChanged: (value) {
                setState(() {
                  reportTextCurrentValue = value;
                });
              },
              cursorColor: Colors.grey,
              controller: _reportTextController,
              decoration: InputDecoration(
                hintText: "Submit your report...",
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
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: mPrimaryColor),
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Color.fromARGB(51, 42, 39, 38),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    reportTextFinal = reportTextCurrentValue;
                    if (reportTextFinal == "") {
                      Fluttertoast.showToast(
                          msg: "Please enter your report",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: splashScreenBgColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Navigator.pop(context);
                      _reportTextController.clear();
                      Fluttertoast.showToast(
                          msg: "Successfully reported ${widget.recipe_name}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: splashScreenBgColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                },
              ),
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: mPrimaryColor),
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Color.fromARGB(51, 42, 39, 38),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _reportTextController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color iconTextColor = Colors.white;
    int totalStepsCount = widget.recipe_steps.length;
    int step_index = 0;
    String overviewBG = widget.recipe_image;

    String recipeType = widget
        .recipe_type; //to know if it is a "premade", "public", or "myrecipe"
    print(recipeType);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mBackgroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.recipe_name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "by ${widget.recipe_source}",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
            ),
          ],
        ),
        actions: [
          recipeType == "public"
              ? IconButton(
                  onPressed: () {
                    _displayTextInputDialog(context);
                  },
                  icon: Icon(Icons.report),
                )
              : Container(),
        ],
        elevation: 0,
        foregroundColor: mBackgroundColor,
        centerTitle: true,
      ),
      //extendBodyBehindAppBar: true,
      backgroundColor: appBarColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: overviewBG != null
            ? BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(overviewBG),
                    fit: BoxFit.cover,
                    opacity: 175),
              )
            : BoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Ingredients',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: iconTextColor),
                  textAlign: TextAlign.left,
                ),
              ),
              BulletedList(
                style: TextStyle(
                  color: iconTextColor,
                  fontSize: 18,
                ),
                listItems: widget.recipe_ingredients,
                listOrder: ListOrder.unordered,
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Text(
                'Procedures',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: iconTextColor),
                textAlign: TextAlign.left,
              ),
              BulletedList(
                style: TextStyle(
                  color: iconTextColor,
                  fontSize: 18,
                ),
                listItems: widget.recipe_steps,
                listOrder: ListOrder.unordered,
                bulletType: BulletType.numbered,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 90),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton.extended(
          onPressed: () => pushNewScreen(
            context,
            screen: RecipeStepPage(
                widget.recipeId,
                widget.collection_name,
                widget.recipe_image,
                widget.recipe_name,
                widget.recipe_source,
                widget.recipe_steps,
                widget.recipe_stepstimer,
                totalStepsCount,
                step_index,
                widget.recipe_steps[step_index],
                widget.recipe_stepstimer[step_index],
                widget.recipe_rating,
                recipeType),
            withNavBar: false,
          ),
          label: Text(
            'Start Cooking',
            style: TextStyle(color: iconTextColor),
          ),
          backgroundColor: appBarColor,
          elevation: 20,
        ),
      ),
    );
  }
}
