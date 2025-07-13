import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart';

class CartModel {
  List<ProductInfo>? productInfo;

  CartModel({this.productInfo});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['listData'] != null) {
      productInfo = <ProductInfo>[];
      json['listData'].forEach((v) {
        productInfo!.add(new ProductInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productInfo != null) {
      data['listData'] = this.productInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
// class ProductInfo {
//   bool? isExistInPref;
//   int? qty;
//   num? calculatedPrice;
//   ColorData? selectedColor;
//   Steps? selectedSize;
//   MaterialData? selectedMaterial;
//   String? productId;
//   String? productName;
//   String? productDescription;
//   List<String>? productImages;
//   String? productCategoryId;
//   String? productCategoryName;
//   String? image;
//   int? price;
//   String? productVariantId;
//   ProductVariant? productVariant;
//   List<AllVariants>? allVariants;
//
//   ProductInfo({
//     this.isExistInPref,
//     this.qty,
//     this.calculatedPrice,
//     this.selectedColor,
//     this.selectedSize,
//     this.selectedMaterial,
//     this.productId,
//     this.productName,
//     this.productDescription,
//     this.productImages,
//     this.productCategoryId,
//     this.productCategoryName,
//     this.image,
//     this.price,
//     this.productVariantId,
//     this.productVariant,
//     this.allVariants,
//   });
//
//   ProductInfo.fromJson(Map<String, dynamic> json) {
//     isExistInPref = json['isExistInPref'];
//     qty = json['qty'];
//     calculatedPrice = json['calculatedPrice'];
//     selectedColor = json['selectedColor'] != null
//         ? ColorData.fromJson(json['selectedColor'])
//         : null;
//     selectedSize = json['selectedSize'] != null
//         ? Steps.fromJson(json['selectedSize'])
//         : null;
//     selectedMaterial = json['selectedMaterial'] != null
//         ? MaterialData.fromJson(json['selectedMaterial'])
//         : null;
//     productId = json['productId'];
//     productName = json['productName'];
//     productDescription = json['productDescription'];
//     productImages = json['productImages'] != null
//         ? List<String>.from(json['productImages'])
//         : null;
//     productCategoryId = json['productCategoryId'];
//     productCategoryName = json['productCategoryName'];
//     image = json['image'];
//     price = json['price'];
//     productVariantId = json['productVariantId'];
//     productVariant = json['productVariant'] != null
//         ? ProductVariant.fromJson(json['productVariant'])
//         : null;
//     allVariants = json['allVariants'] != null
//         ? List<AllVariants>.from(
//         json['allVariants'].map((v) => AllVariants.fromJson(v)))
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'isExistInPref': isExistInPref,
//       'qty': qty,
//       'calculatedPrice': calculatedPrice,
//       'selectedColor': selectedColor?.toJson(),
//       'selectedSize': selectedSize?.toJson(),
//       'selectedMaterial': selectedMaterial?.toJson(),
//       'productId': productId,
//       'productName': productName,
//       'productDescription': productDescription,
//       'productImages': productImages,
//       'productCategoryId': productCategoryId,
//       'productCategoryName': productCategoryName,
//       'image': image,
//       'price': price,
//       'productVariantId': productVariantId,
//       'productVariant': productVariant?.toJson(),
//       'allVariants': allVariants?.map((v) => v.toJson()).toList(),
//     };
//   }
// }
