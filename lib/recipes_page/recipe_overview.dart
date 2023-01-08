import 'dart:ffi';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:elective_project/recipe_steps/recipe_step_page.dart';
import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      [this.recipe_type]); //optional argument to know if it is a premade recipe or a user's created recipe

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
  String? recipe_type;

  @override
  State<RecipeOverview> createState() => _RecipeOverviewState();
}

class _RecipeOverviewState extends State<RecipeOverview> {
  @override
  Widget build(BuildContext context) {
    Color iconTextColor = Colors.white;
    int totalStepsCount = widget.recipe_steps.length;
    int step_index = 0;
    String overviewBG = widget.recipe_image;

    String recipeType = widget.recipe_type == null ? "recipe" : "myrecipe"; //to know if it is a premade recipe or a user's created recipe
    print(recipeType);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
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
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
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
              Padding(padding: EdgeInsets.only(bottom: 65)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
            recipeType
          ),
          withNavBar: false,
        ),
        label: Text(
          'Start Cooking',
          style: TextStyle(color: iconTextColor),
        ),
        backgroundColor: appBarColor,
        elevation: 20,
      ),
    );
  }
}