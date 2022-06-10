import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../recipes_page.dart';
import '../main.dart';

class ChickenRecipes extends StatefulWidget {
  const ChickenRecipes({Key? key}) : super(key: key);

  @override
  State<ChickenRecipes> createState() => _ChickenRecipesState();
}

class _ChickenRecipesState extends State<ChickenRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2E5D9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'List of Chicken Dishes',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
