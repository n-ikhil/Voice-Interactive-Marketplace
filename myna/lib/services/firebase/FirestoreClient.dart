import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Category.dart';
import 'package:myna/models/Product.dart';

class FirestoreClient {
  final Firestore _firestore;
  Map<String, dynamic> constants = {"strLenTriggerSearch": 3};

  FirestoreClient(this._firestore);

  Future initConstants() async {
    await _firestore
        .collection("constant")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        constants[f.documentID] = f.data["value"];
      });
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
  }

  Future storeGetCategories() async {
    List<Category> categories = [];
    await _firestore
        .collection("category")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => categories.add(Category(f)));
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return categories;
  }

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
