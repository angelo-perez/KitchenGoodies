import 'dart:ui';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:elective_project/start_up_page/login_page.dart';
import 'package:elective_project/providers/google_sign_in.dart';
import 'package:elective_project/main_pages/main_page.dart';
import 'package:elective_project/start_up_page/splash_page.dart';
import 'package:elective_project/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kitchen Goodies',
        theme: ThemeData(
          primaryColor: Color(0xFF12A2726),
          fontFamily: 'Montserrat',
        ),
        home: AnimatedSplashScreen(
          duration: 1500,
          splash: SvgPicture.asset('images/logos/kitchen-goodies.svg', color: Colors.white),
          centered: true,
          splashIconSize: 300,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Color(0xff2C2C2B),
          nextScreen: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.saveUserData(); // only works with google accounts
                  return MainPage(0);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong'),
                  );
                } else {
                  return LoginPage();
                }
              }),
        ),
      ),
    );
  }
}
