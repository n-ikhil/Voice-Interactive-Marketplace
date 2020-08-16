import 'package:flutter/material.dart';
import 'package:myna/components/SearchableList.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(APP_NAME)),
        body: Consumer<SharedObjects>(builder: (context, myModel, child) {
          return SearchableList(
            fetch: myModel
                .firestoreClientInstance.productClient.storeGetProductsOnSearch,
            myModel: myModel,
          );
        }));
  }
}
