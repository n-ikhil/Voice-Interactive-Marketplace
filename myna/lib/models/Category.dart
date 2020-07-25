import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String id;

  Category(DocumentSnapshot data) {
    this.name = data.data["name"];
    this.id = data.documentID;
  }
}
