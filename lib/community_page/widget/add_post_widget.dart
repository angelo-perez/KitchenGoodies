import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../main_pages/main_page.dart';
import '../../resources/firestore_methods.dart';
import '../../providers/user_provider.dart';
import '../../util/colors.dart';
import '../models/user.dart' as model;

class AddPostWidget extends StatefulWidget {
  const AddPostWidget({super.key});

  @override
  State<AddPostWidget> createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        uid,
        username,
        _file!,
        profImage,
      );
      if (res == "Success") {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Posted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: splashScreenBgColor,
            textColor: Colors.white,
            fontSize: 16.0);
        clearImage();
        // Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainPage(3)), (route) => false);
      } else {
        Fluttertoast.showToast(
            msg: res,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: splashScreenBgColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: splashScreenBgColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Add Picture'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a Photo'),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

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
          'Create Post',
          style: TextStyle(color: mPrimaryTextColor),
        ),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () => postImage(
                    user.uid,
                    user.username,
                    user.profImage,
                  ),
              child: Text(
                "Post",
                style: TextStyle(
                  color: mPrimaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ))
        ],
      ),
      body: ListView(
        //Column
        children: [
          _isLoading ? const LinearProgressIndicator() : Container(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.profImage,
                  // userProvider.getUser.profImage,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                  ),
                  //maxLines: 8, // needs readmore dependancy
                ),
              ),
              const Divider(
                indent: 10,
                endIndent: 80,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1),
          ),
          _file != null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _selectImage(context);
        },
        icon: const Icon(Icons.post_add),
        label: const Text("Add Picture"),
        backgroundColor: mPrimaryColor,
      ),
    );
  }
}
