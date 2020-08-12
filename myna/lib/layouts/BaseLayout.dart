import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/models/arguments/userDetailFormArg.dart';
import 'package:myna/models/arguments/userDetailViewArg.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:myna/services/sharedservices.dart';
import '../constants/variables/common.dart';

class BaseLayout extends StatefulWidget {
  final Widget childWidget;
  final VoidCallback SignOut;
  final BaseAuth auth;
  final BuildContext context;

  const BaseLayout(
      {Key key, this.childWidget, this.SignOut, this.auth, this.context})
      : super(key: key);

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  FirebaseUser _currentUser;

  getUserPhoto() {
    var url = widget.auth != null ? widget.auth.getImageUrl() : null;
    if (url != null) {
      return url.then((value) => ClipOval(
          child: Image.network(value,
              width: 100, height: 100, fit: BoxFit.cover)));
    } else {
      return CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          "R",
          style: TextStyle(fontSize: 40.0),
        ),
      );
    }
  }

  getUserEmail() {
    var email = widget.auth != null ? widget.auth.currentUserEmail() : null;
    return email;
  }

  _onShowDetail() {
    if (_currentUser == null) {
      print("===============user null");
    }
    userDetailViewArg argSend = userDetailViewArg(
        title: "View Profile", user: _currentUser, editDetail: _onEditDetail);
    Navigator.pushNamed(context, userDetailViewPage, arguments: argSend);
  }

  _onEditDetail() {
    userDetailFormArg argSend = userDetailFormArg(
      title: "Update Profile",
      auth: widget.auth,
      showDetail: _onShowDetail,
    );
    Navigator.pushNamed(context, userDetailFormPage, arguments: argSend);
  }

  UserDetail userData;

  getUser() async {
    setState(() async {
      _currentUser = await widget.auth.currentUser().then((value) => value);
    });
  }

  getDetails() async{
    getUser();
    setState(() async {
      userData = await sharedServices()
          .FirestoreClientInstance
          .userClient
          .getUserDetail(_currentUser)
          .then((value) => value);
    });
  }

  @override
  Widget build(BuildContext context) {
    getDetails();
    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.SignOut();
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          actions: <Widget>[
            FlatButton(
                child: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, searchPage);
                }),
            FlatButton(
                onPressed: _signOut,
                child: Text('Logout',
                    style: TextStyle(fontSize: 17.0, color: Colors.white))),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(userData.nickName),
                accountEmail: Text(userData.EmailId),
                currentAccountPicture: FutureBuilder<Widget>(
                    future: getUserPhoto(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data;
                      }
                      return Container(child: CircularProgressIndicator());
                    }),
                onDetailsPressed: () {
                  _onShowDetail();
                },
              ),
              ListTile(
                title: Text("Edit Profile"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  _onEditDetail();
                },
              ),
              ListTile(
                title: Text("Open Chat"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pushNamed(context, chatRoom);
                },
              ),
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.arrow_forward),
                onTap: _signOut,
              ),
            ],
          ),
        ),

        //this will just add the Navigation Drawer Icon

        body: widget.childWidget,
        bottomNavigationBar: RaisedButton(
          onPressed: null,
          child: Icon(Icons.record_voice_over),
          color: Colors.red,
        ));
  }
}
