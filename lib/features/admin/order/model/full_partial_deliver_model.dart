class FullyPartiallyDeliveredModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  FullyPartiallyDeliveredModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  FullyPartiallyDeliveredModel.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  String? salesOrderId;
  String? orderStatus;
  String? orderStatusId;
  List<Items>? items;

  Data(
      {this.orderId,
        this.salesOrderId,
        this.orderStatus,
        this.orderStatusId,
        this.items});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    salesOrderId = json['salesOrderId'];
    orderStatus = json['orderStatus'];
    orderStatusId = json['orderStatusId'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['salesOrderId'] = this.salesOrderId;
    data['orderStatus'] = this.orderStatus;
    data['orderStatusId'] = this.orderStatusId;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? productId;
  String? productSkuId;
  int? orderedQuantity;
  int? deliveredQuantity;
  String? deliveryStatus;

  Items(
      {this.productId,
        this.productSkuId,
        this.orderedQuantity,
        this.deliveredQuantity,
        this.deliveryStatus});

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productSkuId = json['productSkuId'];
    orderedQuantity = json['orderedQuantity'];
    deliveredQuantity = json['deliveredQuantity'];
    deliveryStatus = json['deliveryStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productSkuId'] = this.productSkuId;
    data['orderedQuantity'] = this.orderedQuantity;
    data['deliveredQuantity'] = this.deliveredQuantity;
    data['deliveryStatus'] = this.deliveryStatus;
    return data;
  }
}
