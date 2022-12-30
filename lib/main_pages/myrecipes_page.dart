import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/create_recipe/create_page.dart';
import 'package:elective_project/resources/manage_recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../recipe_steps/recipe_overview.dart';
import '../util/colors.dart';

class MyRecipesPage extends StatefulWidget {
  MyRecipesPage({Key? key}) : super(key: key);

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  bool _private = true;
  String privacy = "";

  bool _noRecipeCreated = false;

  List myRecipeList = [];

  void TogglePrivacy() {
    setState(() {
      _private = !_private;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final CollectionReference _myRecipes = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("MyRecipes");

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('My Recipes', style: TextStyle(color: appBarColor)),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: MyRecipeSearchDelegate(myRecipeList));
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ))
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

              if (documentSnapshot["privacy"] == "Private") {
                _private = true;
              } else {
                _private = false;
              }

              return Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),
                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const DrawerMotion(),
                  // A pane can dismiss the Slidable.
                  //dismissible: DismissiblePane(onDismissed: () {}),
                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      autoClose: true,
                      onPressed: (context) {
                        TogglePrivacy();

                        final User? user = auth.currentUser;
                        final uid = user!.uid;

                        String recipePrivacy = _private ? "Private" : "Public";

                        ManageRecipe toggleRecipePrivacy = ManageRecipe();
                        toggleRecipePrivacy.toggleRecipePrivacy(
                          uid,
                          documentSnapshot.id,
                          recipePrivacy
                        );

                        print(_private);
                      },
                      backgroundColor: Color.fromARGB(255, 0, 122, 6),
                      foregroundColor: Colors.white,
                      icon: _private
                          ? Icons.visibility_off_sharp
                          : Icons.visibility,
                      label: _private ? 'Private' : 'Public',
                    ),
                    SlidableAction(
                      onPressed: doNothing,
                      backgroundColor: Color.fromARGB(255, 98, 74, 136),
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Share',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        
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

                        deleteRecipeDialog(context, uid, documentSnapshot.id,
                            documentSnapshot['name']);
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
                            documentSnapshot["imageUrl"],
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      title: Text(documentSnapshot["name"]),
                      subtitle: Text('Description'),
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
      String recipeId, String recipeName) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to delete ${recipeName}?'),
        actions: <Widget>[
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
          TextButton(
            onPressed: () {
              final CollectionReference _myRecipes = FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .collection("MyRecipes");

              if (ManageRecipe().deleteRecipe(uid, recipeId) == 'success') {
                Navigator.pop(myrecipeContext);
                Fluttertoast.showToast(
                    msg: "Successfully deleted ${recipeName}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: splashScreenBgColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              Navigator.of(context).pop();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
}

class MyRecipeSearchDelegate extends SearchDelegate {
  MyRecipeSearchDelegate(this.items);
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
    // if (items.length == 0 || items != null) {
    //   return _MyRecipesPageState()._emptyMyRecipe(context);
    // }

    List suggestions = items.where((item) {
      final result = item["name"].toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    for (int i = 0; i < suggestions.length; i++) {
      print(suggestions[i]["name"]);
    }
    return _MyRecipesPageState()._myRecipeListViewBuilder(context, suggestions);
  }
}
