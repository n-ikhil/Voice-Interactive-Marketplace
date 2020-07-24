class Product {
  String name;
  String statement;
  String location;
  String id;
  String price;

  String description;
  List<String> imageLinks;
  String ownerId;

  Product.asListItem(dynamic data) {
    this.name = data.name;
    this.statement = data.statment;
    this.location = data.location;
    this.id = data.id;
    this.price = data.price;
  }
  Product.asDetail(data) {
    this.name = data.name;
    this.statement = data.statment;
    this.location = data.location;
    this.id = data.id;
    this.price = data.price;

    this.description = data.description;
    this.imageLinks = data.imageLinks;
    this.ownerId = data.ownerId;
  }
}
