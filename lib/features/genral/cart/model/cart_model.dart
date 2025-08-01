import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart';

class CartModel {
  List<Product>? productInfo;

  CartModel({this.productInfo});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['listData'] != null) {
      productInfo = <Product>[];
      json['listData'].forEach((v) {
        productInfo!.add(new Product.fromJson(v));
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

