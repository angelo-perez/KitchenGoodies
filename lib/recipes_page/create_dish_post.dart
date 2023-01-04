import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import '../util/utils.dart';

class CreateDishPost extends StatefulWidget {
  const CreateDishPost({super.key});

  @override
  State<CreateDishPost> createState() => _CreateDishPostState();
}

class _CreateDishPostState extends State<CreateDishPost> {
  Uint8List? _image;

  void initState() {
    //recipeImgPlaceholder();
    super.initState();
  }

  void recipeImgPlaceholder() async {
    final ByteData bytes = await rootBundle
        .load('images/test-images/recipe-image-placeholder.jpg');
    final Uint8List list = bytes.buffer.asUint8List();
    setState(() {
      _image = list;
    });
  }

  void captureImage() async {
    Uint8List im = await pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      captureImage();
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF12A2726),
        ),
        backgroundColor: Color(0xFFF2E5D9),
        body: SafeArea(
          child: ListView(
            children: [
              Card(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: 4, //or null
                          decoration: InputDecoration.collapsed(
                              hintText: "Say something about your dish..."),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              _image!,
                              fit: BoxFit.cover,
                            )),
                      )
                    ],
                  )),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF12A2726),
                        fixedSize: Size(90, 45),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFFF2E5D9)),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF12A2726), 
                        fixedSize: Size(90, 45),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Post',
                      style: TextStyle(color: Color(0xFFF2E5D9)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
