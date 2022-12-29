// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:elective_project/recipes_categories/category_recipes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../util/colors.dart';

class RecipeCategories {
  late final int id;
  late final String imgPath;
  late final String categoryName;
  late final String description;

  RecipeCategories(this.id, this.imgPath, this.categoryName, this.description);
}

List<RecipeCategories> recipeCategoryList = [
  RecipeCategories(
      1, 'images/recipe_categories/chicken.jpg', 'Chicken', 'First Category'),
  RecipeCategories(
      2, 'images/recipe_categories/pork.jpg', 'Pork', 'Second Category'),
  RecipeCategories(
      3, 'images/recipe_categories/beef.jpg', 'Beef', 'Third Category'),
  RecipeCategories(
      4, 'images/recipe_categories/fish.jpg', 'Fish', 'Fourth Category'),
  RecipeCategories(5, 'images/recipe_categories/crustacean.jpg', 'Crustacean',
      'Fifth Category'),
  RecipeCategories(6, 'images/recipe_categories/vegetables.jpg', 'Vegetables',
      'Sixth Category'),
  RecipeCategories(
      7, 'images/recipe_categories/dessert.jpg', 'Dessert', 'Seventh Category'),
  RecipeCategories(
      8, 'images/recipe_categories/others.jpg', 'Others', 'Eight Category'),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: SvgPicture.asset(
          'images/logos/kitchen-goodies.svg',
          color: appBarColor,
        ),
        title: Text(
          'Categories',
          style: TextStyle(color: appBarColor),
        ),
        elevation: 0.0,
        titleSpacing: 0,
      ),
      backgroundColor: mBackgroundColor,
      body: Center(
        child: SafeArea(
            child: Scrollbar(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.175),
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
        onTap: () {
          print(recipeCategory.categoryName);
          pushNewScreen(context, screen: CategoryRecipesPage(recipeCategory.categoryName), withNavBar: true);
        },
        child: Ink.image(
          image: AssetImage(recipeCategory.imgPath),
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          child: Center(
            child: Container(
              width: double.maxFinite,
              color: Color.fromARGB(160, 0, 0, 0),
              child: Text(
                recipeCategory.categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
