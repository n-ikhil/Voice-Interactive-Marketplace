//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:myna/services/firebase/auth.dart';
//
//class userDetailView extends StatefulWidget {
//  userDetailView({Key key, this.title, this.user, this.editDetail})
//      : super(key: key);
//  final String title;
//  final FirebaseUser user;
//  final VoidCallback editDetail;
//
//  @override
//  userDetailViewState createState() => userDetailViewState();
//}
//
//class userDetailViewState extends State<userDetailView> {
//  var name, email, photoUrl, uid, emailVerified;
//  FirebaseUser _user;
//  @override
//  void initState() {
//      _user = widget.user;
//  }
//
//  fetchUserData() async {
//    if (_user != null) {
//      String name = _user.getDisplayName();
//      String email = _user.getEmail();
//      Uri photoUrl = _user.getPhotoUrl();
//
//      // Check if user's email is verified
//      boolean emailVerified = user.isEmailVerified();
//
//      // The user's ID, unique to the Firebase project. Do NOT use this value to
//      // authenticate with your backend server, if you have one. Use
//      // FirebaseUser.getIdToken() instead.
//      String uid = user.getUid();
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
