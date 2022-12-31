import 'package:elective_project/edit_recipe/edit_steps.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../util/colors.dart';

class EditIngredients extends StatefulWidget {
  EditIngredients(
      this.userId,
      this.recipeId,
      this.recipeImage,
      this.recipeName,
      this.recipeCategory,
      this.recipePrivacy,
      this.recipeIngredients,
      this.recipeSteps,
      this.recipeStepTimer);

  final String userId;
  final String recipeId;
  final Uint8List? recipeImage;
  final String recipeName;
  final String recipeCategory;
  final String recipePrivacy;
  final List recipeIngredients;
  final List recipeSteps;
  final List recipeStepTimer;

  @override
  State<EditIngredients> createState() => _EditIngredientsState();
}

class _EditIngredientsState extends State<EditIngredients> {
  late int _ingredientCount;
  late List<Map<String, dynamic>> _ingredientValues;
  late String _ingredientResult;
  late List ingredientsList;

  List _initialPlaceholders = [
    'Ingredient 1',
    'Ingredient 2',
    'Ingredient 3',
  ];

  void initState() {
    super.initState();
    _ingredientCount = widget.recipeIngredients.length;
    _ingredientValues = [];
    _ingredientResult = '';
    for (int i = 0; i < widget.recipeIngredients.length; i++) {
      _onUpdate(i, widget.recipeIngredients[i]);
    }

    if (_ingredientCount > _initialPlaceholders.length) {
      for (int i = _ingredientCount - _initialPlaceholders.length; i >= 0; i--) {
        _initialPlaceholders
            .add("Ingredient ${_ingredientCount - i}");
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(_initialPlaceholders);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text('Edit Recipe'),
        ),
        backgroundColor: mBackgroundColor,
        body: SafeArea(
            child: ListView(padding: EdgeInsets.all(10.0), children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.recipeName,
              style: GoogleFonts.bebasNeue(
                fontSize: 30,
                color: appBarColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _ingredientCount,
                    itemBuilder: (context, key) {
                      return _rowIngredients(key);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              _ingredientCount++;
                              _initialPlaceholders
                                  .add("Ingredient ${_ingredientCount}");
                            });
                            print(_ingredientCount);
                            print(_initialPlaceholders);
                          },
                          icon: Icon(
                            FluentIcons.add_circle_32_filled,
                            size: 30.0,
                          )),
                      IconButton(
                          onPressed: () async {
                            if (_ingredientCount > 0) {
                              setState(() {
                                _ingredientCount--;
                                _initialPlaceholders
                                    .removeAt(_ingredientCount - 1);
                              });
                              _ingredientValues.removeAt(_ingredientCount);
                            }
                            print(_ingredientCount);
                            print(_initialPlaceholders);
                            print(_ingredientValues.toString());
                          },
                          icon: Icon(
                            FluentIcons.subtract_circle_32_filled,
                            size: 30.0,
                          )),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ingredientsList = _ingredientValues.map((item) => item['value']).toList();
                    // print(widget.recipeName);
                    // print(widget.recipeCategory);
                    // print(widget.recipePrivacy);
                    // print(ingredientsList);
                    // pushNewScreen(context,
                    //     screen: AddSteps(widget.recipeName, widget.recipeCategory,
                    //         widget.recipePrivacy, ingredientsList),
                    //     withNavBar: true);

                    ingredientsList =
                        _ingredientValues.map((item) => item['value']).toList();

                    print(widget.userId);
                    print(widget.recipeId);
                    print(widget.recipeImage.toString());
                    print(widget.recipeName);
                    print(widget.recipeCategory);
                    print(widget.recipePrivacy);
                    print(_ingredientValues.toString());
                    print(ingredientsList);
                    print(widget.recipeSteps);
                    print(widget.recipeStepTimer);

                    if (ingredientsList.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Ingredients should not be empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: splashScreenBgColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      pushNewScreen(context,
                          screen: EditSteps(
                              widget.userId,
                              widget.recipeId,
                              widget.recipeImage,
                              widget.recipeName,
                              widget.recipeCategory,
                              widget.recipePrivacy,
                              ingredientsList,
                              widget.recipeSteps,
                              widget.recipeStepTimer));
                    }
                  },
                  child: Text("Next"),
                  style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
                )
              ],
            ),
          ),
        ])));
  }

  _rowIngredients(int key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              maxLines: 2,
              minLines: 1,
              initialValue: key < widget.recipeIngredients.length
                  ? widget.recipeIngredients[key]
                  : null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Ingredient ${key + 1}',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mPrimaryColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: mPrimaryColor,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (val) {
                _onUpdate(key, val);
              },
            ),
          ),
        ],
      ),
    );
  }

  _onUpdate(int key, String val) {
    int foundKey = -1;
    for (var map in _ingredientValues) {
      // check if certain key already exist
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (foundKey != -1) {
      _ingredientValues.removeWhere((map) =>
          map['id'] ==
          foundKey); //remove the element (using its key) that is already existent in the list(json)
    }
    Map<String, dynamic> json = {
      'id': key,
      'value': val
    }; // for multiple values: 'values' : {text: val, number: num}
    _ingredientValues.add(json); // adds element to the list(json)
    _ingredientValues
        .sort((a, b) => a['id'].compareTo(b['id'])); // sort the list using id

    setState(() {
      _ingredientResult = _ingredientValues.toString();
      print(_ingredientResult);
    });
  }
}
