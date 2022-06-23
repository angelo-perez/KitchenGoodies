import 'package:elective_project/pages/signIn_page.dart';
import 'package:elective_project/pages/signUp_page.dart';
import 'package:elective_project/util/colors.dart';
import 'package:elective_project/widget/sliderDot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Get the best coffee\nin town!',
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
                          
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                          backgroundColor: mPrimaryColor,
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
                                color: mPrimaryColor,
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
                              color: Color(0xFFB98068),
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
                  onPressed: () {},
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
                        SvgPicture.asset('images/test-images/facebook.svg'),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Connect with Facebook',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  onPressed: () {},
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
                        SvgPicture.asset('images/test-images/facebook.svg'),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Connect with Gmail',
                          style: TextStyle(
                            color: mFacebookColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
