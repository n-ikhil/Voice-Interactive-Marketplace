import 'package:flutter/material.dart';
import 'package:myna/constants/variables/common.dart';

class ItemList extends StatefulWidget {
  final String pid;
  ItemList(this.pid);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: Container(
        child: Center(
          child: Text(widget.pid),
        ),
      ),
    );
  }
}
