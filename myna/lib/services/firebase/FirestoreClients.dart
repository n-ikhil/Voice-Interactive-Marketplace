import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/services/firebase/categoryFirestoreClient.dart';
import 'package:myna/services/firebase/constantFirestoreClient.dart';
import 'package:myna/services/firebase/productFirestoreClient.dart';
import 'package:myna/services/firebase/userProfileFirestoreClient.dart';

class FirestoreClient {
  final Firestore _firestore;

  constantFirestoreClient constantClient;
  categoryFirestoreClient categoryClient;
  productFirestoreClient productClient;
  userProfileFirestoreClient userClient;

  FirestoreClient(this._firestore){
    constantClient = constantFirestoreClient(_firestore);
    categoryClient = categoryFirestoreClient(_firestore);
    productClient = productFirestoreClient(_firestore);
    userClient = userProfileFirestoreClient(_firestore);
  }
}
