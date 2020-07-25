import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/models/Category.dart';

class SingleCategory extends StatelessWidget {
  final Category cat;

  SingleCategory(this.cat);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.blue[100]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text(this.cat.name),
                onPressed: () {
                  Navigator.pushNamed(context, productList, arguments: cat.id);
                },
              ),
            ],
          ),
        ));
  }
}
