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

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  bool _isLoggedIn = false;
  Map _userObj = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2E5D9),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Image.asset('images/test-images/coffee_time.png'),
              const SliderDot(),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Cooking is love\nmade visible!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mPrimaryTextColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => SignUpPage()));
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                          backgroundColor: Color(0xFF6e3d28),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const SignInPage();
                          }));
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                              side: BorderSide(
                                color: Color(0xFF6e3d28),
                              )),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFF6e3d28),
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
                    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    provider.googleLogin();
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (context) => VerifyGoogleSignIn()));
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                      side: BorderSide(
                        color: mFacebookColor,
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
                            color: mFacebookColor,
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
