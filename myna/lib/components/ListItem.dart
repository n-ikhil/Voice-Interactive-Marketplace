import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final Function callback;
  ListItem(this.title, this.callback) : super();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this.title),
        trailing: Icon(Icons.record_voice_over),
        onTap: this.callback,
      ),
    );
  }
}
