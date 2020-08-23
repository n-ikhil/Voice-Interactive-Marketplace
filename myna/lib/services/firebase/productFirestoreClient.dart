import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Category.dart';
import 'package:myna/models/Product.dart';

class productFirestoreClient {
  final CollectionReference _firestoreCollection;
  productFirestoreClient(this._firestoreCollection);

  Future storeSaveProduct(Category cat, String str) async {
    str = str.toLowerCase();
    Product p;
    await _firestoreCollection
        .document(str)
        .setData({"name": str, "category": cat.id}).then((_) async {
      print("succes in writing product");
      await _firestoreCollection.document(str).get().then((onValue) {
        p = Product(onValue);
      }).catchError((onError) {
        Future.error(onError);
      });
    }).catchError((onError) {
      Future.error(onError);
    });
    return p;
  }

  Future storeGetProductsOnCategories(String catId) async {
    List<Product> products = [];
    await _firestoreCollection
        .where("category", isEqualTo: catId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        products.add(Product(f));
      });
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return products;
  }

  Future storeGetProductsOnSearch(String prefix) async {
    List<Product> products = [];
    String endPrefix = prefix.substring(0, prefix.length - 1);
    endPrefix += String.fromCharCode(prefix.codeUnitAt(prefix.length - 1) + 1);
    await _firestoreCollection
        .where("name", isGreaterThanOrEqualTo: prefix)
        .where("name", isLessThan: endPrefix)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        products.add(Product(f));
      });
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return products;
  }
}
