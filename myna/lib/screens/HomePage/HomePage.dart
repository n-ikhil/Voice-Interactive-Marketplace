import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/services/firebase/auth.dart';
import '../../layouts/BaseLayout.dart';
import './components/CategoryGrid.dart';

class HomePage extends StatelessWidget {
  HomePage({this.onSignOut});
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        onSignOut: onSignOut,
        childWidget: Column(
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
