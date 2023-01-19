import 'package:elective_project/resources/auth_methods.dart';
import 'package:elective_project/util/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../community_page/models/user.dart' as model;
import '../resources/storage_methods.dart';
import '../util/utils.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _newConfirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _newConfirmPasswordController.dispose();
  }

  void editUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().changeUserPassword(
      password: _passwordController.text,
      confirmNewPassword: _confirmPasswordController.text,
      newPassword: _newConfirmPasswordController.text,
      context: context,
    );

    if (res == 'Success') {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: res,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: splashScreenBgColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(color: mPrimaryTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading ? const LinearProgressIndicator() : Container(),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "We recommend that you periodically update your password to help prevent unauthorized access to your account.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      children: <Widget>[
                        textFieldWidget(
                          txtController: _passwordController,
                          labeltxt: "Current Password",
                          obscurebool: true,
                        ),
                        textFieldWidget(
                          txtController: _confirmPasswordController,
                          labeltxt: "New Password",
                          obscurebool: true,
                        ),
                        textFieldWidget(
                          txtController: _newConfirmPasswordController,
                          labeltxt: "Confirm New Password",
                          obscurebool: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              editUser();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mPrimaryColor,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              "Save changes",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class textFieldWidget extends StatelessWidget {
  const textFieldWidget({
    Key? key,
    required this.txtController,
    required this.labeltxt,
    this.obscurebool = false,
    this.maxlines = 1,
  }) : super(key: key);

  final TextEditingController txtController;
  final String labeltxt;
  final bool obscurebool;
  final int maxlines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextField(
        maxLines: maxlines,
        controller: txtController,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        obscureText: obscurebool,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: labeltxt,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: mPrimaryColor,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: mPrimaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
