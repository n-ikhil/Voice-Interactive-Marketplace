import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String id;

  Category(DocumentSnapshot data) {
    this.name = data.data["name"];
    this.id = data.documentID;
  }

  Category.sample() {
    this.name = "add new category";
    this.id = "-1";
  }
}
