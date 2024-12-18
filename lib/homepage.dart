import 'package:flutter/material.dart';
import 'package:flutter_task1/productform.dart';
import 'package:flutter_task1/productlist.dart';
import 'package:flutter_task1/serach_bar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {},
              ),
              Text(
                'Product List',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  child: Icon(Icons.search_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final productsList = snapshot.data!;

          return ListView.builder(
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              final product = productsList[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Stack(
                    children: [
                      Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported, size: 50);
                        },
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await deleteProduct(index);
                            setState(() {
                              _productsFuture =
                                  loadProducts(); // Reload products after delete
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${product.description}\n\$${product.price.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deleteProduct(index);
                      setState(() {
                        _productsFuture =
                            loadProducts(); // Reload products after delete
                      });
                    },
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductForm()),
          );
          if (result == true) {
            setState(() {
              _productsFuture = loadProducts(); // Reload products after adding
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsString = prefs.getString('products');
    if (productsString != null && productsString.isNotEmpty) {
      try {
        final List<dynamic> productsJson = jsonDecode(productsString);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } catch (e) {
        print('Error decoding product data: $e');
        return [];
      }
    }
    return [];
  }

  Future<void> deleteProduct(int index) async {
    final products = await loadProducts();
    products.removeAt(index);
    await saveProducts(products);
    setState(() {
      _productsFuture = loadProducts(); // Update the Future
    });
  }

  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final String productsString =
        jsonEncode(products.map((product) => product.toJson()).toList());
    await prefs.setString('products', productsString);
  }
}
