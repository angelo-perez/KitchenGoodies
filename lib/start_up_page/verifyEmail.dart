import 'dart:async';

import 'package:elective_project/main_pages/main_page.dart';
import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/google_sign_in.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      // Fluttertoast.showToast(
      //     msg: "Something went wrong",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.SNACKBAR,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: splashScreenBgColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? MainPage(0)
      : Scaffold(
          appBar: AppBar(
            backgroundColor: mBackgroundColor,
            title: Text(
              "Verify Email",
              style: TextStyle(color: appBarColor, fontSize: 22),
            ),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email has been sent to your email',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromRadius(24),
                    backgroundColor: mPrimaryColor,
                  ),
                  icon: const Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: const Text(
                    "Resend Email",
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () => _onCancelAccount(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24, color: mPrimaryTextColor),
                  ),
                ),
              ],
            ),
          ),
        );
}

Future<bool> _onCancelAccount(BuildContext context) async {
  bool deleteAccount = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Cancel Verification"),
        content: const Text("Are you sure you want to cancel?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              final googleProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
              googleProvider.logout(context);
            },
            child: Text(
              "Yes",
              style: TextStyle(color: mPrimaryTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              "No",
              style: TextStyle(color: mPrimaryTextColor),
            ),
          ),
        ],
      );
    },
  );
  return deleteAccount;
}
