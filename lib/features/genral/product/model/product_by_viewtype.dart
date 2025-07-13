class HomViewTypeByIdModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  HomViewTypeByIdModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  HomViewTypeByIdModel.fromJson(Map<String, dynamic> json) {
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
  int? pageSize;
  int? pageNo;
  int? recordCount;
  List<ProductList>? listItem;

  Data({this.pageSize, this.pageNo, this.recordCount, this.listItem});

  Data.fromJson(Map<String, dynamic> json) {
    pageSize = json['pageSize'];
    pageNo = json['pageNo'];
    recordCount = json['recordCount'];
    if (json['listItem'] != null) {
      listItem = <ProductList>[];
      json['listItem'].forEach((v) {
        listItem!.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageSize'] = this.pageSize;
    data['pageNo'] = this.pageNo;
    data['recordCount'] = this.recordCount;
    if (this.listItem != null) {
      data['listItem'] = this.listItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  String? productId;
  String? categoryId;
  String? categoryName;
  String? productName;
  String? productCode;
  String? productDescription;
  String? imagePath;
  List<String>? totViewIds;
  bool? isFavourite;
  String? createdOn;
  List<ProductVariants>? productVariants;

  ProductList(
      {this.productId,
        this.categoryId,
        this.categoryName,
        this.productName,
        this.productCode,
        this.productDescription,
        this.imagePath,
        this.totViewIds,
        this.isFavourite,
        this.createdOn,
        this.productVariants});

  ProductList.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    productName = json['product_name'];
    productCode = json['product_code'];
    productDescription = json['product_description'];
    imagePath = json['image_path'];
    totViewIds = json['tot_view_ids'].cast<String>();
    isFavourite = json['is_favourite'];
    createdOn = json['created_on'];
    if (json['productVariants'] != null) {
      productVariants = <ProductVariants>[];
      json['productVariants'].forEach((v) {
        productVariants!.add(new ProductVariants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['product_name'] = this.productName;
    data['product_code'] = this.productCode;
    data['product_description'] = this.productDescription;
    data['image_path'] = this.imagePath;
    data['tot_view_ids'] = this.totViewIds;
    data['is_favourite'] = this.isFavourite;
    data['created_on'] = this.createdOn;
    if (this.productVariants != null) {
      data['productVariants'] =
          this.productVariants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductVariants {
  String? uomId;
  String? uomName;
  List<String>? productSkuId;
  List<Value>? value;

  ProductVariants({this.uomId, this.uomName, this.productSkuId, this.value});

  ProductVariants.fromJson(Map<String, dynamic> json) {
    uomId = json['uom_id'];
    uomName = json['uom_name'];
    productSkuId = json['productSkuId'].cast<String>();
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(new Value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uom_id'] = this.uomId;
    data['uom_name'] = this.uomName;
    data['productSkuId'] = this.productSkuId;
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value {
  String? id;
  List<String>? productSKUId;
  String? name;

  Value({this.id, this.productSKUId, this.name});

  Value.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSKUId = json['productSKUId'].cast<String>();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productSKUId'] = this.productSKUId;
    data['name'] = this.name;
    return data;
  }
}
