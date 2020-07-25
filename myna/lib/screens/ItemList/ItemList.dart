import 'package:flutter/material.dart';
import 'package:myna/constants/variables/common.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
      body: Container(child: Text("item list")),
    );
  }
}
