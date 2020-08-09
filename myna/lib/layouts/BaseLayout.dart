import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/models/arguments/userDetailFormArg.dart';
import 'package:myna/models/arguments/userDetailViewArg.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:myna/services/router.dart';
import '../constants/variables/common.dart';
import 'dart:convert';
import 'package:myna/main.dart';

class BaseLayout extends StatelessWidget {
  final Widget childWidget;
  final VoidCallback SignOut;
  final BaseAuth auth;
  final BuildContext context;
  FirebaseUser _currentUser;

  BaseLayout({this.SignOut, this.auth, this.childWidget, this.context});

  getUserPhoto() {
    var url = auth != null ? auth.getImageUrl() : null;
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
    var email = auth != null ? auth.currentUserEmail() : null;
    return email;
  }

//
//  getUserDetail() async {
//    var user = auth != null ? auth.currentUser() : null;
//    if (user != null) {
//      return user.then((value) => context
//          .dependOnInheritedWidgetOfExactType<MyInheritedWidget>()
//          .firebaseInstance
//          .firestoreClient
//          .userClient
//          .getUserDetail(value)) ;
//    }
//    return null;
//  }
//
//  getUserNickName() {
//    if (getUserDetail() != null) {
//      return getUserDetail().then((value) => Text(value.nickName));
//    }
//  }

  _onShowDetail() {
    userDetailViewArg argSend = userDetailViewArg(
        title: "View Profile",
        user: _currentUser,
        editDetail: _onEditDetail);
    Navigator.pushNamed(context, userDetailViewPage, arguments: argSend);
  }

  _onEditDetail() {
    userDetailFormArg argSend = userDetailFormArg(
        title: "Update Profile",
        auth: this.auth,
        showDetail: _onShowDetail,
    );
    Navigator.pushNamed(context, userDetailFormPage, arguments: argSend);
  }

  getUser(Auth auth) {
    auth.currentUser().then((value) => {_currentUser = value});
  }

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await auth.signOut();
        SignOut();
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
                accountName: Text("no Auth"),
//                accountName: FutureBuilder<Widget>(
//                    future: getUserNickName(),
//                    builder:
//                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
//                      if (snapshot.hasData) {
//                        return snapshot.data;
//                      }
//                      return Container(child: CircularProgressIndicator());
//                    }),
                accountEmail: Text("ashishrawat2911@gmail.com"),
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

        body: this.childWidget,
        bottomNavigationBar: RaisedButton(
          onPressed: null,
          child: Icon(Icons.record_voice_over),
          color: Colors.red,
        ));
  }
}
