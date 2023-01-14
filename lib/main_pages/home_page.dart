// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/food_tiles.dart';
import 'package:elective_project/util/food_types.dart';
import 'package:elective_project/util/header_with_search_bar.dart';
import 'package:elective_project/util/recommended_with_more_bttn.dart';
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
        elevation: 8,
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
      body: buildBody(),
    );
  }
}

class buildBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          headerWithSearchBar(size: size),
          TitleWithMoreBttn(
            title: 'Recommended',
          )
        ],
      ),
    );
  }
}

class TitleWithMoreBttn extends StatelessWidget {
  const TitleWithMoreBttn({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          TitleWithUnderline(
            text: title,
          ),
          Spacer(),
          TextButton(
            style: (TextButton.styleFrom(
              backgroundColor: appBarColor,
            )),
            onPressed: () {},
            child: Text(
              'More',
              style:
                  TextStyle(color: mBackgroundColor, fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
    );
  }
}
