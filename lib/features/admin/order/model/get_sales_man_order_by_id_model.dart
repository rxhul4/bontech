import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';

class GetAllSalesmanOrderByIdModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  GetAllSalesmanOrderByIdModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  factory GetAllSalesmanOrderByIdModel.fromJson(Map<String, dynamic> json) {
    return GetAllSalesmanOrderByIdModel(
      isError: json['isError'] ?? false,
      isValidationFailed: json['isValidationFailed'] ?? false,
      errorCode: json['errorCode'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  String? salesmanOrderId;
  String? salesmanId;
  String? hospitalName;
  String? hospitalAddress;
  String? hospitalPhoneNo;
  String? salesmanName;
  String? orderDate;
  String? totOrderStatusId;
  String? totOrderStatus;
  num? totalAmount;
  String? trackingNo;
  String? createdOn;
  List<SalesOrderProductList>? salesOrderDetails;

  Data(
      {this.salesmanOrderId,
        this.salesmanId,
        this.hospitalName,
        this.hospitalAddress,
        this.hospitalPhoneNo,
        this.salesmanName,
        this.orderDate,
        this.totOrderStatusId,
        this.totOrderStatus,
        this.totalAmount,
        this.trackingNo,
        this.createdOn,
        this.salesOrderDetails});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      salesmanOrderId: json['salesman_order_id'] ?? '',
      salesmanId: json['salesman_id'] ?? '',
      hospitalName: json['hospital_name'] ?? '',
      hospitalAddress: json['hospital_address'] ?? '',
      hospitalPhoneNo: json['hospital_phone_no'] ?? '',
      salesmanName: json['salesman_name'] ?? '',
      orderDate: json['order_date'] ?? '',
      totOrderStatusId: json['tot_order_status_id'] ?? '',
      totOrderStatus: json['tot_order_status'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      trackingNo: json['tracking_no'] ?? '',
      salesOrderDetails: (json['salesOrderDetails'] as List<dynamic>?)
          ?.map((e) => SalesOrderProductList.fromJson(e))
          .toList() ??
          [],
    );
  }
}


class SalesOrderProductList {
  String? productId;
  String? productName;
  String? categoryId;
  String? categoryName;
  String? productSKUID;
  String? productImage;
  Map<String, VariantOption>? productVariant;
  String? size;
  String? color;
  String? material;
  num? price;
  num? quantity;
  String? totOrderStatusId;
  String? totOrderStatus;
  num? subAmount;
  num? deliveredQuantity;

  SalesOrderProductList(
      {this.productId,
        this.productName,
        this.categoryId,
        this.categoryName,
        this.productSKUID,
        this.productImage,
        this.size,
        this.color,
        this.material,
        this.price,
        this.quantity,
        this.totOrderStatusId,
        this.totOrderStatus,
        this.subAmount,
        this.productVariant,
        this.deliveredQuantity});

  factory SalesOrderProductList.fromJson(Map<String, dynamic> json) {
    final Map<String, VariantOption> variantMap = {};
    if (json['productVariant'] != null) {
      final variantJson = json['productVariant'] as Map<String, dynamic>;
      variantJson.forEach((key, value) {
        variantMap[key] = VariantOption.fromJson(value);
      });
    }

    return SalesOrderProductList(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      categoryId: json['categoryId'],
      categoryName: json['categoryName'] ?? '',
      productSKUID: json['productSKU_ID'] ?? '',
      productImage: json['productImage'] ?? '',
      productVariant: variantMap,
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
      totOrderStatusId: json['tot_order_status_id'] ?? '',
      totOrderStatus: json['tot_order_status'] ?? '',
      subAmount: json['subAmount'] ?? 0,
      deliveredQuantity: json['deliveredQuantity'] ?? 0,
    );
  }


}






