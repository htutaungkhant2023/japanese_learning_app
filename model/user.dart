import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String name;
  String email;
  String uid;
  String? url;

  User({
    required this.name,
    required this.email,
    required this.uid,
    this.url
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'uid': uid,
      'url': url,
    };
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        name: snapshot['name'], email: snapshot['email'], uid: snapshot['uid'], url: snapshot['url']);
  }
}
