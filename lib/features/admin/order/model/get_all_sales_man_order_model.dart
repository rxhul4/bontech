class GetAllSalesmanOrderModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  GetAllSalesmanOrderModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetAllSalesmanOrderModel.fromJson(Map<String, dynamic> json) {
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
  int? pageSize;
  int? pageNo;
  int? recordCount;
  List<SaleOrderListItem>? listItem;

  Data({this.pageSize, this.pageNo, this.recordCount, this.listItem});

  Data.fromJson(Map<String, dynamic> json) {
    pageSize = json['pageSize'];
    pageNo = json['pageNo'];
    recordCount = json['recordCount'];
    if (json['listItem'] != null) {
      listItem = <SaleOrderListItem>[];
      json['listItem'].forEach((v) {
        listItem!.add(new SaleOrderListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageSize'] = this.pageSize;
    data['pageNo'] = this.pageNo;
    data['recordCount'] = this.recordCount;
    if (this.listItem != null) {
      data['listItem'] = this.listItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaleOrderListItem {
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
  String? productId;
  String? productName;
  String? productImage;
  String? categoryId;
  String? categoryName;
  String? productSkuId;
  int? quantity;
  int? amount;
  List<SalesOrderDetails>? salesOrderDetails;

  SaleOrderListItem(
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
        this.productId,
        this.productName,
        this.productImage,
        this.categoryId,
        this.categoryName,
        this.productSkuId,
        this.quantity,
        this.amount,
        this.salesOrderDetails});

  SaleOrderListItem.fromJson(Map<String, dynamic> json) {
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
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    productSkuId = json['product_sku_id'];
    quantity = json['quantity'];
    amount = json['amount'];
    if (json['salesOrderDetails'] != null) {
      salesOrderDetails = <SalesOrderDetails>[];
      json['salesOrderDetails'].forEach((v) {
        salesOrderDetails!.add(new SalesOrderDetails.fromJson(v));
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
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['product_sku_id'] = this.productSkuId;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
    if (this.salesOrderDetails != null) {
      data['salesOrderDetails'] =
          this.salesOrderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesOrderDetails {
  String? productId;
  String? categoryId;
  String? productSKUID;
  String? productImage;
  String? size;
  String? color;
  String? material;
  int? price;
  int? quantity;
  String? totOrderStatusId;
  String? totOrderStatus;

  SalesOrderDetails(
      {this.productId,
        this.categoryId,
        this.productSKUID,
        this.productImage,
        this.size,
        this.color,
        this.material,
        this.price,
        this.quantity,
        this.totOrderStatusId,
        this.totOrderStatus});

  SalesOrderDetails.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    categoryId = json['categoryId'];
    productSKUID = json['productSKU_ID'];
    productImage = json['productImage'];
    size = json['size'];
    color = json['color'];
    material = json['material'];
    price = json['price'];
    quantity = json['quantity'];
    totOrderStatusId = json['tot_order_status_id'];
    totOrderStatus = json['tot_order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['categoryId'] = this.categoryId;
    data['productSKU_ID'] = this.productSKUID;
    data['productImage'] = this.productImage;
    data['size'] = this.size;
    data['color'] = this.color;
    data['material'] = this.material;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['tot_order_status_id'] = this.totOrderStatusId;
    data['tot_order_status'] = this.totOrderStatus;
    return data;
  }
}
