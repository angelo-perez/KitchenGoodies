import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/community_page/models/user.dart' as model;
import 'package:elective_project/profile_page/widget/follow_button.dart';
import 'package:elective_project/resources/firestore_methods.dart';
import 'package:elective_project/util/colors.dart';
import 'package:elective_project/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ViewProfile extends StatefulWidget {
  final String uid;

  const ViewProfile({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String description = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;

      userData = userSnap.data()!;
      description = userSnap.data()!['description'];
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                userData["username"],
                style: TextStyle(color: mPrimaryColor),
              ),
              backgroundColor: mBackgroundColor,
              centerTitle: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: mPrimaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: mBackgroundColor,
                            backgroundImage: NetworkImage(
                              userData['profImage'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, 'posts'),
                                    buildStatColumn(followers, 'followers'),
                                    buildStatColumn(following, 'following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    user.uid == widget.uid
                                        ? FollowButton(
                                            backgroundColor: mBackgroundColor,
                                            borderColor: mPrimaryColor,
                                            text: 'Edit Description',
                                            textColor: Colors.grey,
                                            function: () {},
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundColor: mBackgroundColor,
                                                borderColor: mPrimaryColor,
                                                text: 'Following',
                                                textColor: Colors.grey,
                                                function: () async {
                                                  await FirestoreMethods().followUser(
                                                      FirebaseAuth.instance.currentUser!.uid,
                                                      userData['uid']);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundColor: mBackgroundColor,
                                                borderColor: mPrimaryColor,
                                                text: 'Follow',
                                                textColor: Colors.grey,
                                                function: () async {
                                                  await FirestoreMethods().followUser(
                                                      FirebaseAuth.instance.currentUser!.uid,
                                                      userData['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                          return Container(
                            child: Image(
                              image: NetworkImage(
                                snap['postUrl'],
                              ),
                              fit: BoxFit.contain,
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 4,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}