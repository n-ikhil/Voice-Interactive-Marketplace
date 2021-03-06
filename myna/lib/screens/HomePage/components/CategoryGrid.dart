import 'package:myna/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:myna/models/Category.dart';
import 'package:myna/screens/HomePage/components/CategoryItem.dart';
import 'package:myna/services/SharedObjects.dart';

class CategoryGrid extends StatefulWidget {
  final SharedObjects myModel;
  CategoryGrid(this.myModel) : super();
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool loadedCategories = false;
  bool isError = false;
  String errorMsg = "";
  List<Category> categories;

  @override
  void initState() {
    super.initState();
    this.loadCategories();
  }

  void loadCategories() {
    setState(() {
      loadedCategories = false;
      isError = false;
    });
    widget.myModel.firestoreClientInstance.categoryClient
        .storeGetCategories()
        .then((data) {
      setState(() {
        isError = false;
        loadedCategories = true;
        categories = data;
      });
    }).catchError((er) {
      setState(() {
        loadedCategories = false;
        isError = true;
        errorMsg = er;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //loadCategories();
    return SizedBox(
        height:400,
        width: double.infinity,
        child: loadedCategories
            ? Container(
                child: CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          children: [
                            ...this
                                .categories
                                .map((f) => SingleCategory(f))
                                .toList(),
                            RaisedButton(
                              child: Center(child: Text("Reload  (dev)")),
                              onPressed: () {
                                this.setState(() {
                                  loadCategories();
                                });
                              },
                            )
                          ]),
                    ),
                  ],
                ),
              )
            : (isError ? Center(child: Text(errorMsg)) : LoadingWidget()));
  }
}
