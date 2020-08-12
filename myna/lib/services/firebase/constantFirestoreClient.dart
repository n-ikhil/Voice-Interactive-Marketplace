import 'package:cloud_firestore/cloud_firestore.dart';

class constantFirestoreClient {
  final CollectionReference _firestoreCollection;
  Map<String, dynamic> constants = {"strLenTriggerSearch": 3};

  constantFirestoreClient(this._firestoreCollection);

  Future initConstants() async {
    await _firestoreCollection
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
