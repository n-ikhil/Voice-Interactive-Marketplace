import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Category.dart';

class categoryFirestoreClient {
  final CollectionReference _firestoreCollection;
  categoryFirestoreClient(this._firestoreCollection);

  Future storeGetCategories() async {
    List<Category> categories = [];
    await _firestoreCollection.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => categories.add(Category(f)));
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return categories;
  }

  Future storeSaveCategory(String str) async {
    str = str.toLowerCase();
    Category cat;
    await _firestoreCollection
        .document(str)
        .setData({"name": str}).then((_) async {
      print("saved");
      await _firestoreCollection.document(str).get().then((onValue) {
        cat = Category(onValue);
      }).catchError((onError) {
        Future.error(onError);
      });
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return cat;
  }
}
