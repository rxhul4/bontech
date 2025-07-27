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

  GetAllSalesmanOrderByIdModel.fromJson(Map<String, dynamic> json) {
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
  String? salesmanOrderId;
  String? salesmanId;
  String? hospitalName;
  String? hospitalAddress;
  String? hospitalPhoneNo;
  String? salesmanName;
  String? orderDate;
  String? totOrderStatusId;
  String? totOrderStatus;
  int? totalAmount;
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

  Data.fromJson(Map<String, dynamic> json) {
    salesmanOrderId = json['salesman_order_id'];
    salesmanId = json['salesman_id'];
    hospitalName = json['hospital_name'];
    hospitalAddress = json['hospital_address'];
    hospitalPhoneNo = json['hospital_phone_no'];
    salesmanName = json['salesman_name'];
    orderDate = json['order_date'];
    totOrderStatusId = json['tot_order_status_id'];
    totOrderStatus = json['tot_order_status'];
    totalAmount = json['total_amount'];
    trackingNo = json['tracking_no'];
    createdOn = json['created_on'];
    if (json['salesOrderDetails'] != null) {
      salesOrderDetails = <SalesOrderProductList>[];
      json['salesOrderDetails'].forEach((v) {
        salesOrderDetails!.add(new SalesOrderProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesman_order_id'] = this.salesmanOrderId;
    data['salesman_id'] = this.salesmanId;
    data['hospital_name'] = this.hospitalName;
    data['hospital_address'] = this.hospitalAddress;
    data['hospital_phone_no'] = this.hospitalPhoneNo;
    data['salesman_name'] = this.salesmanName;
    data['order_date'] = this.orderDate;
    data['tot_order_status_id'] = this.totOrderStatusId;
    data['tot_order_status'] = this.totOrderStatus;
    data['total_amount'] = this.totalAmount;
    data['tracking_no'] = this.trackingNo;
    data['created_on'] = this.createdOn;
    if (this.salesOrderDetails != null) {
      data['salesOrderDetails'] =
          this.salesOrderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesOrderProductList {
  String? productId;
  String? productName;
  String? categoryId;
  String? categoryName;
  String? productSKUID;
  String? productImage;
  String? size;
  String? color;
  String? material;
  int? price;
  int? quantity;
  String? totOrderStatusId;
  String? totOrderStatus;
  int? subAmount;
  int? deliveredQuantity;

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
        this.deliveredQuantity});

  SalesOrderProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    productSKUID = json['productSKU_ID'];
    productImage = json['productImage'];
    size = json['size'];
    color = json['color'];
    material = json['material'];
    price = json['price'];
    quantity = json['quantity'];
    totOrderStatusId = json['tot_order_status_id'];
    totOrderStatus = json['tot_order_status'];
    subAmount = json['subAmount'];
    deliveredQuantity = json['deliveredQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['productSKU_ID'] = this.productSKUID;
    data['productImage'] = this.productImage;
    data['size'] = this.size;
    data['color'] = this.color;
    data['material'] = this.material;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['tot_order_status_id'] = this.totOrderStatusId;
    data['tot_order_status'] = this.totOrderStatus;
    data['subAmount'] = this.subAmount;
    data['deliveredQuantity'] = this.deliveredQuantity;
    return data;
  }
}
