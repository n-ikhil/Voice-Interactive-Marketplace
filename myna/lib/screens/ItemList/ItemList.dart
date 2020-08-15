import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/screens/ItemList/components/ListItem.dart';
import 'package:myna/services/sharedservices.dart';

class ItemList extends StatefulWidget {
  final Map<String, dynamic> args;
  ItemList(this.args);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  bool showSpinner;
  bool showInMyLocation = false;
  List<Item> items = [];
  Placemark place;

  sharedServices _sharedServices = sharedServices();

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
    await sharedServices.getCurrentLocation().then((onValue) {
      place = onValue;
    });
    if (showInMyLocation) {
      await _sharedServices.FirestoreClientInstance.itemClient
          .storeGetItem(widget.args["id"], place.postalCode)
          .then((onValue) {
        setState(() {
          items = onValue;
          showSpinner = false;
        });
      });
    } else {
      await _sharedServices.FirestoreClientInstance.itemClient
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
                  title: Text("Show results for " + place.locality),
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
