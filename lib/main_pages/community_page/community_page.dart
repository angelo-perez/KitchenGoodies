// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:elective_project/main_pages/community_page/widget/post.dart';
import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  // @override
  // State<CommunityPage> createState() => _CommunityPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'thanksgiving-text-title.svg',
          color: mPrimaryColor,
          height: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.messenger_outlined,
              color: mPrimaryColor,
            ),
          ),
        ],
      ),
      body: const PostCard(),
    );
  }
}









// class _CommunityPageState extends State<CommunityPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF2E5D9),
//       body: Center(
//           child: Container(
//             height: double.infinity,
//             width: double.infinity,
//             child: const Center(
//               child: Text(
//                 'COMMUNITY',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 50,
//                 ),
//               ),
//             ),
//           )
//         ),
//     );
//   }
// }
