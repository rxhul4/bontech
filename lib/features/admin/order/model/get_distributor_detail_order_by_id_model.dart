import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';

class GetDistributorOrderByIdModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  GetDistributorOrderByIdModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetDistributorOrderByIdModel.fromJson(Map<String, dynamic> json) {
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
  String? dealerOrderId;
  String? dealerId;
  String? dealerName;
  String? dealerPhoneNo;
  String? dealerEmail;
  String? dealerAddress;
  String? dealerCity;
  String? dealerState;
  String? dealerCountry;
  String? distributorNote;
  String? manufactureDeliveryNote;
  String? orderDate;
  String? totOrderStatusId;
  String? totOrderStatus;
  num? totalAmount;
  String? trackingNo;
  Null? createdOn;
  String? productId;
  String? productName;
  String? productImage;
  String? categoryId;
  String? categoryName;
  String? productSkuId;
  num? quantity;
  num? amount;
  List<DealerOrderDetails>? dealerOrderDetails;

  Data(
      {this.dealerOrderId,
        this.dealerId,
        this.dealerName,
        this.dealerPhoneNo,
        this.dealerEmail,
        this.dealerAddress,
        this.dealerCity,
        this.dealerState,
        this.dealerCountry,
        this.distributorNote,
        this.manufactureDeliveryNote,
        this.orderDate,
        this.totOrderStatusId,
        this.totOrderStatus,
        this.totalAmount,
        this.trackingNo,
        this.createdOn,
        this.productId,
        this.productName,
        this.productImage,
        this.categoryId,
        this.categoryName,
        this.productSkuId,
        this.quantity,
        this.amount,
        this.dealerOrderDetails});

  Data.fromJson(Map<String, dynamic> json) {
    dealerOrderId = json['dealer_order_id'];
    dealerId = json['dealer_id'];
    dealerName = json['dealer_name'];
    dealerPhoneNo = json['dealer_phone_no'];
    dealerEmail = json['dealer_email'];
    dealerAddress = json['dealer_address'];
    dealerCity = json['dealer_city'];
    dealerState = json['dealer_state'];
    dealerCountry = json['dealer_country'];
    distributorNote = json['distributor_note'];
    manufactureDeliveryNote = json['manufacture_delivery_note'];
    orderDate = json['order_date'];
    totOrderStatusId = json['tot_order_status_id'];
    totOrderStatus = json['tot_order_status'];
    totalAmount = json['total_amount'];
    trackingNo = json['tracking_no'];
    createdOn = json['created_on'];
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    productSkuId = json['product_sku_id'];
    quantity = json['quantity'];
    amount = json['amount'];
    if (json['dealerOrderDetails'] != null) {
      dealerOrderDetails = <DealerOrderDetails>[];
      json['dealerOrderDetails'].forEach((v) {
        dealerOrderDetails!.add(new DealerOrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dealer_order_id'] = this.dealerOrderId;
    data['dealer_id'] = this.dealerId;
    data['dealer_name'] = this.dealerName;
    data['dealer_phone_no'] = this.dealerPhoneNo;
    data['dealer_email'] = this.dealerEmail;
    data['dealer_address'] = this.dealerAddress;
    data['dealer_city'] = this.dealerCity;
    data['dealer_state'] = this.dealerState;
    data['dealer_country'] = this.dealerCountry;
    data['distributor_note'] = this.distributorNote;
    data['manufacture_delivery_note'] = this.manufactureDeliveryNote;
    data['order_date'] = this.orderDate;
    data['tot_order_status_id'] = this.totOrderStatusId;
    data['tot_order_status'] = this.totOrderStatus;
    data['total_amount'] = this.totalAmount;
    data['tracking_no'] = this.trackingNo;
    data['created_on'] = this.createdOn;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['product_sku_id'] = this.productSkuId;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
    if (this.dealerOrderDetails != null) {
      data['dealerOrderDetails'] =
          this.dealerOrderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DealerOrderDetails {
  String? productName;
  String? productSkuCode;
  String? productSKUID;
  String? productImage;
  String? categoryName;
  String? size;
  String? color;
  String? material;
  num? price;
  num? quantity;
  num? totalAmount;
  num? deliveredQuantity;
  Map<String, VariantOption>? productVariant;

  DealerOrderDetails({
    this.productName,
    this.productSkuCode,
    this.productSKUID,
    this.productImage,
    this.categoryName,
    this.size,
    this.color,
    this.material,
    this.price,
    this.quantity,
    this.totalAmount,
    this.productVariant,
    this.deliveredQuantity
  });

  DealerOrderDetails.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    productSkuCode = json['productSkuCode'];
    productSKUID = json['productSKU_ID'];
    productImage = json['productImage'];
    categoryName = json['categoryName'];
    size = json['size'];
    color = json['color'];
    material = json['material'];
    price = json['price'];
    quantity = json['quantity'];
    totalAmount = json['totalAmount'];
    deliveredQuantity = json['deliveredQuantity'];
    if (json['productVariant'] != null) {
      productVariant = {};
      json['productVariant'].forEach((key, value) {
        productVariant![key] = VariantOption.fromJson(value);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['productName'] = this.productName;
    data['productSkuCode'] = this.productSkuCode;
    data['productSKU_ID'] = this.productSKUID;
    data['productImage'] = this.productImage;
    data['categoryName'] = this.categoryName;
    data['size'] = this.size;
    data['color'] = this.color;
    data['material'] = this.material;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['totalAmount'] = this.totalAmount;
    data['deliveredQuantity'] = this.deliveredQuantity;
    if (this.productVariant != null) {
      data['productVariant'] = this.productVariant!.map(
            (key, value) => MapEntry(key, value.toJson()),
      );
    }
    return data;
  }
}
