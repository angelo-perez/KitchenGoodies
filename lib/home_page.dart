// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2E5D9),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: const Center(
            child: Text(
              'HOME',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
              ),
            ),
          ),
        )
      ),
    );
  }
}
