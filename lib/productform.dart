import 'package:flutter/material.dart';
import 'package:flutter_task1/productlist.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsString = prefs.getString('products');
    if (productsString != null) {
      List<dynamic> productsJson = jsonDecode(productsString);
      setState(() {
        _products.addAll(productsJson.map((json) => Product.fromJson(json)).toList());
      });
    }
  }

  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    String productsString = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString('products', productsString);
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
      );

      setState(() {
        _products.add(newProduct);
      });

      saveProducts(_products);

      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a product name'
                      : null,
                ),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a price'
                      : double.tryParse(value) == null
                          ? 'Please enter a valid number'
                          : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an image URL'
                      : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProduct,
                  child: Text('Add Product'),
                ),
                SizedBox(height: 20),
                Text(
                  'Product List:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._products.map((product) => ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                          '\$${product.price.toStringAsFixed(2)} - ${product.description}'),
                      leading: Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}