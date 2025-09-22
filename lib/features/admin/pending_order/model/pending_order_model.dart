import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';
class PendingOrderResponse {
  final bool isError;
  final bool isValidationFailed;
  final String errorCode;
  final String message;
  final List<ProductData1> pendingProductData;

  PendingOrderResponse({
    required this.isError,
    required this.isValidationFailed,
    required this.errorCode,
    required this.message,
    required this.pendingProductData,
  });

  factory PendingOrderResponse.fromJson(Map<String, dynamic> json) {
    return PendingOrderResponse(
      isError: json['isError'] ?? false,
      isValidationFailed: json['isValidationFailed'] ?? false,
      errorCode: json['errorCode'] ?? '',
      message: json['message'] ?? '',
      pendingProductData: (json['data'] as List<dynamic>)
          .map((e) => ProductData1.fromJson(e))
          .toList(),
    );
  }
}



class ProductData1 {
  final String productId;
  final String productName;
  final String categoryId;
  final String categoryName;
  final String imagePath;
  int pendingQuantity;
  final String productVariantId;
  final double productPrice;
  final Map<String, VariantOption>? productVariant;

  ProductData1({
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.categoryName,
    required this.imagePath,
    required this.pendingQuantity,
    required this.productVariantId,
    required this.productVariant,
    required this.productPrice,
  });

  factory ProductData1.fromJson(Map<String, dynamic> json) {
    final variantJson = json['product_variant'] as Map<String, dynamic>?;

    final variants = variantJson != null
        ? variantJson.map(
          (key, value) => MapEntry(
        key,
        VariantOption.fromJson(value as Map<String, dynamic>),
      ),
    )
        : null;

    return ProductData1(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      imagePath: json['image_path'] ?? '',
      pendingQuantity: json['pending_quantity'] ?? 0,
      productVariantId: json['product_variant_id'] ?? '',
      productVariant: variants,
      productPrice: (json['product_price'] != null)
          ? (json['product_price'] as num).toDouble()
          : 0.0, // ✅ safe parsing
    );
  }
}
