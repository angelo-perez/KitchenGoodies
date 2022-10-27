import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/recipe_steps/recipe_overview.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../pages/recipes_page.dart';
import '../main.dart';

class ChickenRecipes extends StatefulWidget {
  const ChickenRecipes({Key? key}) : super(key: key);

  @override
  State<ChickenRecipes> createState() => _ChickenRecipesState();
}

class _ChickenRecipesState extends State<ChickenRecipes> {
  int _index = 0;
  PageController _controller = PageController(viewportFraction: 0.75);
  final CollectionReference _chickenRecipes =
      FirebaseFirestore.instance.collection('chicken-recipe');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2E5D9),
      body: StreamBuilder(
          stream: _chickenRecipes.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 525, // card height
                    child: PageView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      controller: _controller, //card width
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Transform.scale(
                          scale: index == _index ? 1 : 0.85,
                          child: Card(
                            elevation: 8,
                            child: Card(
                              elevation: 6,
                              child: _chickenRecipeListItem(
                                  context, documentSnapshot),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: streamSnapshot.data!.docs.length,
                    effect: ScaleEffect(
                      activePaintStyle: PaintingStyle.stroke,
                      scale: 1.7,
                      activeStrokeWidth: 1.5,
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      dotColor: Color(0xFF12A2726),
                      activeDotColor: Color(0xFF12A2726),
                    ),
                    onDotClicked: (index) {
                      //setState(() => _index = index);
                    },
                  ),
                ]
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _chickenRecipeListItem(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    //Recipe recipe = recipeList[_index];
    return InkWell(
      splashColor: Colors.black26,
      onTap: () {
        int numFields = (documentSnapshot.data() as Map<String, dynamic>)
            .keys
            .toList()
            .length;
        if (numFields == 5) {
          //check if number of fields is 5 (complete)
          pushNewScreen(
            context,
            screen: RecipeOverview(
                documentSnapshot['name'],
                documentSnapshot['ingredients'],
                documentSnapshot['steps'],
                documentSnapshot['steps-timer']),
            withNavBar: false,
          );
        } else {
          const recipeSnackbar =
              SnackBar(content: Text("Sorry, recipe is not yet available."));
          ScaffoldMessenger.of(context).showSnackBar(recipeSnackbar);
        }
      },
      child: Ink.image(
        image: NetworkImage(documentSnapshot['imageUrl']),
        height: 200,
        width: 200,
        fit: BoxFit.cover,
        child: Text(
          documentSnapshot['name'],
          style: TextStyle(
            fontSize: 32,
            color: Color.fromARGB(255, 126, 121, 121),
          ),
        ),
      ),
    );
  }
}
