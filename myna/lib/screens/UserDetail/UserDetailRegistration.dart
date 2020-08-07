
import 'package:flutter/material.dart';
import 'package:myna/services/firebase/auth.dart';

class userDetailForm extends  StatefulWidget {
  userDetailForm({Key key, this.title, this.auth, this.editDetail}) : super(key: key);
  final String title;
  final BaseAuth auth;
  final VoidCallback editDetail;
  @override
  userDetailFormState createState() => userDetailFormState();
}

class  userDetailFormState extends State<userDetailForm> {
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
