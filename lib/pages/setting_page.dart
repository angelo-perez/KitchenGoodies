import 'package:elective_project/resources/google_sign_in.dart';
import 'package:elective_project/pages/login_page.dart';
import 'package:elective_project/resources/auth_methods.dart';
import 'package:elective_project/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
  
    final user =
        FirebaseAuth.instance.currentUser; // access current user's data

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Image.asset('images/test-images/coffee_time.png'),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Get the best coffee in town!',
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
                        onPressed: () async {
                          // await AuthMethods().signOut();
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (context) => LoginPage()));
                          final provider = Provider.of<GoogleSignInProvider>( // works only with GOOGLE SIGN IN
                              context,
                              listen: false);
                          provider.logout();
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
                            "Sign Out",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ));
  }
}
