import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Category.dart';
import 'package:myna/models/Product.dart';
import '../services/firebase/config.dart';
import 'package:firebase_core/firebase_core.dart';

//https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40
class FirebaseCommon {
  FirebaseAuth _firebaseAuth;
  Firestore _firestore;
  FirebaseApp _app;

  Future init() async {
    _app = await setupFirebase();
    _firebaseAuth = FirebaseAuth.fromApp(_app);
    _firestore = Firestore(app: _app);
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

  Future storeGetConstant(String str) async {
    int num = 3;
    await _firestore
        .collection("constant")
        .where("name", isEqualTo: str)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      print(snapshot.documents[0].data);
      num = snapshot.documents[0].data["value"];
      print(num);
    }).catchError((onError) {
      print(onError);
      print("err");
      Future.error(onError);
    });
    return num;
  }

  Future storeGetProductsOnCategories(String catId) async {
    List<Product> products = [];
    await _firestore
        .collection("product")
        .where("category", isEqualTo: catId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => products.add(Product(f)));
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
      snapshot.documents.forEach((f) => products.add(Product(f)));
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return products;
  }
}
