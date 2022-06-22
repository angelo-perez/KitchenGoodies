import 'package:elective_project/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    var time = Duration(seconds: 3);
    Future.delayed(time, () {
      Navigator.pushAndRemoveUntil(this.context, MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }), (route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/test-images/bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SvgPicture.asset('images/test-images/logo.svg'),
        ),
      ),
    );
  }
}
