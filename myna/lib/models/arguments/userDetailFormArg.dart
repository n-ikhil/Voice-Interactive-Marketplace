import 'package:flutter/material.dart';
import 'package:myna/services/firebase/auth.dart';

class userDetailFormArg {
  Key key;
  final String title;
  final Auth auth;
  final VoidCallback showDetail;
  userDetailFormArg({key, this.title, this.auth, this.showDetail});
}
