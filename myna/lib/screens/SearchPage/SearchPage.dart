import 'package:flutter/material.dart';
import 'package:myna/components/SearchableList.dart';
import 'package:myna/constants/variables/common.dart';
import '../../main.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(APP_NAME)),
        body: SearchableList(
            fetch: context
                .dependOnInheritedWidgetOfExactType<MyInheritedWidget>()
                .firebaseInstance
                .storeGetProductsOnSearch));
  }
}
