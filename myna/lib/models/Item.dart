import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String productID;
  String ownerID;
  bool isPublic;
  bool isRentable;
  String postalCode;

  Item(DocumentSnapshot data) {
    this.productID = data.data["productID"];
    this.ownerID = data.data["ownerID"];
    this.isPublic = data.data["isPublic"];
    this.isRentable = data.data["isRentable"];
    this.postalCode = data.data["postalCode"];
  }

  Item.asForm(
      {this.productID,
      this.ownerID,
      this.postalCode,
      this.isPublic,
      this.isRentable});
}
