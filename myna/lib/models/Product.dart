class Product {
  String name;
  String id;
  Product(data) {
    this.name = data.data.name;
    this.id = data.documentId;
  }
}
