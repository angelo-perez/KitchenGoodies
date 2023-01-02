// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class RecipeTile extends StatelessWidget {
  final String foodImagePath;
  final String foodName;

  RecipeTile({
    required this.foodImagePath,
    required this.foodName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
      child: Container(
        padding: EdgeInsets.all(12),
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //recipe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(foodImagePath),
            ),

            //recipe title
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
