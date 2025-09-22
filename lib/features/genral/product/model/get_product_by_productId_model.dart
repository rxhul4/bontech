class ProductResponse {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  ProductData? data;

  ProductResponse({
    this.isError,
    this.isValidationFailed,
    this.errorCode,
    this.message,
    this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      isError: json['isError'],
      isValidationFailed: json['isValidationFailed'],
      errorCode: json['errorCode'],
      message: json['message'],
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'isError': isError,
    'isValidationFailed': isValidationFailed,
    'errorCode': errorCode,
    'message': message,
    'data': data?.toJson(),
  };
}

class ProductData {
  int? productCount;
  Product? productInfo;

  ProductData({this.productCount, this.productInfo});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productCount: json['productCount'],
      productInfo: json['productInfo'] != null
          ? Product.fromJson(json['productInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'productCount': productCount,
    'productInfo': productInfo?.toJson(),
  };
}


class Product {
  String? productId;
  int? productQty;
  int? calculatedPrice;
  bool? isSelected;
  String? productName;
  String? productDescription;
  List<String>? productImages;
  String? productCategoryId;
  String? productCategoryName;
  String? image;
  num? price;
  String? productVariantId;
  Map<String, VariantOption>? productVariant;
  List<VariantAttribute>? allVariants;

  Product({
    this.productId,
    this.productQty,
    this.isSelected,
    this.calculatedPrice,
    this.productName,
    this.productDescription,
    this.productImages,
    this.productCategoryId,
    this.productCategoryName,
    this.image,
    this.price,
    this.productVariantId,
    this.productVariant,
    this.allVariants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      productQty: json['productQty'],
      calculatedPrice: json['calculatedPrice'],
      productImages:
      (json['productImages'] as List<dynamic>?)?.cast<String>(),
      productCategoryId: json['productCategoryId'],
      productCategoryName: json['productCategoryName'],
      image: json['image'],
      price: (json['price'] as num?),
      productVariantId: json['productVariantId'],
      productVariant: (json['productVariant'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, VariantOption.fromJson(value)),
      ),
      allVariants: (json['allVariants'] as List<dynamic>?)
          ?.map((e) => VariantAttribute.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productDescription': productDescription,
    'productQty': productQty,
    'calculatedPrice': calculatedPrice,
    'productImages': productImages,
    'productCategoryId': productCategoryId,
    'productCategoryName': productCategoryName,
    'image': image,
    'price': price,
    'productVariantId': productVariantId,
    'productVariant': productVariant?.map((k, v) => MapEntry(k, v.toJson())),
    'allVariants': allVariants?.map((e) => e.toJson()).toList(),
  };
}

class ProductVariant {
  String? id;
  String? name;
  String? attributeId;
  bool? isSelected;

  ProductVariant({this.id, this.name, this.attributeId,this.isSelected});

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      name: json['name'],
      attributeId: json['attributeId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'attributeId': attributeId,
  };
}

class VariantAttribute {
  String? key;
  List<VariantOption>? value;

  VariantAttribute({this.key, this.value});

  factory VariantAttribute.fromJson(Map<String, dynamic> json) {
    return VariantAttribute(
      key: json['key'],
      value: (json['value'] as List<dynamic>?)
          ?.map((e) => VariantOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value?.map((e) => e.toJson()).toList(),
  };
}

class VariantOption {
  String? id;
  String? name;
  String? attributeId;

  VariantOption({this.id, this.name, this.attributeId});

  factory VariantOption.fromJson(Map<String, dynamic> json) {
    return VariantOption(
      id: json['id'],
      name: json['name'],
      attributeId: json['attributeId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'attributeId': attributeId,
  };
}
