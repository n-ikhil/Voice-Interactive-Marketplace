import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import '../constants/variables/common.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  BaseLayout({this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          actions: <Widget>[
            FlatButton(
                child: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, productList);
                })
          ],
        ),
        body: this.child,
        bottomNavigationBar: RaisedButton(
          onPressed: null,
          child: Icon(Icons.record_voice_over),
          color: Colors.red,
        ));
  }
}
