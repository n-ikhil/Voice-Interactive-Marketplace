import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String productID;
  String ownerID;
  bool isRentable;
  String postalCode;
  String place;
  int price;
  String id;
  String description;
  String contact;

  Item(DocumentSnapshot data) {
    this.productID = data.data["productID"];
    this.ownerID = data.data["ownerID"];
    this.postalCode = data.data["postalCode"];
    this.price = data.data["price"];
    this.place = data.data["place"];
    this.id = data.documentID;
    this.contact = data.data["contact"];
    this.description = data.data["description"];
    this.isRentable = data.data["isRentable"];
  }

  Item.asForm({
    this.productID,
    this.ownerID,
    this.postalCode,
    this.isRentable,
    this.price,
    this.place,
    this.contact,
    this.description,
  });
}
