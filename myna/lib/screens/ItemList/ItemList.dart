import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/screens/ItemList/components/ListItem.dart';
import 'package:myna/services/SharedObjects.dart';

class ItemList extends StatefulWidget {
  final Map<String, dynamic> args;
  final SharedObjects myModel;
  ItemList(this.args, this.myModel);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  bool showSpinner;
  bool showInMyLocation = false;
  List<Item> items = [];
  Placemark place;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItems();
  }

  void loadItems() async {
    setState(() {
      showSpinner = true;
    });

    place = widget.myModel.currentLocation.place;
    if (showInMyLocation) {
      await widget.myModel.firestoreClientInstance.itemClient
          .storeGetItem(widget.args["id"], place.postalCode)
          .then((onValue) {
        setState(() {
          items = onValue;
          showSpinner = false;
        });
      });
    } else {
      await widget.myModel.firestoreClientInstance.itemClient
          .storeGetItemPublic(widget.args["id"])
          .then((onValue) {
        setState(() {
          items = onValue;
          showSpinner = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.args["id"])),
        body: showSpinner
            ? LoadingWidget()
            : ListView(children: <Widget>[
                CheckboxListTile(
                  title: Text(
                      "Show for : " + place.locality + "," + place.postalCode),
                  value: showInMyLocation,
                  onChanged: (bool newValue) {
                    setState(() {
                      showInMyLocation = newValue;
                    });
                    loadItems();
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                ...this.items.map((f) {
                  return ListItem(f);
                }),
              ]));
  }
}
