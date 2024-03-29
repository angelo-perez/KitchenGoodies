import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/create_recipe/create_page.dart';
import 'package:elective_project/edit_recipe/edit_name_picture.dart';
import 'package:elective_project/resources/manage_recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../recipes_page/recipe_overview.dart';
import '../util/colors.dart';

class MyRecipesPage extends StatefulWidget {
  MyRecipesPage({Key? key}) : super(key: key);

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  //String privacy = "";

  bool _noRecipeCreated = false;

  List myRecipeList = [];

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;

    final Query<Map<String, dynamic>> _myRecipes = FirebaseFirestore.instance
        .collection("user-recipes")
        .where('uid', isEqualTo: uid);

    return Scaffold(
        backgroundColor: mBackgroundColor,
        appBar: AppBar(
          backgroundColor: mBackgroundColor,
          title: Text(
            'My Recipes',
            style: TextStyle(
                color: appBarColor, fontWeight: FontWeight.w900, fontSize: 22),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: MyRecipeSearchDelegate(myRecipeList));
                },
                icon: Icon(
                  Icons.search,
                  color: appBarColor,
                )),
          ],
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: appBarColor,
          onPressed: () {
            pushNewScreen(context, screen: CreatePage(), withNavBar: true);
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
            child: StreamBuilder(
                stream: _myRecipes.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> myRecipeSnapshot) {
                  print("in");
                  if (myRecipeSnapshot.hasData &&
                      myRecipeSnapshot.data!.size > 0) {
                    print("recipes found");
                    myRecipeList = myRecipeSnapshot.data!.docs;
                    return _myRecipeListViewBuilder(
                        context, myRecipeSnapshot.data!.docs);
                  } else if (myRecipeSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    print("loading");
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    print("no recipe");
                    //_noRecipeCreated = !_noRecipeCreated;
                    return _emptyMyRecipe(context);
                  }
                })));
  }

  Widget _myRecipeListViewBuilder(BuildContext context, List items) {
    return ListView(
      children: [
        ListView.builder(
            itemCount: items.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = items[index];

              String privacy = documentSnapshot["privacy"];

              return Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const DrawerMotion(),
                  // A pane can dismiss the Slidable.
                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      autoClose: false,
                      onPressed: (context) {
                        setState(() {
                          if (privacy == "Private" || privacy == "private") {
                            privacy = "public";
                          } else {
                            privacy = "private";
                          }
                        });

                        final User? user = auth.currentUser;
                        final uid = user!.uid;

                        ManageRecipe toggleRecipePrivacy = ManageRecipe();
                        toggleRecipePrivacy.toggleRecipePrivacy(
                            uid, documentSnapshot.id, privacy);
                        print(privacy);
                      },
                      backgroundColor: Color.fromARGB(255, 95, 131, 80),
                      foregroundColor: Colors.white,
                      icon: documentSnapshot["privacy"] == "Private" ||
                              documentSnapshot["privacy"] == "private"
                          ? Icons.visibility_off_sharp
                          : Icons.visibility,
                      label: documentSnapshot["privacy"][0].toUpperCase() +
                          documentSnapshot['privacy'].substring(1),
                    ),
                    // SHARE BUTTON IS NOT YET IMPLEMENTED
                  ],
                ),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        final User? user = auth.currentUser;
                        final uid = user!.uid;

                        pushNewScreen(context,
                            screen: EditNamePicture(
                                uid,
                                documentSnapshot.id,
                                documentSnapshot["imageUrl"],
                                documentSnapshot["name"],
                                documentSnapshot["description"],
                                documentSnapshot["collection"],
                                documentSnapshot["privacy"],
                                documentSnapshot["ingredients"],
                                documentSnapshot["steps"],
                                documentSnapshot["steps-timer"]),
                            withNavBar: true);
                      },
                      backgroundColor: Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        final User? user = auth.currentUser;
                        final uid = user!.uid;

                        deleteRecipeDialog(
                            context,
                            uid,
                            documentSnapshot.id,
                            documentSnapshot['name'],
                            documentSnapshot['imageUrl']);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),

                // The child of the Slidable is what the user sees when the
                // component is not dragged.
                child: Container(
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
                                documentSnapshot['collection'],
                                documentSnapshot['imageUrl'],
                                documentSnapshot['name'],
                                documentSnapshot['source'],
                                documentSnapshot['description'],
                                documentSnapshot['ingredients'],
                                documentSnapshot['steps'],
                                documentSnapshot['steps-timer'],
                                documentSnapshot['rating'],
                                'myrecipe'),
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
                        child: CachedNetworkImage(
                          imageUrl: documentSnapshot["imageUrl"],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Center(
                                    child: CircularProgressIndicator(
                                        color: mPrimaryColor,
                                        value: downloadProgress.progress),
                                  ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      title: Text(documentSnapshot["name"]),
                      subtitle: Text(
                          'Last Modified: ${documentSnapshot["date"].toDate()}'),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ),
                ),
              );
            }),
        Padding(padding: EdgeInsets.only(bottom: 5))
      ],
    );
  }

  Widget _emptyMyRecipe(BuildContext context) {
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
            Text('No saved recipe yet', style: TextStyle(fontSize: 18)),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              'Tap "+" button to create a recipe',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            )
          ]),
    );
  }

  void doNothing(BuildContext context) {}

  void deleteRecipeDialog(BuildContext myrecipeContext, String uid,
      String recipeId, String recipeName, String recipeImage) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to delete ${recipeName}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              ManageRecipe deleteRecipe = ManageRecipe();

              deleteRecipe
                  .deleteRecipe(uid, recipeId, recipeImage)
                  .whenComplete(() {
                Navigator.pop(myrecipeContext);
                Fluttertoast.showToast(
                    msg: "Successfully deleted ${recipeName}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: splashScreenBgColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
              });
              Navigator.of(context).pop();
            },
            child: new Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: "${recipeName} was not deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: splashScreenBgColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            child: new Text('No'),
          ),
        ],
      ),
    );
  }
}

class MyRecipeSearchDelegate extends SearchDelegate {
  MyRecipeSearchDelegate(this.items);
  List items;

  var filteredList;

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
    return filteredList;
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

    filteredList =
        _MyRecipesPageState()._myRecipeListViewBuilder(context, suggestions);
    return filteredList;
  }
}
