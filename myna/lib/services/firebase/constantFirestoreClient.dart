import 'package:cloud_firestore/cloud_firestore.dart';

class constantFirestoreClient {
  final Firestore _firestore;
  Map<String, dynamic> constants = {"strLenTriggerSearch": 3};

  constantFirestoreClient(this._firestore);

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
}
