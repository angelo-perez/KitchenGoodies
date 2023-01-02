// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/food_tiles.dart';
import 'package:elective_project/util/food_types.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          leading: SvgPicture.asset(
            'images/logos/kitchen-goodies.svg',
            color: Colors.white,
          ),
          title: Text(
            'Kitchen Goodies',
            style: TextStyle(fontFamily: 'Sanford', color: Colors.white),
          ),
          titleSpacing: 0,
        ),
        body: Column(
          children: [
            //find the best recipe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Find the Best Recipe For You',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 50,
                  color: Color(0xFF12A2726),
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

            // Horizontal listview of recipe tiles
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                RecipeTile(
                  foodImagePath: 'images/adob.jpg',
                  foodName: 'Adobo',
                ),
                RecipeTile(
                  foodImagePath: 'images/bicol-express.jpg',
                  foodName: 'Bicol Express',
                ),
                RecipeTile(
                  foodImagePath: 'images/kare-kare.jpg',
                  foodName: 'Kare-Kare',
                ),
                RecipeTile(
                  foodImagePath: 'images/menudo.jpg',
                  foodName: 'Menudo',
                ),
              ],
            )),
          ],
        ));
  }
}
