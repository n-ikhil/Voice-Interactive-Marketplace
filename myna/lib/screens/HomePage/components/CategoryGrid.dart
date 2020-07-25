import '../../../main.dart';
import './CategoryItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../models/Category.dart';

class CategoryGrid extends StatefulWidget {
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool loadedCategories = false;
  bool isError = false;
  String errorMsg = "";
  List<Category> categories;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadCategories(context);
  }

  void loadCategories(context) {
    final MyInheritedWidget myInheritedWidget =
        context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
    setState(() {
      loadedCategories = false;
      isError = false;
    });
    myInheritedWidget.firebaseInstance.storeGetCategories().then((data) {
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
      height: 300,
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
                            child: Center(child: Text("Reload(dev)")),
                            onPressed: () {
                              this.setState(() {
                                loadCategories(context);
                              });
                            },
                          )
                        ]),
                  ),
                ],
              ),
            )
          : (isError
              ? Center(child: Text(errorMsg))
              : SpinKitDoubleBounce(
                  color: Colors.blueAccent,
                  size: 50.0,
                )),
    );
  }
}
