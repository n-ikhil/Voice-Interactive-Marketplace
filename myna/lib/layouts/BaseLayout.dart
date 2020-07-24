import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  BaseLayout({this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Myna")),
        body: this.child,
        bottomNavigationBar: RaisedButton(
          onPressed: null,
          child: Icon(Icons.record_voice_over),
          color: Colors.red,
        ));
  }
}
