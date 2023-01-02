import 'dart:typed_data';

import 'package:elective_project/resources/manage_recipe.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../main_pages/main_page.dart';
import '../util/colors.dart';

class EditSteps extends StatefulWidget {
  EditSteps(
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
  State<EditSteps> createState() => _EditStepsState();
}

class _EditStepsState extends State<EditSteps> {
  late int _stepCount;
  late List<Map<String, dynamic>> _stepValues;
  late List<Map<String, dynamic>> _timerValues;
  late String _stepResult;
  late String _timerResult;
  late List stepsArray; //Steps array to be uploaded in the Database
  late List timerArray; //Timer array to be uploaded in the Database
  double _tempTimer = 0; //for resetting the step timer

  void initState() {
    super.initState();
    _stepCount = widget.recipeSteps.length;
    _stepValues = [];
    _timerValues = [];
    _stepResult = '';
    _timerResult = '';

    for (int i = 0; i < widget.recipeSteps.length; i++) {
      _onStepUpdate(i, widget.recipeSteps[i]);
      _onTimerUpdate(i, widget.recipeStepTimer[i]);
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Edit Recipe'),
      ),
      backgroundColor: mBackgroundColor,
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(10),
        children: [
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
              "Procedure",
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
                      itemCount: _stepCount,
                      itemBuilder: (context, key) {
                        return _row(key);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                if (_stepCount <= _stepValues.length) {
                                  if (_stepCount < widget.recipeSteps.length) {
                                    _onStepUpdate(_stepCount,
                                        widget.recipeSteps[_stepCount]);
                                    _onTimerUpdate(_stepCount,
                                        widget.recipeStepTimer[_stepCount]);
                                  } else {
                                    _onStepUpdate(_stepCount, "");
                                  }
                                } else {
                                  _onStepUpdate(_stepCount, "");
                                }
                                _stepCount++;
                              });

                              print(_stepCount);
                              print(widget.recipeSteps);
                              print(_stepValues.toList());
                              print(widget.recipeStepTimer);
                              print(_timerValues.toList());
                            },
                            icon: Icon(
                              FluentIcons.add_circle_32_filled,
                              size: 30.0,
                            )),
                        IconButton(
                            onPressed: () {
                              if (widget.recipeIngredients.isNotEmpty) {
                                setState(() {
                                  if (_stepCount >= _stepValues.length) {
                                    _stepValues.removeLast();
                                    _timerValues.removeLast();
                                  }
                                  _stepCount--;
                                });
                              }
                              print(_stepCount);
                              print(widget.recipeSteps);
                              print(_stepValues.toList());
                              print(widget.recipeStepTimer);
                              print(_timerValues.toList());
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
                      stepsArray =
                          _stepValues.map((item) => item['step']).where((element) => element != "").toList(); //converts object to list and filtering it.
                      timerArray =
                          _timerValues.map((item) => item['timer']).toList();

                      print(widget.userId);
                      print(widget.recipeId);
                      print(widget.recipeImage.toString());
                      print(widget.recipeName);
                      print(widget.recipeCategory);
                      print(widget.recipePrivacy);
                      print(_stepValues.toString());
                      print(_timerValues.toString());
                      print(stepsArray);
                      print(timerArray);

                      if (stepsArray.isEmpty ||
                          timerArray.isEmpty ||
                          stepsArray.length < timerArray.length ||
                          stepsArray.contains("") ||
                          stepsArray.contains(" ")) {
                        Fluttertoast.showToast(
                            msg: "A step should not be empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: splashScreenBgColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        ManageRecipe updateRecipe = ManageRecipe();

                        Fluttertoast.showToast(
                              msg: "Your recipe is now being saved",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: splashScreenBgColor,
                              textColor: Colors.white,
                              fontSize: 16.0);

                        updateRecipe.updateRecipe(
                            userId: widget.userId,
                            recipeId: widget.recipeId,
                            recipeName: widget.recipeName,
                            recipeCategory: widget.recipeCategory,
                            recipePrivacy: widget.recipePrivacy,
                            recipeIngredients: widget.recipeIngredients,
                            recipeSteps: stepsArray,
                            recipeTimer: timerArray,
                            recipeImage: widget.recipeImage).whenComplete(() => Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainPage(2)), //should go to "myrecipe tab" not in homepage
                              (route) => false));
                        print("success");
                      }
                    },
                    child: Text("Save Recipe"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: appBarColor),
                  )
                ],
              ))
        ],
      )),
    );
  }

  _row(int key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              //controller: TextEditingController(),
              maxLines: 3,
              minLines: 1,
              initialValue: key < widget.recipeSteps.length
                  ? widget.recipeSteps[key]
                  : null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Step ${key + 1}',
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
                _onStepUpdate(key, val);
                _onTimerUpdate(key, _tempTimer.toInt());
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0)),
          Expanded(
            child: SpinBox(
              min: 0,
              max: 100,
              value: key < widget.recipeStepTimer.length
                  ? widget.recipeStepTimer[key].toDouble()
                  : 0,
              spacing: 4,
              decoration: InputDecoration(
                labelText: 'Timer (minutes)',
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
                _tempTimer = val;
                _onTimerUpdate(key, val.toInt());
              },
            ),
          )
        ],
      ),
    );
  }

  _onStepUpdate(int key, String val) {
    int foundKey = -1;
    for (var map in _stepValues) {
      // check if certain key already exist
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (foundKey != -1) {
      _stepValues.removeWhere((map) =>
          map['id'] ==
          foundKey); //remove the element (using its key) that is already existent in the list(json)
    }
    Map<String, dynamic> json = {
      'id': key,
      'step': val
    }; // for multiple values: 'values' : {text: val, number: num}

    _stepValues.add(json); // adds element to the list(json)
    _stepValues
        .sort((a, b) => a['id'].compareTo(b['id'])); // sort the list using id

    setState(() {
      _stepResult = _stepValues.toString();
      print(_stepResult);
    });
  }

  _onTimerUpdate(int key, int val) {
    int foundKey = -1;
    for (var map in _timerValues) {
      // check if certain key already exist
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (foundKey != -1) {
      _timerValues.removeWhere((map) =>
          map['id'] ==
          foundKey); //remove the element (using its key) that is already existent in the list(json)
    }
    Map<String, dynamic> json = {
      'id': key,
      'timer': val
    }; // for multiple values: 'values' : {text: val, number: num}

    _timerValues.add(json); // adds element to the list(json)
    _timerValues
        .sort((a, b) => a['id'].compareTo(b['id'])); // sort the list using id

    setState(() {
      _timerResult = _timerValues.toString();
      print(_timerResult);
    });
  }
}
