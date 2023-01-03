import 'package:carousel_slider/carousel_slider.dart';
import 'package:elective_project/resources/facebook_sign_in.dart';
import 'package:elective_project/providers/google_sign_in.dart';
import 'package:elective_project/main.dart';
import 'package:elective_project/start_up_page/signIn_page.dart';
import 'package:elective_project/start_up_page/signUp_page.dart';
import 'package:elective_project/resources/verify_sign_in.dart';
import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/utils.dart';
import 'package:elective_project/widget/sliderDot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../main_pages/main_page.dart';

final List<String> imgList = [
  'images/logos/kitchen-goodies.png',
  'images/vectors/pan_with_vegetables.jpg',
  'images/vectors/young-woman-baking-cooking-at-home_.jpg',
  'images/vectors/recipe-take-picure.jpg',
];
final List<String> titleList = [
  'Welcome to Kitchen Goodies',
  'Complete List of Ingredients',
  'Step-by-step Procedure',
  'Share your Dish'
];
final List<String> descriptionList = [
  'Cooking is love made visible!',
  'Complete and detailed list of ingredients for every recipe',
  'Cooking procedure progress gradually ',
  'Interact and share your dishes to Kitchen Buddies'
];

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggedIn = false;

  Map _userObj = {};

  int _current = 0;

  List<Widget> carouselItem = imgList
      .map(
        (item) => Container(
          width: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Image(image: AssetImage(item), fit: BoxFit.contain)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    titleList[imgList.indexOf(item)],
                    style: TextStyle(
                        color: appBarColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    descriptionList[imgList.indexOf(item)],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final CarouselController _controller = CarouselController();
    return Scaffold(
        backgroundColor: mBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                child: CarouselSlider(
                  items: carouselItem,
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      aspectRatio: 0.8,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : appBarColor)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                          backgroundColor: appBarColor,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SignInPage();
                          }));
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                              side: BorderSide(
                                color: appBarColor,
                              )),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: appBarColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (context) => VerifyGoogleSignIn()));
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                      side: BorderSide(
                        color: appBarColor,
                      )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'images/test-images/google.svg',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: appBarColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // FACEBOOK LOGIN (Unfixed)
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   child: TextButton(
              //     onPressed: () async {
              //       await FacebookSignIn().facebookLogin();
              //       Navigator.of(context).pushReplacement(MaterialPageRoute(
              //           builder: (context) => VerifyGoogleSignIn()));
              //     },
              //     style: TextButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(36),
              //         ),
              //         side: BorderSide(
              //           color: mFacebookColor,
              //         )),
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(vertical: 10),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: <Widget>[
              //           SvgPicture.asset('images/test-images/facebook.svg'),
              //           const SizedBox(
              //             width: 12,
              //           ),
              //           Text(
              //             'Sign in with Facebook',
              //             style: TextStyle(
              //               color: mFacebookColor,
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
