import 'package:flutter/material.dart';
import 'package:myna/components/SearchableList.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:provider/provider.dart';

class CategoryResult extends StatefulWidget {
  final category;
  final SharedObjects myModel;

  CategoryResult({this.category, this.myModel});

  @override
  _CategoryResultState createState() => _CategoryResultState();
}

class _CategoryResultState extends State<CategoryResult> {
  List<dynamic> resList;

  @override
  void initState() {
    super.initState();
    widget.myModel.firestoreClientInstance.productClient
        .storeGetProductsOnCategories(widget.category.id)
        .then((data) {
      this.setState(() {
        resList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Consumer<SharedObjects>(builder: (context, myModel, child) {
        return SearchableList(list: resList, myModel: myModel);
      }),
    );
  }
}
