import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source, bool isProfilePicture) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file;

  if (isProfilePicture) {
    _file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 0,
    );
  } else {
    _file = await _imagePicker.pickImage(source: source);
  }

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}
