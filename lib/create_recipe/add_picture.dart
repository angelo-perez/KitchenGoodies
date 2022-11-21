import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPicture extends StatefulWidget {
  AddPicture(this.recipeName);

  final String recipeName;

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
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
        child: ListView(
          padding: EdgeInsets.all(10.0), 
          children: [
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
              'Step 4: Finally, add a picture of your recipe.',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 20),
                  child: IconButton(
                    onPressed: (() {
                    
                    }), 
                    icon: Icon(Icons.camera),
                    iconSize: 60,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20),
                  child: IconButton(
                    onPressed: (() {
                    
                    }), 
                    icon: Icon(Icons.photo_size_select_actual_rounded),
                    iconSize: 60,
                  ),
                ),
              ],
            ),
          ]
        )
      )
    );
  }
}