import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import '../../layouts/BaseLayout.dart';
import './components/CategoryGrid.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        child: Column(
      children: [
        CategoryGrid(),
        RaisedButton(
          child: Text("Add new product here"),
          onPressed: () {
            Navigator.pushNamed(context, newItemPage);
          },
        ),
      ],
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
    ));
  }
}
