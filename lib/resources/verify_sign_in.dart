import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/start_up_page/login_page.dart';
import 'package:elective_project/main_pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/google_sign_in.dart';

class VerifyGoogleSignIn extends StatelessWidget {
  const VerifyGoogleSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
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
    );
  }
}
