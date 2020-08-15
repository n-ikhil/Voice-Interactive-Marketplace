import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/models/Item.dart';

class ListItem extends StatelessWidget {
  final Item _item;
  ListItem(this._item) : super();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this._item.place),
        trailing: Text('\u{20B9} ' + this._item.price.toString()),
        onTap: () {
          Navigator.pushNamed(context, itemDetail,
              arguments: {"id": this._item.id});
        },
      ),
    );
  }
}
