import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/product_model.dart';
import 'package:couldai_user_app/services/database_service.dart';
import 'package:couldai_user_app/widgets/product_card.dart';
import 'package:couldai_user_app/screens/add_edit_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<Product>> _productsFuture;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshProductList();
    _searchController.addListener(_filterProducts);
  }

  void _refreshProductList() {
    setState(() {
      _productsFuture = _dbService.getProducts();
      _productsFuture.then((products) {
        setState(() {
          _products = products;
          _filterProducts();
        });
      });
    });
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToAddEditScreen({Product? product}) async {
    final result = await Navigator.of(context).push<Product>(
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: product),
      ),
    );

    if (result != null) {
      if (product != null) {
        // Editing existing product
        await _dbService.updateProduct(result);
      } else {
        // Adding new product
        await _dbService.addProduct(result);
      }
      _refreshProductList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Inventory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by drug name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (_filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 2 / 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => _navigateToAddEditScreen(product: product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
