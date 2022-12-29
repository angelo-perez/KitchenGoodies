import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String text;
  final String uid;
  final String name;
  final likes;
  final String commentId;
  final DateTime datePublished;
  final String profilePic;

  const Post(
      {required this.text,
      required this.uid,
      required this.name,
      required this.likes,
      required this.commentId,
      required this.datePublished,
      required this.profilePic});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        text: snapshot["text"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        commentId: snapshot["commentId"],
        datePublished: snapshot["datePublished"],
        name: snapshot["name"],
        profilePic: snapshot["profilePic"]);
  }

  Map<String, dynamic> toJson() => {
        "text": text,
        "uid": uid,
        "likes": likes,
        "name": name,
        "commentId": commentId,
        "datePublished": datePublished,
        "profilePic": profilePic,
      };
}
