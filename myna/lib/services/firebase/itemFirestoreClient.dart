import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Item.dart';

class itemFirestoreClient {
  final CollectionReference _firestoreCollection;
  itemFirestoreClient(this._firestoreCollection);

  Future storeSaveItem(Item newItem) async {
    await _firestoreCollection.add({
      "productID": newItem.productID,
      "ownerID": newItem.ownerID,
      "description": newItem.description,
      "contact": newItem.contact,
      "isRentable": newItem.isRentable,
      "postalCode": newItem.postalCode,
      "price": newItem.price,
      "place": newItem.place
    }).then((_) async {
      print("succes in writing item");
    }).catchError((onError) {
      print("item not written");
      Future.error(onError);
    });
    return;
  }

  Future storeGetItemDetail(String itemID) async {
    Item item;
    await _firestoreCollection.document(itemID).get().then((onValue) {
      item = Item(onValue);
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return item;
  }

  Future storeGetItem(String pid, String pcode) async {
    List<Item> items = [];
    await _firestoreCollection
        .where("productID", isEqualTo: pid)
        .where("postalCode", isEqualTo: pcode)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        items.add(Item(f));
      });
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return items;
  }

  Future storeGetItemPublic(String pid) async {
    List<Item> items = [];
    await _firestoreCollection
        .where("productID", isEqualTo: pid)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        items.add(Item(f));
      });
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return items;
  }
}
