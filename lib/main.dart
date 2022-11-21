import 'dart:ui';

import 'package:elective_project/main_pages/community_page.dart';
import 'package:elective_project/main_pages/create_page.dart';
import 'package:elective_project/resources/google_sign_in.dart';
import 'package:elective_project/main_pages/login_page.dart';
import 'package:elective_project/main_pages/main_page.dart';
import 'package:elective_project/main_pages/setting_page.dart';
import 'package:elective_project/main_pages/signIn_page.dart';
import 'package:elective_project/main_pages/signUp_page.dart';
import 'package:elective_project/main_pages/splash_page.dart';
import 'package:elective_project/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'main_pages/home_page.dart';
import 'main_pages/recipes_page.dart';
import 'main_pages/community_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//to make scrolls work on web through mouse
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF12A2726),
          
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const MainPage();
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  '${snapshot.error}',
                ));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFFFFFF),
                ),
              );
            }
            return const SplashPage();
          },
        ),
      ),
    );
  }
}
