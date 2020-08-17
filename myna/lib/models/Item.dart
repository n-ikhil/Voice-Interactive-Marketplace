import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String productID;
  String ownerID;
  String ownerNickName;
  bool isRentable;
  String postalCode;
  String place;
  int price;
  String id;
  String description;
  String contact;
  String imgURL;

  Item(DocumentSnapshot data) {
    this.productID = data.data["productID"];
    this.ownerID = data.data["ownerID"];
    this.ownerID = data.data["ownerNickName"];
    this.postalCode = data.data["postalCode"];
    this.price = data.data["price"];
    this.place = data.data["place"];
    this.id = data.documentID;
    this.contact = data.data["contact"];
    this.description = data.data["description"];
    this.isRentable = data.data["isRentable"];
    this.imgURL = data.data["imgURL"];
  }

  Item.asForm(
      {this.productID,
      this.ownerID,
      this.postalCode,
      this.isRentable,
      this.price,
      this.place,
      this.contact,
      this.description,
      this.imgURL,
      this.ownerNickName});
}
