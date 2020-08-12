import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/screens/Authorization/primary_button.dart';
import 'package:myna/models/arguments/userDetailFormArg.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:myna/services/sharedservices.dart';

class userDetailForm extends StatefulWidget {
  userDetailForm({this.arg}) : super(key: arg.key) {
    this.title = arg.title;
    this.auth = arg.auth;
    this._callback = arg.showDetail;
  }

  final userDetailFormArg arg;
  String title;
  BaseAuth auth;
  VoidCallback _callback;

  @override
  userDetailFormState createState() => userDetailFormState();
}

class userDetailFormState extends State<userDetailForm> {
  static final formKey = GlobalKey<FormState>();

  String _nickName = '';
  String _userFirstName = '';
  String _userLastName = '';
  String _Address = '';
  String _mobileNo = "0";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                                key: formKey,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children:
                                        detailFields() + submitWidgets()))),
                      ])),
                ]))));
  }

  List<Widget> detailFields() {
    return [
      padded(
          child: TextFormField(
        key: Key('nickname'),
        decoration: InputDecoration(labelText: 'Nick Name'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Nick Name can\'t be empty.' : null,
        onSaved: (val) => _nickName = val,
      )),
      padded(
          child: TextFormField(
        key: Key('userFirstName'),
        decoration: InputDecoration(labelText: 'First Name'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'field can\'t be empty.' : null,
        onSaved: (val) => _userFirstName = val,
      )),
      padded(
          child: TextFormField(
        key: Key('userLastName'),
        decoration: InputDecoration(labelText: 'Last Name'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'field can\'t be empty.' : null,
        onSaved: (val) => _userLastName = val,
      )),
      padded(
          child: TextFormField(
        key: Key('MobileNumber'),
        decoration: InputDecoration(labelText: 'Mobile No.'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'field can\'t be empty.' : null,
        onSaved: (val) => _mobileNo = val,
      )),
      padded(
          child: TextFormField(
        key: Key('PermanentAdd'),
        decoration: InputDecoration(labelText: 'Permanent Address'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'field can\'t be empty.' : null,
        onSaved: (val) => _Address = val,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    return [
      PrimaryButton(
          key: Key('Update'),
          text: 'Update',
          height: 44.0,
          onPressed: validateAndSubmit),
    ];
  }

  Future<void> updateUserDatabase(UserDetail data) async {
    await sharedServices()
        .FirestoreClientInstance
        .userClient
        .updateUserData(data);
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        var user = await widget.auth.currentUser();
        UserDetail userData = UserDetail(user.uid, user.email, _nickName,
            _userFirstName, _userLastName, _Address, _mobileNo);
        await updateUserDatabase(userData);
        print("DOne");
        widget._callback();
      } catch (DataRegisterError) {
        print('Update profile  Error\n\n${DataRegisterError.toString()}');
      }
    }
  }
}
