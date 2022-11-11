// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
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
                'COMMUNITY',
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
