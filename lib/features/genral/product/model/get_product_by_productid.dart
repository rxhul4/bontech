class GetProductByProductId {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  GetProductByProductId(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetProductByProductId.fromJson(Map<String, dynamic> json) {
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
  int? productCount;
  int? calculatedPrice;
  List<ProductInfo>? productInfo;

  Data({this.productCount, this.productInfo});

  Data.fromJson(Map<String, dynamic> json) {
    productCount = json['productCount'];
    calculatedPrice = json['calculatedPrice'];
    if (json['productInfo'] != null) {
      productInfo = <ProductInfo>[];
      json['productInfo'].forEach((v) {
        productInfo!.add(new ProductInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCount'] = this.productCount;
    data['calculatedPrice'] = this.calculatedPrice;
    if (this.productInfo != null) {
      data['productInfo'] = this.productInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductInfo {
  bool? isExistInPref;
  int? qty;
  int? calculatedPrice;
  ColorData? selectedColor;
  Steps? selectedSize;
  Side? selectedSide;
  MaterialData? selectedMaterial;
  String? productId;
  String? productName;
  String? productDescription;
  List<String>? productImages;
  String? productCategoryId;
  String? productCategoryName;
  String? image;
  int? price;
  String? productVariantId;
  ProductVariant? productVariant;
  List<AllVariants>? allVariants;

  ProductInfo({
    this.isExistInPref,
    this.qty,
    this.calculatedPrice,
    this.selectedColor,
    this.selectedSide,
    this.selectedSize,
    this.selectedMaterial,
    this.productId,
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

  ProductInfo.fromJson(Map<String, dynamic> json) {
    isExistInPref = json['isExistInPref'];
    qty = json['qty'];
    calculatedPrice = json['calculatedPrice'];
    selectedColor = json['selectedColor'] != null
        ? ColorData.fromJson(json['selectedColor'])
        : null;
    selectedSize = json['selectedSize'] != null
        ? Steps.fromJson(json['selectedSize'])
        : null;
    selectedMaterial = json['selectedMaterial'] != null
        ? MaterialData.fromJson(json['selectedMaterial'])
        : null;
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    productImages = json['productImages'] != null
        ? List<String>.from(json['productImages'])
        : null;
    productCategoryId = json['productCategoryId'];
    productCategoryName = json['productCategoryName'];
    image = json['image'];
    price = json['price'];
    productVariantId = json['productVariantId'];
    productVariant = json['productVariant'] != null
        ? ProductVariant.fromJson(json['productVariant'])
        : null;
    allVariants = json['allVariants'] != null
        ? List<AllVariants>.from(
        json['allVariants'].map((v) => AllVariants.fromJson(v)))
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'isExistInPref': isExistInPref,
      'qty': qty,
      'calculatedPrice': calculatedPrice,
      'selectedColor': selectedColor?.toJson(),
      'selectedSize': selectedSize?.toJson(),
      'selectedMaterial': selectedMaterial?.toJson(),
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'productImages': productImages,
      'productCategoryId': productCategoryId,
      'productCategoryName': productCategoryName,
      'image': image,
      'price': price,
      'productVariantId': productVariantId,
      'productVariant': productVariant?.toJson(),
      'allVariants': allVariants?.map((v) => v.toJson()).toList(),
    };
  }
}

class ProductVariant {
  ColorData? color;
  MaterialData? material;
  Steps? steps;
  Side? side;


  ProductVariant({this.color, this.material, this.steps,this.side});

  ProductVariant.fromJson(Map<String, dynamic> json) {
    color = json['color'] != null ? new ColorData.fromJson(json['color']) : null;
    material = json['material'] != null ? new MaterialData.fromJson(json['material']) : null;
    steps = json['steps'] != null ? new Steps.fromJson(json['steps']) : null;
    side = json['side'] != null ? new Side.fromJson(json['side']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.color != null) {
      data['color'] = this.color!.toJson();
    }
    if (this.material != null) {
      data['material'] = this.material!.toJson();
    }
    if (this.steps != null) {
      data['steps'] = this.steps!.toJson();
    }
    if (this.side != null) {
      data['side'] = this.side!.toJson();
    }
    return data;
  }
}

class ColorData {
  String? id;
  String? name;
  String? attributeId;

  ColorData({this.id, this.name, this.attributeId});

  ColorData.fromJson(Map<String, dynamic> json) {
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

class MaterialData {
  String? id;
  String? name;
  String? attributeId;

  MaterialData({this.id, this.name, this.attributeId});

  MaterialData.fromJson(Map<String, dynamic> json) {
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

class Side {
  String? id;
  String? name;
  String? attributeId;

  Side({this.id, this.name, this.attributeId});

  Side.fromJson(Map<String, dynamic> json) {
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

class Steps {
  String? id;
  String? name;
  String? attributeId;

  Steps({this.id, this.name, this.attributeId});

  Steps.fromJson(Map<String, dynamic> json) {
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


class AllVariants {
  List<ColorData>? color;
  List<MaterialData>? material;
  List<Steps>? steps;
  List<Side>? side;

  AllVariants({this.color, this.material, this.steps,this.side});

  AllVariants.fromJson(Map<String, dynamic> json) {
    if (json['color'] != null) {
      color = <ColorData>[];
      json['color'].forEach((v) {
        color!.add(new ColorData.fromJson(v));
      });
    }
    if (json['material'] != null) {
      material = <MaterialData>[];
      json['material'].forEach((v) {
        material!.add(new MaterialData.fromJson(v));
      });
    }
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(new Steps.fromJson(v));
      });
    }
    if (json['side'] != null) {
      side = <Side>[];
      json['side'].forEach((v) {
        side!.add(new Side.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.color != null) {
      data['color'] = this.color!.map((v) => v.toJson()).toList();
    }
    if (this.material != null) {
      data['material'] = this.material!.map((v) => v.toJson()).toList();
    }
    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
