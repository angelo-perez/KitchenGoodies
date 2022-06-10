// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:elective_project/recipe_categories/chicken_recipes.dart';
import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    final recipeCategories = <Widget>[
      // Container(
      //   padding: const EdgeInsets.all(8),
      //   color: Colors.teal[100],
      //   child: const Text('Category 1'),
      // ),
      InkWell(
        splashColor: Colors.black26,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ChickenRecipes();
              },
            ),
          );
        },
        child: Ink.image(
          image: const NetworkImage(
              'https://149361674.v2.pressablecdn.com/wp-content/uploads/2019/09/La-Terraza-Montebello-1-683x1024.jpg'),
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          child: const Text(
            'Chicken',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
      InkWell(
        splashColor: Colors.black26,
        onTap: (() {
          setState(() {});
        }),
        child: Ink.image(
          image: const NetworkImage(
              'https://149361674.v2.pressablecdn.com/wp-content/uploads/2019/09/La-Terraza-Montebello-1-683x1024.jpg'),
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          child: const Text(
            'Category 2',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF2E5D9),
      body: Center(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              children: recipeCategories,
            )),
      ),
    );
  }
}
