class Item {
  String productID;
  String categoryID;
  String ownerID;
  bool isPrivate;

  Item(data) {
    this.productID = data.productID;
    this.categoryID = data.categoryID;
    this.ownerID = data.ownerID;
    this.isPrivate = data.isPrivate;
  }
}
