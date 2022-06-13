// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:elective_project/util/food_tiles.dart';
import 'package:elective_project/util/food_types.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //food types
  final List foodType = [
    [
      'Pork',
      true,
    ],
    [
      'Beef',
      false,
    ],
    [
      'Chicken',
      false,
    ],
    [
      'Dessert',
      false,
    ],
  ];

  // user tapped on food types
  void foodTypeSelected(int index) {
    setState(() {
      for (int i = 0; i < foodType.length; i++) {
        foodType[i][1] = false;
      }
      foodType[index][1] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2E5D9),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.menu,
            color: const Color(0xFF6e3d28),
          ),
          actions: [
            Padding(padding: const EdgeInsets.only(right: 30.0)),
            Icon(
              Icons.person,
              color: const Color(0xFF6e3d28),
            )
          ],
        ),
        body: Column(
          children: [
            //find the best recipe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Find the best recipe for you',
                style: GoogleFonts.bebasNeue(
                  fontSize: 56,
                  color: const Color(0xFF6e3d28),
                ),
              ),
            ),

            SizedBox(height: 25),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Find recipe ...',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      // ignore: use_full_hex_values_for_flutter_colors
                      color: const Color(0xff12a2726),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xff12a2726),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            //Horizontal view recipe tiles
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: foodType.length,
                  itemBuilder: (context, index) {
                    return FoodTypes(
                      foodType: foodType[index][0],
                      isSelected: foodType[index][1],
                      onTap: () {
                        foodTypeSelected(index);
                      },
                    );
                  },
                ),
              ),
            ),

            // Horizontal listview of recipe tiles
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                RecipeTile(
                  foodImagePath: 'lib/images/adob.jpg',
                  foodName: 'Adobo',
                ),
                RecipeTile(
                  foodImagePath: 'lib/images/bicol-express.jpg',
                  foodName: 'Bicol Express',
                ),
                RecipeTile(
                  foodImagePath: 'lib/images/kare-kare.jpg',
                  foodName: 'Kare-Kare',
                ),
                RecipeTile(
                  foodImagePath: 'lib/images/menudo.jpg',
                  foodName: 'Menudo',
                ),
              ],
            )),
          ],
        ));
  }
}
