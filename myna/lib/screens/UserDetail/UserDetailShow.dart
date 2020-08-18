import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/models/arguments/userDetailViewArg.dart';
import 'package:myna/services/SharedObjects.dart';

class userDetailView extends StatefulWidget {
  final SharedObjects myModel;
  userDetailView({this.arg, this.myModel}) : super(key: arg.key) {
    this._callback = arg.editDetail;
  }

  final userDetailViewArg arg;
  String title;
  VoidCallback _callback;

  @override
  userDetailViewState createState() => userDetailViewState();
}

class userDetailViewState extends State<userDetailView> {
  UserDetail detail;

  @override
  void initState() {
    super.initState();
  }

  getData(BuildContext context) async {
    if (detail == null) {
      detail = widget.myModel.currentUser;
      if (detail != null) {
        print("done");
        setState(() {
          detail = detail;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getData(context);

    TextStyle textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w300);
    showText(String str) {
      return Text(str, style: textStyle);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          color: Colors.lightGreen[100],
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.brown,
                            size: 40,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: showText(
                              "Nickname : ${detail != null ? detail.nickName : 'can\'t fetch'}")),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: showText(
                              "First Name : ${detail != null ? detail.userFistName : 'can\'t fetch'}")),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: showText(
                              "Last Name : ${detail != null ? detail.userLastName : 'can\'t fetch'}")),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: showText(
                            "Mobile No : ${detail != null ? detail.mobileNo : 'can\'t fetch'}",
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: showText(
                              "Email ID : ${detail != null ? detail.emailID : 'can\'t fetch'}")),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: showText(
                              "Address : ${detail != null ? detail.address : 'can\'t fetch'}")),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: FloatingActionButton(
                            backgroundColor: Colors.brown,
                            onPressed: () {
                              widget._callback();
                            },
                            elevation: 0.6,
                            heroTag: "button_edit",
                            child: Icon(Icons.edit),
                          )),
                    ],
                  )),
                ))));
  }
}
