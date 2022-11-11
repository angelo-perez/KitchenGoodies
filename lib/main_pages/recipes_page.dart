// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:elective_project/recipes_categories/chicken_recipes.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RecipeCategories {
  late final int id;
  late final String imgPath;
  late final String categoryName;
  late final String description;

  RecipeCategories(this.id, this.imgPath, this.categoryName, this.description);
}

List<RecipeCategories> recipeCategoryList = [
  RecipeCategories(
      1, 'images/img1.png', 'Chicken', 'First Category'),
  RecipeCategories(
      2, 'images/img1.png', 'Category 2', 'Second Category'),
  RecipeCategories(
      3, 'images/img1.png', 'Category 3', 'Third Category'),
  RecipeCategories(
      4, 'images/img1.png', 'Category 4', 'Fourth Category'),
  RecipeCategories(
      5, 'images/img1.png', 'Category 5', 'Fifth Category'),
  RecipeCategories(
      6, 'images/img1.png', 'Category 6', 'Sixth Category'),
  RecipeCategories(
      7, 'images/img1.png', 'Category 7', 'Seventh Category'),
  RecipeCategories(
      8, 'images/img1.png', 'Category 8', 'Eight Category'),
];

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2E5D9),
      body: Center(
        child: SafeArea(
            child: Scrollbar(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height/1.175),
                ),
                primary: false,
                padding: const EdgeInsets.all(10),
                itemCount: recipeCategoryList.length,
                itemBuilder: _recipeCategoryItem,
              ),
            )),
      ),
    );
  }

  Widget _recipeCategoryItem(BuildContext context, int _index) {
    RecipeCategories recipeCategory = recipeCategoryList[_index];
    return Card(
      elevation: 8,
      child: InkWell(
        splashColor: Colors.black26,
        onTap: () =>
            pushNewScreen(context, screen: ChickenRecipes(), withNavBar: true),
        child: Ink.image(
          image: AssetImage(recipeCategory.imgPath),
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          child: Text(
            recipeCategory.categoryName,
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
