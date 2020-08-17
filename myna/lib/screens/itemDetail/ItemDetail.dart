import 'package:flutter/material.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetail extends StatefulWidget {
  final Map<String, dynamic> args;
  final SharedObjects myModel;
  ItemDetail(this.args, this.myModel);
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  Item item;
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    loadItemDetail();
  }

  void loadItemDetail() async {
    setState(() {
      showSpinner = true;
    });
    await widget.myModel.firestoreClientInstance.itemClient
        .storeGetItemDetail(widget.args["id"])
        .then((onValue) {
      item = onValue;
      print(item.imgURL);
    });
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text((showSpinner ? APP_NAME : item.description))),
      body: showSpinner
          ? LoadingWidget()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                // child: Column(
                children: <Widget>[
                  Image.network(item.imgURL,
                      width: 300, height: 300, fit: BoxFit.cover),
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
                        onPressed: () {
                          Navigator.pushNamed(context, conversation,
                              arguments: {
                                "id": item.ownerID,
                              });
                        },
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
