import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myna/constants/SharedPreferencesFunctions.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/models/arguments/userDetailFormArg.dart';
import 'package:myna/models/arguments/userDetailViewArg.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:myna/services/firebase/auth.dart';
import '../constants/variables/common.dart';

class BaseLayout extends StatefulWidget {
  final Widget childWidget;
  final VoidCallback SignOut;
  final BaseAuth auth;
  final BuildContext context;
  final SharedObjects myModel;

  const BaseLayout(
      {Key key,
      this.childWidget,
      this.SignOut,
      this.auth,
      this.context,
      this.myModel})
      : super(key: key);

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  UserDetail userData;

  @override
  initState() {
    getDetails();
    super.initState();
  }

  _onShowDetail() {
    userDetailViewArg argSend =
        userDetailViewArg(title: "View Profile", editDetail: _onEditDetail);
    Navigator.pop(context);
    Navigator.pushNamed(context, userDetailViewPage, arguments: argSend);
  }

  _onEditDetail() {
    userDetailFormArg argSend = userDetailFormArg(
      title: "Update Profile",
      auth: widget.auth,
      showDetail: _onShowDetail,
    );
    widget.myModel.updateLoginStatus();
    Navigator.pop(context);
    Navigator.pushNamed(context, userDetailFormPage, arguments: argSend);
  }

  refreshFunc() {
    widget.myModel.updateLoginStatus().then((_) {
      setState(() {
        userData = widget.myModel.currentUser;
        print(userData.userID);
        print("base layout");
        SharedPreferencesFunctions.saveUserNameSharedPreference(
            userData.userID);
      });
    });
  }

  getDetails() async {
    print("get details");
    await widget.myModel.updateLoginStatus();
    widget.myModel.addAuthInstance(widget.auth);
    refreshFunc();
  }

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.SignOut();
      } catch (e) {
        try {
          await widget.myModel.auth.signOut();
          widget.SignOut();
        } catch (e) {
          print(e);
        }
        print(e);
        print("what");
      }
    }

    return WillPopScope(
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit'),
                actions: [
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () =>SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            ),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            // set it to false
            appBar: AppBar(
              title: Text(APP_NAME),
              actions: <Widget>[
                FlatButton(onPressed: refreshFunc, child: Icon(Icons.refresh)),
                FlatButton(
                    child: Icon(Icons.search),
                    onPressed: () {
                      Navigator.pushNamed(context, searchPage);
                    }),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: userData != null
                        ? Text(userData.nickName)
                        : Text("userData Loading"),
                    accountEmail: userData != null
                        ? Text(userData.emailID)
                        : Text("userData Loading"),
                    currentAccountPicture: imageFunc(),
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

            body: SingleChildScrollView(child: widget.childWidget),
            bottomNavigationBar: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, buySellRoot);
              },
              child: Icon(Icons.record_voice_over),
              // color: Colors.,
            )));
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }

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

  imageFunc() {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: Text(
        "Hi",
        style: TextStyle(fontSize: 40.0),
      ),
    );
    // }
  }
}
