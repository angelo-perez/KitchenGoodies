import 'package:elective_project/main_pages/community_page/models/user.dart' as model;
import 'package:elective_project/resources/firestore_methods.dart';
import 'package:elective_project/resources/user_provider.dart';
import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String listCheck(len) {
    if (widget.snap[len].length == 0) {
      return "     ";
    } else {
      return '  ${widget.snap[len].length}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'] + "  ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mPrimaryTextColor,
                          ),
                        ),
                        TextSpan(
                          text: widget.snap['text'],
                          style: TextStyle(
                            color: mPrimaryTextColor,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mPrimaryTextColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await FirestoreMethods().likeComment(
                widget.snap['postId'],
                widget.snap['commentId'],
                user.uid,
                widget.snap['likes'],
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    child: !widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite_border_outlined,
                            color: mSecondColor,
                          )
                        : Icon(
                            Icons.favorite,
                            color: mSecondColor,
                          ),
                  ),
                  Text(
                    listCheck('likes'),
                    style: TextStyle(
                      color: mPrimaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
