import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userDetailViewArg {
  Key key;
  final String title;
  final FirebaseUser user;
  final VoidCallback editDetail;
  userDetailViewArg({key ,this.title, this.user, this.editDetail});
}
