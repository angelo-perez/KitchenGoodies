// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/recipes_page/category_recipes_page.dart';
import 'package:filter_list/filter_list.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../recipes_page/recipe_overview.dart';
import '../util/colors.dart';

class RecipeCategories {
  late final int id;
  late final String imgPath;
  late final String categoryName;
  late final String description;

  RecipeCategories(this.id, this.imgPath, this.categoryName, this.description);
}

bool _isSearchButtonVisible = true;

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
  final Query<Map<String, dynamic>> _publicCollection = FirebaseFirestore
      .instance
      .collection('user-recipes')
      .where('privacy', isEqualTo: 'public')
      .orderBy('rating-count', descending: true);
  late List<QueryDocumentSnapshot<Object?>> publicRecipeList;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mBackgroundColor,
          title: Text(
            'Recipes',
            style: TextStyle(
                color: appBarColor, fontWeight: FontWeight.w900, fontSize: 22),
          ),
          elevation: 0.0,
          bottom: TabBar(
            labelColor: mPrimaryColor,
            indicatorColor: mPrimaryColor,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: mPrimaryColor,
                fontSize: 17),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3.0,
            tabs: [
              Tab(
                text: 'Premade',
              ),
              Tab(
                text: 'Public',
              )
            ],
            onTap: (value) {
              _isSearchButtonVisible = true;
            },
          ),
        ),
        backgroundColor: mBackgroundColor,
        body: TabBarView(
          children: [
            premadeRecipeCategories(context),
            publicRecipes(context),
          ],
        ),
      ),
    );
  }

  Widget publicRecipes(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: _publicCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> publicRecipeSnapshot) {
          if (publicRecipeSnapshot.hasData && publicRecipeSnapshot.data!.size > 0) {
            publicRecipeList = publicRecipeSnapshot.data!.docs;
            return publicRecipesBuilder(
                context, publicRecipeSnapshot.data!.docs); //temporary listview
          } else if (publicRecipeSnapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _emptyPublicRecipe(context);
          }
        },
      ),
    );
  }

  Widget premadeRecipeCategories(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        // Needed when wrapping inside ListView
        // physics:
        //     NeverScrollableScrollPhysics(), // to disable GridView's scrolling
        // shrinkWrap: true, // You won't see infinite size error
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
        itemBuilder: _premadeRecipeCategoryItem,
      ),
    );
  }

  Widget _premadeRecipeCategoryItem(BuildContext context, int _index) {
    RecipeCategories recipeCategory = recipeCategoryList[_index];

    final borderRadius = BorderRadius.circular(10);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: appBarColor.withOpacity(0.5), // Splash color
        onTap: () {
          print(recipeCategory.categoryName);
          pushNewScreen(context,
              screen: CategoryRecipesPage(recipeCategory.categoryName),
              withNavBar: true);
        },
        child: Stack(
          children: [
            Ink(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(recipeCategory.imgPath), // Background image
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                child: Text(
                  recipeCategory.categoryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mBackgroundColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget publicRecipesBuilder(BuildContext context, List items) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: _isSearchButtonVisible,
        child: FloatingActionButton(
          heroTag: "SearchPublicRecipeButton",
          backgroundColor: appBarColor,
          onPressed: (() {
            showSearch(
                context: context,
                delegate:
                    PublicRecipeSearchDelegate(publicRecipeList, "Public"));
          }),
          child: Icon(FluentIcons.search_48_filled, size: 30),
        ),
      ),
      body: ListView(
        children: [
          GridView.builder(
            // Needed when wrapping inside ListView
            physics:
                NeverScrollableScrollPhysics(), // to disable GridView's scrolling
            shrinkWrap: true, // You won't see infinite size error
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 262),
            primary: false,
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = items[index];
              final borderRadius = BorderRadius.circular(15);
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                child: InkWell(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: documentSnapshot['imageUrl'],
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      color: mPrimaryColor,
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Align(
                            heightFactor: 4.65,
                            // widthFactor: 4.6,
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                minRadius: 18,
                                maxRadius: 18,
                                backgroundImage: NetworkImage(
                                  documentSnapshot['profImage'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                        child: Text(
                          documentSnapshot["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: mPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                        child: Text(
                          'by ${documentSnapshot["source"]}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: mPrimaryColor,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
                        child: documentSnapshot["rating"].length == 0
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.5),
                                    child: RatingBarIndicator(
                                      itemSize: 18,
                                      rating: (documentSnapshot['rating']
                                                  .reduce((a, b) => a + b) /
                                              documentSnapshot['rating'].length)
                                          .toDouble(), //get the average of the rating array and convert it to double
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    " (${documentSnapshot['rating'].length})",
                                    style: TextStyle(color: appBarColor),
                                  ),
                                ],
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
                      ScaffoldMessenger.of(context)
                          .showSnackBar(recipeSnackbar);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _emptyPublicRecipe(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                'images/recipe-book-concept-illustration.png',
              ),
              height: 175,
              width: 250,
            ),
            Text('No Public Recipe Yet', style: TextStyle(fontSize: 18)),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              'Create one and share it to the Public!',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            )
          ]),
    );
  }
}

////FOR THE SEARCH BAR////

class PublicRecipeSearchDelegate extends SearchDelegate {
  PublicRecipeSearchDelegate(this.items, this.searchIn);
  List items;
  String searchIn;

  var filteredList;

  @override
  String get searchFieldLabel => 'Search in ${searchIn} Recipes';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        // TODO: implement buildActions
        IconButton(
          onPressed: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
              items: [
                PopupMenuItem<String>(
                    child: const Text('Chicken'), value: 'chicken'),
                PopupMenuItem<String>(child: const Text('Pork'), value: 'pork'),
                PopupMenuItem<String>(child: const Text('Beef'), value: 'beef'),
                PopupMenuItem<String>(child: const Text('Fish'), value: 'fish'),
                PopupMenuItem<String>(
                    child: const Text('Crustacean'), value: 'crustacean'),
                PopupMenuItem<String>(
                    child: const Text('Vegetables'), value: 'vegetables'),
                PopupMenuItem<String>(
                    child: const Text('Dessert'), value: 'dessert'),
                PopupMenuItem<String>(
                    child: const Text('Others'), value: 'others'),
              ],
              elevation: 8.0,
            ).then((value) {
              if (value == null) return;
              query = value;
            });
          },
          icon: Icon(Icons.filter_list_alt),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
        _isSearchButtonVisible = false;
      }, //close searchbar
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return filteredList;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    _isSearchButtonVisible = false;

    List suggestions = items.where((item) {
      final nameResult = item["name"].toLowerCase();
      final sourceResult = item["source"].toLowerCase();
      final collectionResult = item["collection"].toLowerCase();
      final input = query.toLowerCase();

      return nameResult.contains(input) ||
          sourceResult.contains(input) ||
          collectionResult.contains(input);
    }).toList();

    for (int i = 0; i < suggestions.length; i++) {
      print(suggestions[i]["name"]);
    }

    filteredList =
        _RecipesPageState().publicRecipesBuilder(context, suggestions);

    return filteredList;
  }
}
