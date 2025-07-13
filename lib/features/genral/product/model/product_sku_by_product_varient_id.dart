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
  int? price;
  List<String>? productSkuImage;

  Data({this.productSkuId, this.price, this.productSkuImage});

  Data.fromJson(Map<String, dynamic> json) {
    productSkuId = json['productSkuId'];
    price = json['price'];
    productSkuImage = json['productSkuImage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productSkuId'] = this.productSkuId;
    data['price'] = this.price;
    data['productSkuImage'] = this.productSkuImage;
    return data;
  }
}
