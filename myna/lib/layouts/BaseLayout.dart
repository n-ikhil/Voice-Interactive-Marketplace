import 'package:flutter/material.dart';
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

  @override
  initState() {
    super.initState();
  }

  getUserEmail() {
    var email = widget.auth != null ? widget.auth.currentUserEmail() : null;
    return email;
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
    Navigator.pop(context);

    Navigator.pushNamed(context, userDetailFormPage, arguments: argSend);
  }

  refreshFunc() {
    widget.myModel.updateLoginStatus().then((_) {
      userData = widget.myModel.currentUser;
      SharedPreferencesFunctions.saveUserNameSharedPreference(
          userData.nickName);
    });
  }

  getDetails() async {
    await widget.myModel.updateLoginStatus();
    refreshFunc();
  }

  imageFunc() {
    try {
      return FutureBuilder<Widget>(
          future: getUserPhoto(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            }
            return Container(child: CircularProgressIndicator());
          });
    } catch (e) {
      return CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          "R",
          style: TextStyle(fontSize: 40.0),
        ),
      );
    }
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
        resizeToAvoidBottomInset: false,
        // set it to false
        appBar: AppBar(
          title: Text(APP_NAME),
          actions: <Widget>[
            FlatButton(
                child: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, searchPage);
                }),
            FlatButton(onPressed: refreshFunc, child: Icon(Icons.refresh)),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: userData != null
                    ? Text(userData.nickName)
                    : Text("nickName"),
                accountEmail: userData != null
                    ? Text(userData.emailID)
                    : Text("nickName"),
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
                onTap: () async {
                  if (userData.nickName == 'NA' ||
                      userData.nickName == null ||
                      userData.nickName == '') {
                    await getNickName();
                  }
                  if (userData.nickName != 'NA' &&
                      userData.nickName != null &&
                      userData.nickName != '') {
                    await Navigator.pushNamed(context, chatRoom);
                  }
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
          onPressed: null,
          child: Icon(Icons.record_voice_over),
          color: Colors.red,
        ));
  }

  getNickName() {
    final _codeController = TextEditingController();

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter a nickName"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  autofocus: true,
                  showCursor: true,
                  cursorColor: Colors.green,
                  controller: _codeController,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Confirm"),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async {
                  final name = _codeController.text.trim();
                  if (name != null && name != 'NA' && name != '') {
                    UserDetail detail = UserDetail(
                        userData.UserId,
                        userData.EmailId,
                        name,
                        userData.userFirstName,
                        userData.userLastName,
                        userData.Address,
                        userData.mobileNo);
                    await sharedServices()
                        .FirestoreClientInstance
                        .userClient
                        .updateUserData(detail);
                    refreshFunc();
                    Navigator.of(context).pop();
                    print("Done");
                  } else {
                    await Navigator.of(context).pop();
                    getNickName();
                    print("Enter valid Input except NA");
                  }
                },
              )
            ],
          );
        });
  }
}
