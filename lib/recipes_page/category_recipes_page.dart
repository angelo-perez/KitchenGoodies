import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/recipes_page/recipe_overview.dart';
import 'package:elective_project/resources/manage_recipe.dart';
import 'package:elective_project/util/colors.dart';
import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../main_pages/recipes_page.dart';
import '../main.dart';
import 'package:collection/collection.dart';

class CategoryRecipesPage extends StatefulWidget {
  CategoryRecipesPage(this.category_name);

  String category_name;

  @override
  State<CategoryRecipesPage> createState() => _CategoryRecipesPageState();
}

class _CategoryRecipesPageState extends State<CategoryRecipesPage> {
  PageController _controller = PageController(viewportFraction: 0.75);
  CarouselController _carouselController = CarouselController();
  late String collection_name;
  int _selectedIndex = 0;
  int _current = 0;
  bool _listview = false;
  late List recipeList;

  void ToggleView() {
    setState(() {
      _listview = !_listview;
      // _selectedIndex = 0;
      _current = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String categoryName = widget.category_name;

    switch (categoryName) {
      case 'Chicken':
        {
          collection_name = 'chicken-recipe';
        }
        break;
      case 'Pork':
        {
          collection_name = 'pork-recipe';
        }
        break;
      case 'Beef':
        {
          collection_name = 'beef-recipe';
        }
        break;
      case 'Fish':
        {
          collection_name = 'fish-recipe';
        }
        break;
      case 'Crustacean':
        {
          collection_name = 'crustacean-recipe';
        }
        break;
      case 'Vegetables':
        {
          collection_name = 'vegetables-recipe';
        }
        break;
      case 'Dessert':
        {
          collection_name = 'dessert-recipe';
        }
        break;
      case 'Others':
        {
          collection_name = 'others-recipe';
        }
        break;
      default:
        {
          collection_name = 'chicken-recipe';
        }
        break;
    }

    String searchIn = "Premade";

    final CollectionReference _premadeCollection =
        FirebaseFirestore.instance.collection(collection_name);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: appBarColor),
        title: Text(
          '${categoryName} Recipes',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: RecipesSearchDelegate(recipeList, searchIn));
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                ToggleView();
                print(_listview);
              },
              icon: !_listview
                  ? Icon(
                      FluentIcons.apps_list_detail_20_filled,
                      color: Colors.black,
                    )
                  : Icon(
                      FluentIcons.app_recent_20_filled,
                      color: Colors.black,
                    ))
        ],
      ),
      backgroundColor: mBackgroundColor,
      body: recipeStreamBuilder(context, _premadeCollection),
    );
  }

  Widget recipeStreamBuilder(
      BuildContext context, CollectionReference collectionReference) {
    return StreamBuilder(
        stream: collectionReference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            recipeList = streamSnapshot.data!.docs;
            return _listview
                ? _listView(context, streamSnapshot.data!.docs)
                : _carouselView(context, streamSnapshot.data!.docs);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _carouselView(BuildContext context, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: items.length,
          itemBuilder: ((context, index, realIndex) {
            final DocumentSnapshot documentSnapshot = items[index];
            _selectedIndex = index;
            return _recipeListItem(context, documentSnapshot, index);
          }),
          options: CarouselOptions(
            aspectRatio: 0.9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 13.0,
                height: 13.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : mPrimaryColor)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _recipeListItem(BuildContext context,
      DocumentSnapshot documentSnapshot, int _selectedIndex) {
    final borderRadius = BorderRadius.circular(10);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: appBarColor.withOpacity(0.5),
        onTap: () {
          int numFields = (documentSnapshot.data() as Map<String, dynamic>)
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
              ),
              withNavBar: false,
            );
          } else {
            const recipeSnackbar =
                SnackBar(content: Text("Sorry, recipe is not yet available."));
            ScaffoldMessenger.of(context).showSnackBar(recipeSnackbar);
          }
        },
        child: Stack(children: [
          Ink(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: DecorationImage(
                    image: NetworkImage(documentSnapshot['imageUrl']),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              child: Column(
                children: [
                  Text(
                    documentSnapshot["name"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mBackgroundColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'by ${documentSnapshot["source"]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mBackgroundColor,
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: documentSnapshot["rating"].length == 0
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                style: TextStyle(color: mBackgroundColor),
                              ),
                            ],
                          ),
                  ),
                ],
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
        ]),
      ),
    );
  }

  Widget _listView(BuildContext context, List items) {
    return ListView(
      children: [
        Padding(padding: EdgeInsets.only(top: 5)),
        ListView.builder(
            itemCount: items.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = items[index];
              return Container(
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: appBarColor, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    isThreeLine: true,
                    visualDensity: VisualDensity(vertical: 4),
                    onTap: () {
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
                          ),
                          withNavBar: false,
                        );
                      } else {
                        const recipeSnackbar = SnackBar(
                            content:
                                Text("Sorry, recipe is not yet available."));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(recipeSnackbar);
                      }
                    },
                    leading: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Image(
                        image: NetworkImage(
                          documentSnapshot['imageUrl'],
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    title: Text(documentSnapshot['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "by ${documentSnapshot['source']}",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: documentSnapshot["rating"].length == 0
                              ? Container()
                              : Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.5),
                                      child: RatingBarIndicator(
                                        itemSize: 18,
                                        rating: (documentSnapshot['rating']
                                                    .reduce((a, b) => a + b) /
                                                documentSnapshot['rating']
                                                    .length)
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
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              );
            }),
        Padding(padding: EdgeInsets.only(bottom: 5)),
      ],
    );
  }
}

////FOR THE SEARCH BAR////

class RecipesSearchDelegate extends SearchDelegate {
  RecipesSearchDelegate(this.items, this.searchIn);
  List items;
  String searchIn;

  @override
  String get searchFieldLabel => 'Search in ${searchIn} Recipes';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        // TODO: implement buildActions
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
      onPressed: () => close(context, null), //close searchbar
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    List suggestions = items.where((item) {
      final result = item["name"].toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    for (int i = 0; i < suggestions.length; i++) {
      print(suggestions[i]["name"]);
    }

    return _CategoryRecipesPageState()._listView(context, suggestions);
  }
}
