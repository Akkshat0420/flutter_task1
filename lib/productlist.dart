class Product {
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
      };

  // Convert JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
