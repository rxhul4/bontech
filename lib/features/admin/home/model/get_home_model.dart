class GetHomeModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  GetHomeModel({
    this.isError,
    this.isValidationFailed,
    this.errorCode,
    this.message,
    this.data,
  });

  GetHomeModel.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'isError': isError,
      'isValidationFailed': isValidationFailed,
      'errorCode': errorCode,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class Data {
  List<Banners>? banners;
  List<Categories>? categories;
  List<TrendingProducts>? trendingProducts;
  List<BestSellers>? bestSellers;
  List<NewArrivals>? newArrivals;

  Data({
    this.banners,
    this.categories,
    this.trendingProducts,
    this.bestSellers,
    this.newArrivals,
  });

  Data.fromJson(Map<String, dynamic> json) {
    banners = (json['banners'] as List?)?.map((v) => Banners.fromJson(v)).toList();
    categories = (json['categories'] as List?)?.map((v) => Categories.fromJson(v)).toList();
    trendingProducts = (json['trendingProducts'] as List?)?.map((v) => TrendingProducts.fromJson(v)).toList();
    bestSellers = (json['bestSellers'] as List?)?.map((v) => BestSellers.fromJson(v)).toList();
    newArrivals = (json['newArrivals'] as List?)?.map((v) => NewArrivals.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      if (banners != null) 'banners': banners!.map((v) => v.toJson()).toList(),
      if (categories != null) 'categories': categories!.map((v) => v.toJson()).toList(),
      if (trendingProducts != null) 'trendingProducts': trendingProducts!.map((v) => v.toJson()).toList(),
      if (bestSellers != null) 'bestSellers': bestSellers!.map((v) => v.toJson()).toList(),
      if (newArrivals != null) 'newArrivals': newArrivals!.map((v) => v.toJson()).toList(),
    };
  }
}

class Banners {
  String? bannerId;
  String? bannerTitle;
  String? bannerDescription;
  String? bannerImage;
  String? createdOn;

  Banners({
    this.bannerId,
    this.bannerTitle,
    this.bannerDescription,
    this.bannerImage,
    this.createdOn,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    bannerTitle = json['banner_title'];
    bannerDescription = json['banner_description'];
    bannerImage = json['banner_image'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    return {
      'banner_id': bannerId,
      'banner_title': bannerTitle,
      'banner_description': bannerDescription,
      'banner_image': bannerImage,
      'created_on': createdOn,
    };
  }
}

class Categories {
  String? categoryId;
  String? categoryName;
  String? categoryImage;
  String? createdOn;

  Categories({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.createdOn,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'category_image': categoryImage,
      'created_on': createdOn,
    };
  }
}

class TrendingProducts {
  String? productId;
  String? productName;
  String? productCode;
  String? image;

  TrendingProducts({
    this.productId,
    this.productName,
    this.productCode,
    this.image,
  });

  TrendingProducts.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productCode = json['productCode'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'image': image,
    };
  }
}

class BestSellers {
  String? productId;
  String? productName;
  String? productCode;
  String? image;

  BestSellers({
    this.productId,
    this.productName,
    this.productCode,
    this.image,
  });

  BestSellers.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productCode = json['productCode'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'image': image,
    };
  }
}

class NewArrivals {
  String? productId;
  String? productName;
  String? productCode;
  String? image;

  NewArrivals({
    this.productId,
    this.productName,
    this.productCode,
    this.image,
  });

  NewArrivals.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productCode = json['productCode'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'image': image,
    };
  }
}
