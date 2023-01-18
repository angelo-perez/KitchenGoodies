// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elective_project/main_pages/recipes_page.dart';
import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/food_tiles.dart';
import 'package:elective_project/util/food_types.dart';
import 'package:elective_project/util/header_with_search_bar.dart';
import 'package:elective_project/util/recommended_with_more_bttn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../recipes_page/recipe_overview.dart';
import '../community_page/models/user.dart' as model;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Query<Map<String, dynamic>> _popularRecipeCollection = FirebaseFirestore
      .instance
      .collection('user-recipes')
      .where('privacy', isEqualTo: 'public')
      .orderBy('rating-count', descending: true)
      .limit(3);

  final Query<Map<String, dynamic>> _suggestedRecipeCollection =
      FirebaseFirestore.instance
          .collection('premade-recipes')
          .orderBy('rating-mean', descending: true)
          .limit(6);

  List premadeCollectionNames = [
    'chicken-recipe',
    'pork-recipe',
    'beef-recipe',
    'fish-recipe',
    'crustacean-recipe',
    'vegetables-recipe',
    'dessert-recipe',
    'others-recipe'
  ];

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mBackgroundColor,
        leading: SvgPicture.asset(
          'images/logos/kitchen-goodies.svg',
          color: mPrimaryColor,
        ),
        title: Text(
          'Kitchen Goodies',
          style: TextStyle(
              color: appBarColor, fontWeight: FontWeight.w900, fontSize: 22),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: popularRecipesStream(context),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: suggestedRecipesStream(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // POPULAR PUBLIC RECIPES WIDGETS
  Widget popularRecipesStream(BuildContext context) {
    return StreamBuilder(
      stream: _popularRecipeCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> popularRecipeSnapshot) {
        if (popularRecipeSnapshot.hasData) {
          print(popularRecipeSnapshot.data!.docs.length);
          return popularRecipesBuilder(
              context, popularRecipeSnapshot.data!.docs);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget popularRecipesBuilder(BuildContext context, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Popular Public Recipes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1,
              aspectRatio: 1.45 // to change the height of the cards in carousel
              ),
          itemCount: items.length,
          itemBuilder: ((context, index, realIndex) {
            final DocumentSnapshot documentSnapshot = items[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: appBarColor.withOpacity(0.5),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: documentSnapshot['imageUrl'],
                      imageBuilder: (context, imageProvider) => Ink(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              documentSnapshot['imageUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            color: mPrimaryColor,
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        child: CircleAvatar(
                          minRadius: 18,
                          maxRadius: 18,
                          backgroundImage: NetworkImage(
                            documentSnapshot['profImage'],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 6, 5),
                              child: documentSnapshot["rating"].length == 0
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.5),
                                          child: RatingBarIndicator(
                                            itemSize: 18,
                                            rating: (documentSnapshot['rating']
                                                        .reduce(
                                                            (a, b) => a + b) /
                                                    documentSnapshot['rating']
                                                        .length)
                                                .toDouble(), //get the average of the rating array and convert it to double
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          " (${documentSnapshot['rating'].length})",
                                          style: TextStyle(
                                              color: mBackgroundColor),
                                        ),
                                      ],
                                    ),
                            ),
                            Text(
                              documentSnapshot['name'],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: mBackgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  String collection_name = 'user-recipes';
                  int numFields =
                      (documentSnapshot.data() as Map<String, dynamic>)
                          .keys
                          .toList()
                          .length;
                  if (numFields >= 5) {
                    //6 fields including the source of the recipe
                    //check if number of fields is 5 (complete)
                    pushNewScreen(
                      context,
                      screen: RecipeOverview(
                          documentSnapshot.id,
                          collection_name,
                          documentSnapshot['imageUrl'],
                          documentSnapshot['name'],
                          documentSnapshot['source'],
                          documentSnapshot['description'],
                          documentSnapshot['ingredients'],
                          documentSnapshot['steps'],
                          documentSnapshot['steps-timer'],
                          documentSnapshot['rating'],
                          'public'),
                      withNavBar: false,
                    );
                  } else {
                    const recipeSnackbar = SnackBar(
                        content: Text("Sorry, recipe is not yet available."));
                    ScaffoldMessenger.of(context).showSnackBar(recipeSnackbar);
                  }
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  // SUGGESTED RECIPES WIDGETS
  Widget suggestedRecipesStream(BuildContext context) {
    return StreamBuilder(
      stream: _suggestedRecipeCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> suggestedRecipeSnapshot) {
        if (suggestedRecipeSnapshot.hasData) {
          print(suggestedRecipeSnapshot.data!.docs.length);
          return suggestedRecipesBuilder(
              context, suggestedRecipeSnapshot.data!.docs);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget suggestedRecipesBuilder(BuildContext context, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Suggested For You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 0.5,
            aspectRatio: 1.45, // to change the height of the cards in carousel
            padEnds: false,
          ),
          itemCount: items.length,
          itemBuilder: ((context, index, realIndex) {
            final DocumentSnapshot documentSnapshot = items[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: appBarColor.withOpacity(0.5),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: documentSnapshot['imageUrl'],
                      imageBuilder: (context, imageProvider) => Ink(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              documentSnapshot['imageUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            color: mPrimaryColor,
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 6, 5),
                              child: documentSnapshot["rating"].length == 0
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.5),
                                          child: RatingBarIndicator(
                                            itemSize: 18,
                                            rating: (documentSnapshot['rating']
                                                        .reduce(
                                                            (a, b) => a + b) /
                                                    documentSnapshot['rating']
                                                        .length)
                                                .toDouble(), //get the average of the rating array and convert it to double
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          " (${documentSnapshot['rating'].length})",
                                          style: TextStyle(
                                              color: mBackgroundColor),
                                        ),
                                      ],
                                    ),
                            ),
                            Text(
                              documentSnapshot['name'],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: mBackgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  String collection_name = 'premade-recipes';
                  int numFields =
                      (documentSnapshot.data() as Map<String, dynamic>)
                          .keys
                          .toList()
                          .length;
                  if (numFields >= 5) {
                    //6 fields including the source of the recipe
                    //check if number of fields is 5 (complete)
                    pushNewScreen(
                      context,
                      screen: RecipeOverview(
                          documentSnapshot.id,
                          collection_name,
                          documentSnapshot['imageUrl'],
                          documentSnapshot['name'],
                          documentSnapshot['source'],
                          documentSnapshot['description'],
                          documentSnapshot['ingredients'],
                          documentSnapshot['steps'],
                          documentSnapshot['steps-timer'],
                          documentSnapshot['rating'],
                          'public'),
                      withNavBar: false,
                    );
                  } else {
                    const recipeSnackbar = SnackBar(
                        content: Text("Sorry, recipe is not yet available."));
                    ScaffoldMessenger.of(context).showSnackBar(recipeSnackbar);
                  }
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

// class buildBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           headerWithSearchBar(size: size),
//           TitleWithMoreBttn(
//             title: 'Recommended',
//           )
//         ],
//       ),
//     );
//   }
// }

// class TitleWithMoreBttn extends StatelessWidget {
//   const TitleWithMoreBttn({
//     Key? key,
//     required this.title,
//   }) : super(key: key);
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           TitleWithUnderline(
//             text: title,
//           ),
//           Spacer(),
//           TextButton(
//             style: (TextButton.styleFrom(
//               backgroundColor: appBarColor,
//             )),
//             onPressed: () {},
//             child: Text(
//               'More',
//               style:
//                   TextStyle(color: mBackgroundColor, fontFamily: 'Montserrat'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
