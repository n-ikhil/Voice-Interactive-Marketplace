import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Product.dart';

class productFirestoreClient {
  final Firestore _firestore;
  productFirestoreClient(this._firestore);


  Future storeGetProductsOnCategories(String catId) async {
    List<Product> products = [];
    await _firestore
        .collection("product")
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
    await _firestore
        .collection("product")
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