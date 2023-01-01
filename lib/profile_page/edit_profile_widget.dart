import 'package:elective_project/profile_page/about_widget.dart';
import 'package:elective_project/resources/auth_methods.dart';
import 'package:elective_project/util/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/google_sign_in.dart';
import '../providers/user_provider.dart';
import '../community_page/models/user.dart' as model;
import '../util/utils.dart';

class EditProfileWidget extends StatefulWidget {
  EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  Uint8List? _image;

  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
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
      file: _image!,
    );

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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: NetworkImage(user.profImage),
                      ),
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
              const SizedBox(height: 50),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: <Widget>[
                    textfieldWidget(
                      txtController: _usernameController,
                      labeltxt: "Username",
                    ),
                    textfieldWidget(
                      txtController: _emailController,
                      labeltxt: "Email",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: <Widget>[
                    textfieldWidget(
                      txtController: _passwordController,
                      labeltxt: "Password",
                      obscurebool: true,
                    ),
                    textfieldWidget(
                      txtController: _confirmPasswordController,
                      labeltxt: "Confirm Password",
                      obscurebool: true,
                    ),
                    const SizedBox(height: 50),
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

class textfieldWidget extends StatelessWidget {
  const textfieldWidget({
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
    return TextField(
      controller: txtController,
      keyboardType: TextInputType.text,
      obscureText: obscurebool,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: labeltxt,
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
    );
  }
}
