import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String productID;
  String ownerID;
  bool isPublic;
  bool isRentable;
  String postalCode;
  String place;
  int price;
  String id;

  Item(DocumentSnapshot data) {
    this.productID = data.data["productID"];
    this.ownerID = data.data["ownerID"];
    this.isPublic = data.data["isPublic"];
    this.isRentable = data.data["isRentable"];
    this.postalCode = data.data["postalCode"];
    this.price = data.data["price"];
    this.place = data.data["place"];
    this.id = data.documentID;
  }

  Item.asForm(
      {this.productID,
      this.ownerID,
      this.postalCode,
      this.isPublic,
      this.isRentable,
      this.price,
      this.place});
}
