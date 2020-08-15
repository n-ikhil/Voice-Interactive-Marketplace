import 'package:flutter/material.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/services/sharedservices.dart';

class ItemDetail extends StatefulWidget {
  final Map<String, dynamic> args;
  ItemDetail(this.args);
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  Item item;
  bool showSpinner = false;
  sharedServices _sharedServices;
  @override
  void initState() {
    super.initState();
    _sharedServices = sharedServices();
    loadItemDetail();
  }

  void loadItemDetail() async {
    setState(() {
      showSpinner = true;
    });
    await _sharedServices.FirestoreClientInstance.itemClient
        .storeGetItemDetail(widget.args["id"])
        .then((onValue) {
      item = onValue;
    });
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: showSpinner
          ? LoadingWidget()
          : Center(
              child: ListView(
              children: <Widget>[
                Text("Location : " + item.place),
                Text("product price: \u{20B9} " + item.price.toString()),
                Text("product name: " + item.productID),
                Text("Can be rented ? " + (item.isRentable ? "yes" : "no")),
              ],
            )),
    );
  }
}
