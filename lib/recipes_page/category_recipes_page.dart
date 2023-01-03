import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/recipe_steps/recipe_overview.dart';
import 'package:elective_project/util/colors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../main_pages/recipes_page.dart';
import '../main.dart';

class CategoryRecipesPage extends StatefulWidget {
  CategoryRecipesPage(this.category_name);

  String category_name;

  @override
  State<CategoryRecipesPage> createState() => _CategoryRecipesPageState();
}

class _CategoryRecipesPageState extends State<CategoryRecipesPage> {
  int _index = 0;
  PageController _controller = PageController(viewportFraction: 0.75);
  late String collection_name;
  int _selectedIndex = 0;
  bool _listview = false;
  late List recipeList;

  void ToggleView() {
    setState(() {
      _listview = !_listview;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
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

      final CollectionReference _categoryRecipes =
          FirebaseFirestore.instance.collection(collection_name);

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // leading: SvgPicture.asset(
          //   'images/logos/kitchen-goodies.svg',
          //   color: Colors.black,
          // ),
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
                      delegate: RecipesSearchDelegate(recipeList));
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
        body: StreamBuilder(
            stream: _categoryRecipes.snapshots(),
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
            }),
      );
    } catch (e) {
      print(e.toString());
      print("Work still in progress...");
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _carouselView(BuildContext context, List items) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 400, // card height
            child: PageView.builder(
              itemCount: items.length,
              controller: _controller,
              onPageChanged: (int index) =>
                  setState(() => _selectedIndex = index),
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = items[index];
                return Transform.scale(
                    scale: index == _selectedIndex ? 1 : 0.85,
                    child: Card(
                        elevation: 8,
                        color: appBarColor,
                        child: Card(
                            elevation: 6,
                            child: _recipeListItem(
                                context, documentSnapshot, _selectedIndex))));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: items.length,
            effect: ScaleEffect(
              activePaintStyle: PaintingStyle.stroke,
              scale: 1.7,
              activeStrokeWidth: 1.5,
              dotHeight: 10.0,
              dotWidth: 10.0,
              dotColor: appBarColor,
              activeDotColor: Color.fromARGB(255, 10, 1, 1),
            ),
            // onDotClicked: (index) {
            //   setState(() => _selectedIndex = index);
            // },
          )
        ]);
  }

  Widget _recipeListItem(BuildContext context,
      DocumentSnapshot documentSnapshot, int _selectedIndex) {
    return InkWell(
      splashColor: Colors.black26,
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
                documentSnapshot['imageUrl'],
                documentSnapshot['name'],
                documentSnapshot['source'],
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
        width: 300,
        fit: BoxFit.cover,
        child: Center(
          child: Container(
            width: double.maxFinite,
            color: Color.fromARGB(160, 0, 0, 0),
            child: Text(
              documentSnapshot['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
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
                              documentSnapshot['imageUrl'],
                              documentSnapshot['name'],
                              documentSnapshot['source'],
                              documentSnapshot['ingredients'],
                              documentSnapshot['steps'],
                              documentSnapshot['steps-timer']),
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
                    subtitle: Text(
                      "Source: ${documentSnapshot['source']}",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              );
            }),
        Padding(padding: EdgeInsets.only(bottom: 5)),
      ],
    );
  }
}

class RecipesSearchDelegate extends SearchDelegate {
  RecipesSearchDelegate(this.items);
  List items;

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
