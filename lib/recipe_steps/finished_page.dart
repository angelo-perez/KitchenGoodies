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
import '../util/utils.dart';

class FinishedRecipePage extends StatefulWidget {
  FinishedRecipePage(this.recipe_image, this.recipe_name);
  final String recipe_image;
  final String recipe_name;

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

  @override
  Widget build(BuildContext context) {
    FlutterRingtonePlayer.stop();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF12A2726),
      ),
      backgroundColor: Color(0xFFF2E5D9),
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
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
              child: Text(
                'Congratulations',
                style: GoogleFonts.bebasNeue(
                  fontSize: 45,
                  color: const Color(0xFF6e3d28),
                ),
                textAlign: TextAlign.center,
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
                print(rating);
              },
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF12A2726)),
              onPressed: () {
                pushNewScreen(context, screen: CreateDishPost());
              },
              child: Text(
                'Share',
                style: TextStyle(color: Color(0xFFF2E5D9)),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF12A2726)),
              onPressed: (){},
              child: Text(
                'Recipes',
                style: TextStyle(color: Color(0xFFF2E5D9)),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF12A2726)),
              onPressed: (){},
              child: Text(
                'Home',
                style: TextStyle(color: Color(0xFFF2E5D9)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
