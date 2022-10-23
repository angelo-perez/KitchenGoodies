import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FinishedRecipePage extends StatefulWidget {
  const FinishedRecipePage({Key? key}) : super(key: key);
  

  @override
  State<FinishedRecipePage> createState() => _FinishedRecipePageState();
}

class _FinishedRecipePageState extends State<FinishedRecipePage> {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text('Congrats')),
    );
  }
}
