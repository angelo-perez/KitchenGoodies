// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:elective_project/recipes_categories/category_recipes_page.dart';
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
  RecipeCategories(1, 'images/img1.png', 'Chicken', 'First Category'),
  RecipeCategories(2, 'images/img1.png', 'Pork', 'Second Category'),
  RecipeCategories(3, 'images/img1.png', 'Beef', 'Third Category'),
  RecipeCategories(4, 'images/img1.png', 'Fish', 'Fourth Category'),
  RecipeCategories(5, 'images/img1.png', 'Crustacean', 'Fifth Category'),
  RecipeCategories(6, 'images/img1.png', 'Vegetables', 'Sixth Category'),
  RecipeCategories(7, 'images/img1.png', 'Dessert', 'Seventh Category'),
  RecipeCategories(8, 'images/img1.png', 'Others', 'Eight Category'),
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
