import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/layouts/BaseLayout.dart';
import 'package:myna/screens/HomePage/components/CategoryGrid.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({this.SignOut, this.auth});
  final VoidCallback SignOut;
  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedObjects>(builder: (context, myModel, child) {
      return BaseLayout(
          myModel: myModel,
          SignOut: SignOut,
          auth: auth,
          context: context,
          childWidget: Column(
            children: [
              Consumer<SharedObjects>(builder: (context, myModel, child) {
                return CategoryGrid(myModel);
              }),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "btn1",
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushNamed(context, newItemPage);
                      },
                    ),
                  ])
            ],
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
          ));
    });
  }
}
