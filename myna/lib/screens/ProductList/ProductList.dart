import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    super.initState();

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
      if (controller.text.length == strLenTriggerSearch &&
          widget.categoryID == null) {
        print(strLenTriggerSearch);
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
    if (widget.categoryID != "") {
      firebaseInstance
          .storeGetProductsOnCategories(widget.categoryID)
          .then((data) {
        setState(() {
          this.products = data;
        });
      });
    }
    firebaseInstance.storeGetConstant(LENGTH_TO_TRIGGER_SEARCH).then((data) {
      setState(() {
        this.strLenTriggerSearch = data;
      });
      ;
    });
  }

  void loadProductList() {
    setState(() {
      loadState = 1;
    });
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
          leading: RaisedButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: "Search products and services"),
              controller: controller,
            ),
            loadState == 2
                ? Expanded(
                    child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return filter == null || filter == ""
                              ? Card(child: Text(products[index].name))
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
                    : SpinKitDoubleBounce(
                        color: Colors.blueAccent,
                        size: 50.0,
                      ),
          ],
        ));
  }
}
