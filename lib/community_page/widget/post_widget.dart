import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/community_page/models/user.dart' as model;
import 'package:elective_project/community_page/widget/comments_screen.dart';
import 'package:elective_project/resources/firestore_methods.dart';
import 'package:elective_project/providers/user_provider.dart';
import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/utils.dart';
import 'package:elective_project/widget/like_animation.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../profile_page/view_profile.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  String listCheck(len) {
    if (widget.snap[len].length == 0) {
      return "  ";
    } else {
      return '${widget.snap[len].length}';
    }
  }

  String checker(int lencheck) {
    String len = "  ";
    if (lencheck == 0) {
      return len;
    } else {
      return "  ${lencheck.toString()}";
    }
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
      print(commentLen);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // HEADER SECTION INCLUDES USERNAME, PICTURE, & VERTICAL DOTS

          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewProfile(
                                uid: widget.snap["uid"],
                              ),
                            ),
                          ),
                          child: Text(
                            widget.snap["username"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mPrimaryTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            children: [
                              user.uid == widget.snap['uid']
                                  ? SimpleDialogOption(
                                      padding: const EdgeInsets.all(20),
                                      child: const Text("Delete"),
                                      onPressed: () async {
                                        FirestoreMethods().deletePost(widget.snap['postId']);
                                        Navigator.pop(context);
                                      },
                                    )
                                  : Container(),
                              SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    Navigator.pop(context);
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
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: mPrimaryColor,
                  ),
                ),
              ],
            ),
          ),

          // IMAGE SECTION
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              if (widget.snap['likes'].contains(user.uid)) {
                setState(() {
                  isLikeAnimating = true;
                });
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: mSecondColor,
                      size: 250,
                    ),
                  ),
                )
              ],
            ),
          ),

          // LIKE COMMENT SHARE SECTION
          Row(
            children: [
              Row(
                children: [
                  LikeAnimation(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                      onPressed: () async {
                        await FirestoreMethods().likePost(
                          widget.snap['postId'],
                          user.uid,
                          widget.snap['likes'],
                        );
                      },
                      icon: !widget.snap['likes'].contains(user.uid)
                          ? Icon(
                              Icons.favorite_border_outlined,
                              color: mSecondColor,
                            )
                          : Icon(
                              Icons.favorite,
                              color: mSecondColor,
                            ),
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      listCheck('likes'),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.comment_rounded,
                      color: mSecondColor,
                    ),
                    Text(
                      checker(commentLen), //'$commentLen',

                      style: TextStyle(color: mPrimaryTextColor),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  color: mSecondColor,
                ),
              ),
            ],
          ),
          // COMMENT SECTION
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: mPrimaryTextColor,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap['description'],
                          style: TextStyle(color: mSecondTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: TextStyle(fontSize: 13, color: mPrimaryTextColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
