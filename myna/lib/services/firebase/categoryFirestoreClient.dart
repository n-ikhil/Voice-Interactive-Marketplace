import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Category.dart';

class categoryFirestoreClient {
  final Firestore _firestore;
  categoryFirestoreClient(this._firestore);

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

}