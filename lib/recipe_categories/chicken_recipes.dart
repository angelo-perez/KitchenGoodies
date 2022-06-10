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
      appBar: AppBar(),
    );
  }
}
