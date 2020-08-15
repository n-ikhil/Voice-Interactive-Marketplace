import 'package:flutter/material.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/services/sharedservices.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(title: Text((showSpinner ? APP_NAME : item.description))),
      body: Center(
        child: showSpinner
            ? LoadingWidget()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // child: Column(
                children: <Widget>[
                  Text(item.description),
                  Text(item.productID),
                  Text(item.place),
                  Text("\u{20B9} " + item.price.toString()),
                  Text("Can be rented : " + (item.isRentable ? "yes" : "no")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () => print("launch chatting"),
                        child: Icon(Icons.message),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () => launch("tel:" + item.contact),
                        child: Icon(Icons.call),
                      ),
                    ],
                  ),
                ],
                // )
              ),
      ),
    );
  }
}
