//import 'dart:ffi';

import 'package:elective_project/start_up_page/signIn_page.dart';
import 'package:elective_project/resources/auth_methods.dart';
import 'package:elective_project/start_up_page/verifyEmail.dart';
import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/utils.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Uint8List? _image;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void defaultpp() async {
    final ByteData bytes = await rootBundle.load('images/user_placeholder.png');
    final Uint8List list = bytes.buffer.asUint8List();
    setState(() {
      _image = list;
    });
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery, true);
    setState(() {
      _image = im;
    });
  }

  @override
  void initState() {
    defaultpp();
    super.initState();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      file: _image!,
    );

    if (res == 'Success') {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => const VerifyEmail()));
    } else {
      Fluttertoast.showToast(
          msg: res,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: splashScreenBgColor,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    String APIHOST = 'doc-hosting.flycricket.io';
    var uri = Uri.https(APIHOST, url, {'q': 'dart'});
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mBackgroundColor, //Color(0xFFF2E5D9),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sign Up',
          style: TextStyle(color: appBarColor, fontSize: 22),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: appBarColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text(
                  'Welcome',
                  style: TextStyle(color: appBarColor, fontSize: 32, fontWeight: FontWeight.w500),
                ),
              ),
              // <--------- DEFAULT PICTURE --------->
              Center(
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage('images/user_placeholder.png'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // <--------- EMAIL, USERNAME, AND PASSWORD CONTAINER --------->
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: <Widget>[
                    // <--------- EMAIL --------->
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    // <--------- USERNAME --------->
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    // <--------- PASSWORD --------->
                    TextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mPrimaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(text: 'By clicking the Sign up button, you agree to our '),
                      TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(
                            color: mPrimaryColor,
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchUrl(
                                "/kitchen-goodies-terms-of-use/c89b2d33-03ee-4b5e-a77b-d9757ad6c799/terms")),
                      const TextSpan(text: ' and that you have read our '),
                      TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(
                            color: mPrimaryColor,
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchUrl(
                                "/kitchen-goodies-privacy-policy/1c986f35-3118-4bc2-aa0a-4e11c632157a/privacy")),
                    ],
                  )),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // <--------- SIGNUP CONTAINER --------->
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      signUpUser();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: mPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                        side: BorderSide(
                          color: mPrimaryColor,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: mBackgroundColor,
                                ),
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: TextStyle(color: mBackgroundColor, fontSize: 18),
                            ),
                    ),
                  ),
                ),
              ),

              // <--------- REGISTER CONTAINER --------->
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    children: [
                      const TextSpan(text: 'Already Have an Account?'),
                      TextSpan(
                        text: ' Sign In!',
                        style: TextStyle(
                          color: mPrimaryColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const SignInPage()));
                          },
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
