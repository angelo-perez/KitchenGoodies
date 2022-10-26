import 'dart:ffi';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:elective_project/recipe_steps/recipe_step_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RecipeOverview extends StatefulWidget {
  RecipeOverview(this.recipe_name, this.recipe_ingredients, this.recipe_steps,
      this.recipe_stepstimer);

  final String recipe_name;
  final List recipe_ingredients;
  final List recipe_steps;
  final List recipe_stepstimer;

  

  @override
  State<RecipeOverview> createState() => _RecipeOverviewState();
}

class _RecipeOverviewState extends State<RecipeOverview> {
  @override
  Widget build(BuildContext context) {

    int totalStepsCount = widget.recipe_steps.length;
    int step_index = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF12A2726),
      ),
      backgroundColor: Color(0xFFF2E5D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.recipe_name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.left,
            ),
            BulletedList(
              listItems: widget.recipe_ingredients,
              listOrder: ListOrder.unordered,
            ),
            Text(
              'Procedures:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.left,
            ),
            BulletedList(
              listItems: widget.recipe_steps,
              listOrder: ListOrder.unordered,
              bulletType: BulletType.numbered,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF12A2726)),
                onPressed: () => pushNewScreen(
                  context,
                  screen: RecipeStepPage(
                    widget.recipe_steps,
                    widget.recipe_stepstimer,
                    totalStepsCount,
                    step_index,
                    widget.recipe_steps[step_index],
                    widget.recipe_stepstimer[step_index],
                  ),
                  withNavBar: false,
                ),
                child: Text('Start Cooking',
                style: TextStyle(color: Color(0xFFF2E5D9)),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
