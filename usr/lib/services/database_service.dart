import 'package:couldai_user_app/models/product_model.dart';

class DatabaseService {
  // This is a mock database. In a real app, you would use a local database
  // solution like Hive, Drift, or sqflite to persist data offline.
  final List<Product> _products = [
    Product(id: 1, name: "Aspirin - 500mg", price: 15.99, stock: 120, image: null),
    Product(id: 2, name: "Ibuprofen - 200mg", price: 12.50, stock: 80, image: null),
    Product(id: 3, name: "Paracetamol - 500mg", price: 10.00, stock: 200, image: null),
    Product(id: 4, name: "Amoxicillin - 250mg", price: 25.75, stock: 50, image: null),
    Product(id: 5, name: "Vitamin C - 1000mg", price: 30.00, stock: 150, image: null),
    Product(id: 6, name: "Loratadine - 10mg", price: 18.20, stock: 75, image: null),
    Product(id: 7, name: "Omeprazole - 20mg", price: 45.50, stock: 40, image: null),
    Product(id: 8, name: "Metformin - 500mg", price: 22.00, stock: 60, image: null),
  ];

  int _nextId = 9;

  Future<List<Product>> getProducts() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _products.sort((a, b) => a.name.compareTo(b.name));
    return _products;
  }

  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 100));
    product.id = _nextId++;
    _products.add(product);
  }

  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  Future<void> deleteProduct(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _products.removeWhere((p) => p.id == id);
  }
}
