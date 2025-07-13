class GetHomeModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  GetHomeModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetHomeModel.fromJson(Map<String, dynamic> json) {
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
  List<Banners>? banners;
  Products? products;
  List<Categories>? categories;

  Data({this.banners, this.products, this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  String? bannerId;
  String? bannerTitle;
  String? bannerDescription;
  String? bannerImage;
  String? createdOn;

  Banners(
      {this.bannerId,
        this.bannerTitle,
        this.bannerDescription,
        this.bannerImage,
        this.createdOn});

  Banners.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    bannerTitle = json['banner_title'];
    bannerDescription = json['banner_description'];
    bannerImage = json['banner_image'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_id'] = this.bannerId;
    data['banner_title'] = this.bannerTitle;
    data['banner_description'] = this.bannerDescription;
    data['banner_image'] = this.bannerImage;
    data['created_on'] = this.createdOn;
    return data;
  }
}

class Products {
  String? trandingId;
  List<TrandingProducts>? trandingProducts;
  String? bestSellerId;
  List<BestSellerProducts>? bestSellerProducts;
  String? newArrivalId;
  List<NewArrivalProducts>? newArrivalProducts;

  Products(
      {this.trandingId,
        this.trandingProducts,
        this.bestSellerId,
        this.bestSellerProducts,
        this.newArrivalId,
        this.newArrivalProducts});

  Products.fromJson(Map<String, dynamic> json) {
    trandingId = json['tranding_id'];
    if (json['tranding_products'] != null) {
      trandingProducts = <TrandingProducts>[];
      json['tranding_products'].forEach((v) {
        trandingProducts!.add(new TrandingProducts.fromJson(v));
      });
    }
    bestSellerId = json['best_seller_id'];
    if (json['bestSeller_products'] != null) {
      bestSellerProducts = <BestSellerProducts>[];
      json['bestSeller_products'].forEach((v) {
        bestSellerProducts!.add(new BestSellerProducts.fromJson(v));
      });
    }
    newArrivalId = json['new_arrival_id'];
    if (json['newArrival_products'] != null) {
      newArrivalProducts = <NewArrivalProducts>[];
      json['newArrival_products'].forEach((v) {
        newArrivalProducts!.add(new NewArrivalProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tranding_id'] = this.trandingId;
    if (this.trandingProducts != null) {
      data['tranding_products'] =
          this.trandingProducts!.map((v) => v.toJson()).toList();
    }
    data['best_seller_id'] = this.bestSellerId;
    if (this.bestSellerProducts != null) {
      data['bestSeller_products'] =
          this.bestSellerProducts!.map((v) => v.toJson()).toList();
    }
    data['new_arrival_id'] = this.newArrivalId;
    if (this.newArrivalProducts != null) {
      data['newArrival_products'] =
          this.newArrivalProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrandingProducts {
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

  TrandingProducts(
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

  TrandingProducts.fromJson(Map<String, dynamic> json) {
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
class BestSellerProducts {
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

  BestSellerProducts(
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

  BestSellerProducts.fromJson(Map<String, dynamic> json) {
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
class NewArrivalProducts {
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

  NewArrivalProducts(
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

  NewArrivalProducts.fromJson(Map<String, dynamic> json) {
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

class Categories {
  String? categoryId;
  String? categoryName;
  String? categoryImage;
  String? createdOn;

  Categories(
      {this.categoryId, this.categoryName, this.categoryImage, this.createdOn});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_image'] = this.categoryImage;
    data['created_on'] = this.createdOn;
    return data;
  }
}
