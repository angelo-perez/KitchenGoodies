import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/test-images/bg.png'),
          ),
        ),
        child: Center(
          child: SvgPicture.asset('images/test-images/logo.svg'),
        ),
      ),
    );
  }
}
