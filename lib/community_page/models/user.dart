import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profImage;
  final String username;
  // final String bio;
  // final List followers;
  // final List following;

  const User({
    required this.username,
    required this.uid,
    required this.profImage,
    required this.email,
    // required this.bio,
    // required this.followers,
    // required this.following
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      profImage: snapshot["profImage"],
      // bio: snapshot["bio"],
      // followers: snapshot["followers"],
      // following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "profImage": profImage,
        // "bio": bio,
        // "followers": followers,
        // "following": following,
      };
}
