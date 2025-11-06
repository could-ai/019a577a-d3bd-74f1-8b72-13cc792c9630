class Product {
  int id;
  String name;
  double price;
  int stock;
  String? image; // For now, this will be a placeholder path or icon data

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.image,
  });
}
