import 'package:sales_app_redesign/features/genral/instruments/model/intrument_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';

class CartModel {
  List<Product>? productInfo;

  CartModel({this.productInfo});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['listData'] != null) {
      productInfo = <Product>[];
      json['listData'].forEach((v) {
        productInfo!.add(Product.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (productInfo != null) {
      data['listData'] = productInfo!.map((v) => v.toJson()).toList();
    }


    return data;
  }
}
