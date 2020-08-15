import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Category.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/models/Product.dart';

class itemFirestoreClient {
  final CollectionReference _firestoreCollection;
  itemFirestoreClient(this._firestoreCollection);

  Future storeSaveItem(Item newItem) async {
    await _firestoreCollection.add({
      "productID": newItem.productID,
      "ownerID": newItem.ownerID,
      "isRentable": newItem.isRentable,
      "isPublic": newItem.isPublic,
      "postalCode": newItem.postalCode
    }).then((_) async {
      print("succes in writing item");
    }).catchError((onError) {
      print("item not written");
      Future.error(onError);
    });
    return;
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
}
