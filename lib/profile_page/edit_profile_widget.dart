import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/profile_page/about_widget.dart';
import 'package:elective_project/resources/auth_methods.dart';
import 'package:elective_project/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../community_page/models/user.dart';
import '../providers/google_sign_in.dart';
import '../providers/user_provider.dart';
import '../community_page/models/user.dart' as model;
import '../resources/storage_methods.dart';
import '../util/utils.dart';

class EditProfileWidget extends StatefulWidget {
  EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _image = "";

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    String profImage = await StorageMethods().uploadImageToStorage('profilePictures', im, false);
    setState(() {
      _image = profImage;
    });
  }

  @override
  void initState() {
    setImage();
    super.initState();
  }

  void setImage() async {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    setState(() {
      _image = user.profImage;
      print("_image");
    });
  }

  void editUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().EditUser(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        profImage: _image);
    print(_image);
    if (res == 'Success') {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    } else {
      showSnackBar(res, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    _emailController = TextEditingController(text: user.email);
    _usernameController = TextEditingController(text: user.username);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: mPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: mPrimaryTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(user.profImage),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: mPrimaryColor,
                      ),
                      child: IconButton(
                          onPressed: () => selectImage(),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: <Widget>[
                    textFieldWidget(
                      txtController: _usernameController,
                      labeltxt: "Username",
                    ),
                    textFieldWidget(
                      txtController: _emailController,
                      labeltxt: "Email",
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    textFieldWidget(
                      txtController: _passwordController,
                      labeltxt: "Password",
                      obscurebool: true,
                    ),
                    textFieldWidget(
                      txtController: _confirmPasswordController,
                      labeltxt: "Confirm Password",
                      obscurebool: true,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => editUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mPrimaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Edit Profile",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  }) : super(key: key);

  final TextEditingController txtController;
  final String labeltxt;
  final bool obscurebool;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextField(
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
