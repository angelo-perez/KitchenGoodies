import 'package:elective_project/create_recipe/add_picture.dart';
import 'package:elective_project/resources/timer_functions.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import '../resources/timer_formatter.dart';
import '../util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSteps extends StatefulWidget {
  AddSteps(this.recipeName, this.recipeDescription, this.recipeCategory,
      this.recipePrivacy, this.recipeIngredients);

  final String recipeName;
  final String recipeDescription;
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
  int _tempTimer = 0;

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
      backgroundColor: mBackgroundColor,
      body: SafeArea(
        child: ListView(padding: EdgeInsets.all(10.0), children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Text(
              'Add the Procedure',
              style: GoogleFonts.bebasNeue(
                fontSize: 45,
                color: appBarColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(
            'Step 3: Next, add the procedure of your recipe.',
            style: TextStyle(fontSize: 20),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(
            widget.recipeName,
            style: GoogleFonts.bebasNeue(
              fontSize: 40,
              color: appBarColor,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () async {
                      setState(() {
                        _stepCount++;
                        _initialPlaceholders.add("Step ${_stepCount}");
                        //_tempTimer = 0; //reset default timer to 0
                      });
                      print(_stepCount);
                      print(_initialPlaceholders);
                    },
                    icon: Icon(
                      FluentIcons.add_circle_32_filled,
                      size: 30.0,
                    )),
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
                      FluentIcons.subtract_circle_32_filled,
                      size: 30.0,
                    )),
              ],
            ),
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

              if (stepsArray.isEmpty ||
                  timerArray.isEmpty ||
                  stepsArray.length < timerArray.length ||
                  stepsArray.contains("") ||
                  stepsArray.contains(" ")) {
                Fluttertoast.showToast(
                    msg: "Procedure should not be empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: splashScreenBgColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                pushNewScreen(context,
                    screen: AddPicture(
                        widget.recipeName,
                        widget.recipeDescription,
                        widget.recipeCategory,
                        widget.recipePrivacy,
                        widget.recipeIngredients,
                        stepsArray,
                        timerArray),
                    withNavBar: true);
              }
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
              maxLines: 3,
              minLines: 1,
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

                if (_timerValues.length == _stepValues.length) {
                  //to not reset timer to 0 if it is > 0
                  if (_timerValues[key]["timer"] > 0) {
                    _onTimerUpdate(key, _timerValues[key]["timer"]);
                  }
                } else {
                  _onTimerUpdate(key, 0);
                }
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0)),
          Expanded(
            child: TextFormField(
              //initialValue: '00:00:00',
              // controller: _txtTimeController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                hintText: 'hh:mm:ss',
                label: Text(
                  'Timer',
                  textAlign: TextAlign.center,
                ),
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appBarColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: appBarColor,
                    width: 2,
                  ),
                ),
              ),
              inputFormatters: <TextInputFormatter>[
                TimeTextInputFormatter(), // This input formatter will do the job
              ],
              onChanged: (value) {
                value = value != ""
                    ? value
                    : "00:00:00"; //sets time to 0 when empty string to avoid error
                int timerInSecs =
                    TimerFunctions().timerToSecs(value); //convert the entered time in seconds
                _tempTimer = timerInSecs;
                print(value);
                print(timerInSecs);

                _onTimerUpdate(key, timerInSecs); //updates the 'timer' value in timerValues list of object
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
