class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String category;


  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,

  });


  factory Product.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imagesList = json['images'] ?? [];
    return Product(
      id: json['id'],
      name: json['title'],
      price: (json['price'] as num).toDouble(),
      image:imagesList.isNotEmpty ? imagesList[0].toString() : 'https://placehold.co/600x400',
      category: json['category'] != null
          ? json['category']['name']
          : 'Unknown',
    );
  }
}
