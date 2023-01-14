import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';

class headerWithSearchBar extends StatelessWidget {
  const headerWithSearchBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.5),
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.2 - 27,
            decoration: BoxDecoration(
              color: appBarColor,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'Find your best recipe',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sanford',
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
