import 'package:sales_app_redesign/features/genral/instruments/model/intrument_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';

class CartModel {
  List<Product>? productInfo;
  List<InstrumentModel>? instruments;

  CartModel({this.productInfo, this.instruments});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['listData'] != null) {
      productInfo = <Product>[];
      json['listData'].forEach((v) {
        productInfo!.add(Product.fromJson(v));
      });
    }

    if (json['instruments'] != null) {
      instruments = <InstrumentModel>[];
      json['instruments'].forEach((v) {
        instruments!.add(InstrumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (productInfo != null) {
      data['listData'] = productInfo!.map((v) => v.toJson()).toList();
    }

    if (instruments != null) {
      data['instruments'] = instruments!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
