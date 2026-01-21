class ProductVariant {
  String? id;
  String? productId;
  String name;
  double price;
  int stock;

  ProductVariant({
    this.id,
    this.productId,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }
}

class Produk {
  String? id;
  String name;
  String? description;
  double price;
  int stock;
  List<String> imageUrls;
  String? categoryId;
  List<ProductVariant> variants;

  Produk({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.imageUrls,
    this.categoryId,
    this.variants = const [],
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      categoryId: json['category_id'],
      variants:
          (json['product_variants'] as List<dynamic>?)
              ?.map((e) => ProductVariant.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_urls': imageUrls,
      'category_id': categoryId,
    };
  }
}
