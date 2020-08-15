import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/layouts/BaseLayout.dart';
import 'package:myna/screens/HomePage/components/CategoryGrid.dart';
import 'package:myna/services/firebase/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({this.SignOut, this.auth});
  final VoidCallback SignOut;
  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        SignOut: SignOut,
        auth: auth,
        context: context,
        childWidget: Column(
          children: [
            CategoryGrid(),
            Center(
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, newItemPage);
                },
              ),
            )
          ],
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }
}
