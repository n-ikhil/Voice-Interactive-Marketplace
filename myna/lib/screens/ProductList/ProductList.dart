import 'package:flutter/material.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/Firebase.dart';
import 'package:myna/models/Product.dart';
import 'package:myna/screens/ProductList/components/ListItem.dart';

import '../../main.dart';

// https://medium.com/@thedome6/how-to-create-a-searchable-filterable-listview-in-flutter-4faf3e300477
class ProductList extends StatefulWidget {
  final String categoryID;
  ProductList({this.categoryID}) : super();

  @override
  State<StatefulWidget> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int loadState = 0; // 0=> not loading; 1=>loading; 2=>loaded;
  int strLenTriggerSearch =
      3; // default; will be reset by taking value from backend
  String errMsg = "";

  TextEditingController controller = TextEditingController();
  String filter;

  FirebaseCommon firebaseInstance;

  List<Product> products = [];
  @override
  initState() {
    print(widget.categoryID);
    print('widget up');
    super.initState();

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
      if (controller.text.length == strLenTriggerSearch &&
          widget.categoryID == null) {
        loadProductList();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firebaseInstance = context
        .dependOnInheritedWidgetOfExactType<MyInheritedWidget>()
        .firebaseInstance;
    if (widget.categoryID != null) {
      loadProductList(isCategory: true);
    }
    firebaseInstance.storeGetConstant(LENGTH_TO_TRIGGER_SEARCH).then((data) {
      setState(() {
        this.strLenTriggerSearch = data;
      });
      ;
    });
  }

  void loadProductList({bool isCategory = false}) {
    setState(() {
      loadState = 1;
    });
    if (!isCategory) {
      firebaseInstance.storeGetProductsOnSearch(filter).then((data) {
        setState(() {
          products = data;
          loadState = 2;
        });
      }).catchError((err) {
        setState(() {
          loadState = 0;
          errMsg = err;
        });
      });
    } else {
      firebaseInstance
          .storeGetProductsOnCategories(widget.categoryID)
          .then((data) {
        setState(() {
          this.products = data;
          this.loadState = 2;
        });
      }).catchError((err) {
        setState(() {
          loadState = 0;
          errMsg = err;
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(APP_NAME),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Search products and services",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                controller: controller,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Results:"),
              ),
              loadState == 2
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            return filter == null || filter == ""
                                ? ListItem(products[index].name, () {
                                    Navigator.pushNamed(context, itemList,
                                        arguments: {"id": products[index].id});
                                  })
                                : products[index]
                                        .name
                                        .toLowerCase()
                                        .contains(filter.toLowerCase())
                                    ? ListItem(products[index].name, () {
                                        Navigator.pushNamed(context, itemList,
                                            arguments: {
                                              "id": products[index].id
                                            });
                                      })
                                    : Container();
                          }))
                  : loadState == 0
                      ? Center(child: Text(errMsg))
                      : LoadingWidget()
            ],
          ),
        ));
  }
}
