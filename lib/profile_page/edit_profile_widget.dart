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

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _image = "";
  bool _isLoading = false;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    String profImage = await StorageMethods().uploadImageToStorage('profilePictures', im, false);
    setState(() {
      _image = profImage;
    });
  }

  void editUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().editUser(
      email: _emailController.text,
      username: _usernameController.text,
      profImage: _image,
      description: _descriptionController.text,
      password: _passwordController.text,
      context: context,
    );
    print(_image);
    if (res == 'Success') {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "res",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: splashScreenBgColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "res",
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
    final model.User user = Provider.of<UserProvider>(context).getUser;
    _emailController = TextEditingController(text: user.email);
    _usernameController = TextEditingController(text: user.username);
    _descriptionController = TextEditingController(text: user.description);
    _image = user.profImage;

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
          "Edit Profile",
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
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(_image),
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
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                        textFieldWidget(
                          txtController: _descriptionController,
                          labeltxt: "Description",
                          maxlines: 3,
                        ),
                        textFieldWidget(
                          txtController: _passwordController,
                          labeltxt: "Password",
                          obscurebool: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
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
