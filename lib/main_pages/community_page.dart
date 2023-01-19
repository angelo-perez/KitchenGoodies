import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elective_project/community_page/widget/add_post_widget.dart';
import 'package:elective_project/community_page/widget/post_widget.dart';

import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';

import '../profile_page/view_profile.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final Query<Map<String, dynamic>> _users = FirebaseFirestore.instance.collection("users");

  List user = [];
  List userlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        centerTitle: false,
        title: Text(
          'Kitchen Buddies',
          style: TextStyle(color: appBarColor, fontWeight: FontWeight.w900, fontSize: 22),
        ),
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: appBarColor,
            height: 0.2,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ProfileSearchDelegate(userlist));
                searchUserStream(context);
              },
              icon: Icon(
                Icons.search,
                color: appBarColor,
              )),
        ],
      ),
      body: SafeArea(
        child: postStream(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPostWidget()));
        },
        icon: const Icon(Icons.post_add),
        label: const Text("Post"),
        backgroundColor: mPrimaryColor,
      ),
    );
  }

  Widget postStream(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy(
            'datePublished',
            descending: true,
          )
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => PostCard(
            snap: snapshot.data!.docs[index].data(),
          ),
        );
      },
    );
  }

  Widget searchUserStream(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          userlist = snapshot.data!.docs;
          print(userlist);
        }
        return Container();
      },
    );
  }
}

class ProfileSearchDelegate extends SearchDelegate {
  ProfileSearchDelegate(this.userlist);
  List userlist;
  var filteredList;
  List empty = [];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, null), //close searchbar
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        ),
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    List suggestions = userlist.where((user) {
      final result = user['username'].toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    if (query == '') {
      return Container();
    } else {
      filteredList = userStream(suggestions);
    }

    return filteredList;
  }

  Widget userStream(List userlist) {
    return ListView.builder(
        itemCount: userlist.length,
        itemBuilder: (context, index) {
          final DocumentSnapshot documentSnapshot = userlist[index];
          print(documentSnapshot['uid']);
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewProfile(
                    uid: documentSnapshot['uid'],
                  ),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  documentSnapshot['profImage'],
                ),
              ),
              title: Text(documentSnapshot['username']),
            ),
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return filteredList;
  }
}
