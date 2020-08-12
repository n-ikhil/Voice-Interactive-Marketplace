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
  static final formKeyUserDetail = GlobalKey<FormState>();

  String _nickName = '';
  String _userFirstName = '';
  String _userLastName = '';
  String _Address = '';
  String _mobileNo = "0";

  bool validateAndSave() {
    final form = formKeyUserDetail.currentState;
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

  FirebaseUser _currentUser;
  UserDetail userData;

  getDetails() async {
    if (_currentUser == null || userData == null) {
      await widget.auth.currentUser().then((value) => _currentUser = value);
      await sharedServices()
          .FirestoreClientInstance
          .userClient
          .getUserDetail(_currentUser)
          .then((value) => setState(() {
                userData = value;
                print(userData.EmailId + "================");
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    getDetails();

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
                                key: formKeyUserDetail,
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
        decoration: InputDecoration(
            helperStyle: TextStyle(color: Colors.brown, fontSize: 15),
            helperText: userData != null ? userData.nickName : null,
            labelText:
                userData != null ? 'Change Nick Name' : 'Enter Nick Name',
            hintText: "Nick_Name"),
        autocorrect: false,
//            validator: (val) => val.isEmpty ? 'field did not changed.' : null,
            onSaved: (val) => _nickName =  val.isEmpty ? userData.nickName :val,
      )),
      padded(
          child: TextFormField(
        key: Key('userFirstName'),
        decoration: InputDecoration(
            helperStyle: TextStyle(color: Colors.brown, fontSize: 15),
            helperText: userData != null ? userData.userFirstName : null,
            labelText:
                userData != null ? 'Change First Name' : 'Enter First Name',
            hintText: "First_Name"),
        autocorrect: false,
//            validator: (val) => val.isEmpty ? 'field did not changed.' : null,
            onSaved: (val) => _userFirstName =  val.isEmpty ? userData.userFirstName :val,
      )),
      padded(
          child: TextFormField(
        key: Key('userLastName'),
        decoration: InputDecoration(
            helperStyle: TextStyle(color: Colors.brown, fontSize: 15),
            helperText: userData != null ? userData.userLastName : null,
            labelText:
                userData != null ? 'Change Last Name' : 'Enter Last Name',
            hintText: "Last_Name"),
        autocorrect: false,
//            validator: (val) => val.isEmpty ? 'field did not changed.' : null,
            onSaved: (val) => _userLastName =  val.isEmpty ? userData.userLastName :val,
      )),
      padded(
          child: TextFormField(
        key: Key('MobileNumber'),
        decoration: InputDecoration(
            helperStyle: TextStyle(color: Colors.brown, fontSize: 15),
            helperText: userData != null ? userData.mobileNo : null,
            labelText:
                userData != null ? 'Change  Mobile Number' : 'Enter Mobile Number',
            hintText: "mobileNo"),
        autocorrect: false,
//            validator: (val) => val.isEmpty ? 'field did not changed.' : null,
            onSaved: (val) => _mobileNo =  val.isEmpty ? userData.mobileNo :val,
      )),
      padded(
          child: TextFormField(
        key: Key('PermanentAdd'),
        decoration: InputDecoration(
            helperStyle: TextStyle(color: Colors.brown, fontSize: 15),
            helperText: userData != null ? userData.Address : null,
            labelText:
                userData != null ? 'Change Permanent Address' : 'Enter Permanent Address',
            hintText: "Address"),
        autocorrect: false,
//        validator: (val) => val.isEmpty ? 'field did not changed.' : null,
        onSaved: (val) => _Address =  val.isEmpty ? userData.Address :val,
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
        UserDetail userData = UserDetail(_currentUser.uid, _currentUser.email, _nickName,
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
