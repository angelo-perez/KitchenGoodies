import 'dart:typed_data';

import 'package:elective_project/main.dart';
import 'package:elective_project/main_pages/home_page.dart';
import 'package:elective_project/main_pages/main_page.dart';
import 'package:elective_project/main_pages/recipes_page.dart';
import 'package:elective_project/recipe_steps/create_dish_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:social_share/social_share.dart';
import '../util/colors.dart';
import '../util/utils.dart';

class FinishedRecipePage extends StatefulWidget {
  FinishedRecipePage(this.recipe_image, this.recipe_name, this.recipe_source);
  final String recipe_image;
  final String recipe_name;
  final String recipe_source;

  @override
  State<FinishedRecipePage> createState() => _FinishedRecipePageState();
}

class _FinishedRecipePageState extends State<FinishedRecipePage> {
  // Uint8List? _image;

  // void initState() {
  //   recipeImgPlaceholder();
  //   super.initState();
  // }

  // void recipeImgPlaceholder() async {
  //   final ByteData bytes = await rootBundle
  //       .load('images/test-images/recipe-image-placeholder.jpg');
  //   final Uint8List list = bytes.buffer.asUint8List();
  //   setState(() {
  //     _image = list;
  //   });
  // }

  // void captureImage() async {
  //   Uint8List im = await pickImage(ImageSource.camera);
  //   setState(() {
  //     _image = im;
  //   });
  // }

  String ratingDisplay = "";

  @override
  Widget build(BuildContext context) {
    Color iconTextColor = Colors.white;
    FlutterRingtonePlayer.stop();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.recipe_name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "by ${widget.recipe_source}",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        elevation: 0,
        foregroundColor: mBackgroundColor,
        centerTitle: true,
      ),
      //extendBodyBehindAppBar: true,
      backgroundColor: appBarColor,
      body: Container(
        width: double.infinity,
        decoration: widget.recipe_image != null
            ? BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.recipe_image),
                    fit: BoxFit.cover,
                    opacity: 170),
              )
            : BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Well Done',
                style: GoogleFonts.bebasNeue(
                  fontSize: 50,
                  color: iconTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Text(
                'Enjoy your meal!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: iconTextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'How\'s the ${widget.recipe_name}?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: iconTextColor),
              ),
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  ratingDisplay = rating.toString();
                  print(ratingDisplay);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Text(
                ratingDisplay,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, color: iconTextColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: appBarColor,
                  fixedSize: Size(120, 40)),
              onPressed: () {
                pushNewScreen(context, screen: CreateDishPost());
              },
              child: Text(
                'Share',
                style: TextStyle(color: iconTextColor, fontSize: 18),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: appBarColor,
                  fixedSize: Size(120, 40)),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage(1)),
                    (route) => false);
              },
              child: Text(
                'Recipes',
                style: TextStyle(color: iconTextColor, fontSize: 18),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: appBarColor,
                  fixedSize: Size(120, 40)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(0)),
                    (route) => false);
              },
              child: Text(
                'Home',
                style: TextStyle(color: iconTextColor, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
