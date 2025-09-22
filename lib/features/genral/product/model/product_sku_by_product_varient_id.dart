class ProductSkuByProductVariantId {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  ProductSkuByProductVariantId(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  ProductSkuByProductVariantId.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isError'] = this.isError;
    data['isValidationFailed'] = this.isValidationFailed;
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? productSkuId;
  String? itemDescription;
  num? price;
  List<String>? productSkuImage;
  SelectedVariant? selectedVariant;

  Data(
      {this.productSkuId,
        this.itemDescription,
        this.price,
        this.productSkuImage,
        this.selectedVariant});

  Data.fromJson(Map<String, dynamic> json) {
    productSkuId = json['productSkuId'];
    itemDescription = json['itemDescription'];
    price = json['price'];
    productSkuImage = json['productSkuImage'].cast<String>();
    selectedVariant = json['selectedVariant'] != null
        ? new SelectedVariant.fromJson(json['selectedVariant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productSkuId'] = this.productSkuId;
    data['itemDescription'] = this.itemDescription;
    data['price'] = this.price;
    data['productSkuImage'] = this.productSkuImage;
    if (this.selectedVariant != null) {
      data['selectedVariant'] = this.selectedVariant!.toJson();
    }
    return data;
  }
}

class SelectedVariant {
  Size? size;
  Size? material;

  SelectedVariant({this.size, this.material});

  SelectedVariant.fromJson(Map<String, dynamic> json) {
    size = json['Size'] != null ? new Size.fromJson(json['Size']) : null;
    material =
    json['Material'] != null ? new Size.fromJson(json['Material']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.size != null) {
      data['Size'] = this.size!.toJson();
    }
    if (this.material != null) {
      data['Material'] = this.material!.toJson();
    }
    return data;
  }
}

class Size {
  String? id;
  String? name;
  String? attributeId;

  Size({this.id, this.name, this.attributeId});

  Size.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    attributeId = json['attributeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['attributeId'] = this.attributeId;
    return data;
  }
}
