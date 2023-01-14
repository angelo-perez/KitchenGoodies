import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';

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

class TitleWithUnderline extends StatelessWidget {
  const TitleWithUnderline({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0 / 4),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: 20.0 / 4),
              height: 7,
              color: appBarColor.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
