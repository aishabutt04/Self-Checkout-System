class Product {
  int id;
  String name;
  double price;
  int quantity;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
      quantity: json['quantity'],
    );
  }
}
