import 'package:flutter/material.dart';
import 'package:myna/components/SearchableList.dart';
import 'package:myna/services/sharedservices.dart';

class CategoryResult extends StatefulWidget {
  final category;

  CategoryResult(this.category);

  @override
  _CategoryResultState createState() => _CategoryResultState();
}

class _CategoryResultState extends State<CategoryResult> {
  List<dynamic> resList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sharedServices()
        .FirestoreClientInstance
        .productClient
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
      body: SearchableList(list: resList),
    );
  }
}
