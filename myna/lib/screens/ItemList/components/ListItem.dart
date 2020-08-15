import 'package:flutter/material.dart';
import 'package:myna/models/Item.dart';
import 'package:geolocator/geolocator.dart';

class ListItem extends StatelessWidget {
  final Item _item;
  final Function callback;
  ListItem(this._item, this.callback) : super();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this._item.postalCode + " " + this._item.price.toString()),
        trailing: Icon(Icons.record_voice_over),
        onTap: this.callback,
      ),
    );
  }
}
