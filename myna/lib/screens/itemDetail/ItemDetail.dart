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
  bool isMyItem = false;

  @override
  void initState() {
    super.initState();
    loadItemDetail();
  }

  inspectItem(Item item) {
    if (item.ownerID == widget.myModel.currentUser.userID) {
      setState(() {
        isMyItem = true;
      });
    }
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
    inspectItem(item);
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
                  item.imgURL != null
                      ? Image.network(item.imgURL,
                          width: 300, height: 300, fit: BoxFit.cover)
                      : Container(height: 0, width: 0),
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
                          // if (widget.myModel.currentUser.nickName == null) {
                          //   print("please add nick name before adding item");
                          //   return;
                          // }
                          Navigator.pushNamed(context, conversation,
                              arguments: {
                                "id": item,
                              });
                        },
                        child: Icon(Icons.message),
                      ),
                      Visibility(
                        visible: isMyItem,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.red,
                          onPressed: () async => {
                            await widget.myModel.firestoreClientInstance.itemClient
                                .storeDeleteItemDetail(widget.args["id"]),
                            Navigator.pop(context),
                            Navigator.pop(context),
                          },
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
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
                  Center(
                    child: Visibility(
                      visible: isMyItem,
                      child: Text("This item was added by you."),
                    ),
                  )
                ],
                // )
              ),
            ),
    );
  }
}
