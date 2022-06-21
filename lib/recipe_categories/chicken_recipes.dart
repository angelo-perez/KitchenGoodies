import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../pages/recipes_page.dart';
import '../main.dart';

class Recipe {
  late final int id;
  late final String imgPath;
  late final String recipeName;
  late final String description;

  Recipe(this.id, this.imgPath, this.recipeName, this.description);
}

List<Recipe> recipeList = [
  Recipe(1, 'images/img1.png', 'Recipe 1', 'First Recipe'),
  Recipe(2, 'images/img1.png', 'Recipe 2', 'Second Recipe'),
  Recipe(3, 'images/img1.png', 'Recipe 3', 'Third Recipe'),
  Recipe(4, 'images/img1.png', 'Recipe 4', 'Fourth Recipe'),
  Recipe(5, 'images/img1.png', 'Recipe 5', 'Fifth Recipe'),
];

class ChickenRecipes extends StatefulWidget {
  const ChickenRecipes({Key? key}) : super(key: key);

  @override
  State<ChickenRecipes> createState() => _ChickenRecipesState();
}

class _ChickenRecipesState extends State<ChickenRecipes> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2E5D9),
      body: Center(
        child: SizedBox(
          height: 525, // card height
          child: PageView.builder(
            itemCount: recipeList.length,
            controller: PageController(viewportFraction: 0.75), //card width
            onPageChanged: (int index) => setState(() => _index = index),
            itemBuilder: (_, i) {
              return Transform.scale(
                scale: i == _index ? 1 : 0.85,
                child: Card(
                  elevation: 8,
                  child: Card(
                    elevation: 6,
                    child: _recipeListItem(context, _index),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _recipeListItem(BuildContext context, int _index) {
    Recipe recipe = recipeList[_index];
    return InkWell(
      splashColor: Colors.black26,
      onTap: (() {}),
      // onTap: () =>
      //   pushNewScreen(
      //     context, screen: ChickenRecipes(),
      //     withNavBar: true
      //   ),
      child: Ink.image(
        image: AssetImage(recipe.imgPath),
        height: 200,
        width: 200,
        fit: BoxFit.cover,
        child: Text(
          recipe.recipeName,
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
