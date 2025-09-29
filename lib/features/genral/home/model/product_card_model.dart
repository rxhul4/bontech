class ProductItem {
  final String id;
  final String name;
  final String code;
  final String imageUrl;

  ProductItem({
    required this.id,
    required this.name,
    required this.code,
    required this.imageUrl,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['productId'] ?? '',
      name: json['productName'] ?? '',
      code: json['productCode'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }
}
