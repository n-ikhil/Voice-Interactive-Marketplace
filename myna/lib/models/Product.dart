import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  String id;
  Product(DocumentSnapshot data) {
    this.name = data.data["name"];
    this.id = data.documentID;
  }

  Product.sample() {
    this.name = "add new product";
    this.id = "-1";
  }
}
