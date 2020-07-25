import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/models/Category.dart';
import '../services/firebase/config.dart';
import 'package:firebase_core/firebase_core.dart';

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
    }).catchError((onError) => Future.error(onError));
    return categories;
  }
}
