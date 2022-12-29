import 'package:elective_project/create_recipe/add_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../util/colors.dart';

class AddSteps extends StatefulWidget {
  AddSteps(this.recipeName, this.recipeCategory, this.recipePrivacy, this.recipeIngredients);

  final String recipeName;
  final String recipeCategory;
  final String recipePrivacy;
  final List recipeIngredients;

  @override
  State<AddSteps> createState() => _AddAddStepsState();
}

class _AddAddStepsState extends State<AddSteps> {
  late int _stepCount;
  late List<Map<String, dynamic>> _stepValues;
  late List<Map<String, dynamic>> _timerValues;
  late String _stepResult;
  late String _timerResult;
  late List stepsArray; //Steps array to be uploaded in the Database
  late List timerArray; //Timer array to be uploaded in the Database

  List _initialPlaceholders = [
    'Step 1',
    'Step 2',
    'Step 3',
  ];

  void initState() {
    super.initState();
    _stepCount = _initialPlaceholders.length;
    _stepValues = [];
    _timerValues = [];
    _stepResult = '';
    _timerResult = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Create Recipe'),
      ),
      body: SafeArea(
        child: ListView(padding: EdgeInsets.all(10.0), children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Text(
              'Add the steps',
              style: GoogleFonts.bebasNeue(
                fontSize: 45,
                color: const Color(0xFF6e3d28),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(
            'Step 3: Next, add the steps of your recipe.',
            style: TextStyle(fontSize: 20),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(
            widget.recipeName,
            style: GoogleFonts.bebasNeue(
              fontSize: 40,
              color: const Color(0xFF6e3d28),
            ),
            textAlign: TextAlign.center,
          ),
          ListView.builder(
              padding: const EdgeInsets.all(10.0),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _stepCount,
              itemBuilder: (context, key) {
                return _row(key);
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    if (_stepCount > 0) {
                      setState(() {
                        _stepCount--;
                        _initialPlaceholders.removeAt(_stepCount);
                      });
                    }
                    print(_stepCount);
                    print(_initialPlaceholders);
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    size: 30.0,
                  )),
              IconButton(
                  onPressed: () async {
                    setState(() {
                      _stepCount++;
                      _initialPlaceholders.add("Ingredient ${_stepCount}");
                    });
                    print(_stepCount);
                    print(_initialPlaceholders);
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 30.0,
                  )),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              stepsArray = _stepValues.map((item) => item['step']).toList();
              timerArray = _timerValues.map((item) => item['timer']).toList();
              print(widget.recipeName);
              print(widget.recipeCategory);
              print(widget.recipePrivacy);
              print(widget.recipeIngredients);
              print(stepsArray);
              print(timerArray);
              pushNewScreen(context,
                  screen: AddPicture(widget.recipeName, widget.recipeCategory, widget.recipePrivacy,
                      widget.recipeIngredients, stepsArray, timerArray),
                  withNavBar: true);
            },
            child: Text("Next"),
            style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
          )
        ]),
      ),
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
                _onTimerUpdate(key, 0);
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0)),
          Expanded(
            child: SpinBox(
              min: 0,
              max: 100,
              value: 0,
              //onChanged: (value) => print(value),
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
