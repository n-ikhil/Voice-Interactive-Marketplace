import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myna/services/firebase/categoryFirestoreClient.dart';
import 'package:myna/services/firebase/constantFirestoreClient.dart';
import 'package:myna/services/firebase/itemFirestoreClient.dart';
import 'package:myna/services/firebase/productFirestoreClient.dart';
import 'package:myna/services/firebase/userProfileFirestoreClient.dart';

class FirestoreClient {
  constantFirestoreClient constantClient;
  categoryFirestoreClient categoryClient;
  productFirestoreClient productClient;
  userProfileFirestoreClient userClient;
  itemFirestoreClient itemClient;

  FirestoreClient() {
    constantClient =
        constantFirestoreClient(Firestore.instance.collection("constant"));
    categoryClient =
        categoryFirestoreClient(Firestore.instance.collection("category"));
    productClient =
        productFirestoreClient(Firestore.instance.collection("product"));
    userClient =
        userProfileFirestoreClient(Firestore.instance.collection("user"));
    itemClient = itemFirestoreClient(Firestore.instance.collection("item"));
  }
}
