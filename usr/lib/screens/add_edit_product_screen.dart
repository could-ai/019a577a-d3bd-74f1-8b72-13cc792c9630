import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/product_model.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _stock;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _price = widget.product?.price ?? 0.0;
    _stock = widget.product?.stock ?? 0;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newProduct = Product(
        id: widget.product?.id ?? 0,
        name: _name,
        price: _price,
        stock: _stock,
      );
      Navigator.of(context).pop(newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Upload Placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey[600]),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to upload image',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(Image upload not implemented in this demo)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Product Name Field
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name.';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(height: 16),

                // Price Field
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: const InputDecoration(labelText: 'Selling Price', prefixText: '\$'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Price must be greater than zero.';
                    }
                    return null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),
                const SizedBox(height: 16),

                // Stock Field
                TextFormField(
                  initialValue: _stock.toString(),
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the stock quantity.';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid integer.';
                    }
                    if (int.parse(value) < 0) {
                      return 'Stock cannot be negative.';
                    }
                    return null;
                  },
                  onSaved: (value) => _stock = int.parse(value!),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Save Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
