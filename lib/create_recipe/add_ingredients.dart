import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../util/colors.dart';

class AddIngredients extends StatefulWidget {
  AddIngredients(this.recipeName);

  final String recipeName;

  @override
  State<AddIngredients> createState() => _AddIngredientsState();
}

class _AddIngredientsState extends State<AddIngredients> {
  late int _ingredientCount;
  late List<Map<String, dynamic>> _values;
  late String _result;
  late List ingredientsList;

  List _initialPlaceholders = [
    'Ingredient 1',
    'Ingredient 2',
    'Ingredient 3',
  ];

  void initState() {
    super.initState();
    _ingredientCount = _initialPlaceholders.length;
    _values = [];
    _result = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Kitchen Goodies',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: scaffoldBackgroundColor,
          ),
        ),
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(padding: EdgeInsets.all(10.0), children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Text(
              'Create Your Own Recipe',
              style: GoogleFonts.bebasNeue(
                fontSize: 45,
                color: const Color(0xFF6e3d28),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(
            'Step 2: Then, add the ingredients of your recipe.',
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
              itemCount: _ingredientCount,
              itemBuilder: (context, key) {
                return _row(key);
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    if (_ingredientCount > 0) {
                      setState(() {
                        _ingredientCount--;
                        _initialPlaceholders.removeAt(_ingredientCount);
                      });
                    }
                    print(_ingredientCount);
                    print(_initialPlaceholders);
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    size: 30.0,
                  )),
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
                    Icons.add_circle,
                    size: 30.0,
                  )),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              ingredientsList = _values.map((item) => item['value']).toList();
              print(ingredientsList);
              // pushNewScreen(context,
              //     screen: AddRecipeIngredients(widget.recipeName),
              //     withNavBar: true);
            },
            child: Text("Next"),
            style: ElevatedButton.styleFrom(backgroundColor: appBarColor),
          )
        ]),
      ),
    );
  }

  _row(int key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            //controller: TextEditingController(),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Ingredient ${key + 1}',
              labelStyle: const TextStyle(color: Colors.grey),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: mPrimaryColor,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: mPrimaryColor,
                  width: 2,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            onChanged: (val) {
              _onUpdate(key, val);
            },
          ),
        ),
      ],
    );
  }

  _onUpdate(int key, String val) {
    int foundKey = -1;
    for (var map in _values) {
      // check if certain key already exist
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (foundKey != -1) {
      _values.removeWhere((map) =>
          map['id'] ==
          foundKey); //remove the element (using its key) that is already existent in the list(json)
    }
    Map<String, dynamic> json = {
      'id': key,
      'value': val
    }; // for multiple values: 'values' : {text: val, number: num}
    _values.add(json); // adds element to the list(json)
    _values.sort((a, b) => a['id'].compareTo(b['id'])); // sort the list using id

    setState(() {
      _result = _values.toString();
      print(_result);
    });
  }
}
