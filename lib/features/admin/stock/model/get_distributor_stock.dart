class GetDistributorStock {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  GetDistributorStock(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetDistributorStock.fromJson(Map<String, dynamic> json) {
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
  List<StockList>? listItem;

  Data({this.pageSize, this.pageNo, this.recordCount, this.listItem});

  Data.fromJson(Map<String, dynamic> json) {
    pageSize = json['pageSize'];
    pageNo = json['pageNo'];
    recordCount = json['recordCount'];
    if (json['listItem'] != null) {
      listItem = <StockList>[];
      json['listItem'].forEach((v) {
        listItem!.add(new StockList.fromJson(v));
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

class StockList {
  String? distributorStockId;
  String? productId;
  String? productSkuId;
  String? productName;
  String? productSkuCode;
  int? thresholdQuantity;
  int? currentQuantity;
  int? onHoldQuantity;
  int? incomingQuantity;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;

  StockList(
      {this.distributorStockId,
        this.productId,
        this.productSkuId,
        this.productName,
        this.productSkuCode,
        this.thresholdQuantity,
        this.currentQuantity,
        this.onHoldQuantity,
        this.incomingQuantity,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy});

  StockList.fromJson(Map<String, dynamic> json) {
    distributorStockId = json['distributorStockId'];
    productId = json['productId'];
    productSkuId = json['productSkuId'];
    productName = json['productName'];
    productSkuCode = json['productSkuCode'];
    thresholdQuantity = json['thresholdQuantity'];
    currentQuantity = json['currentQuantity'];
    onHoldQuantity = json['onHoldQuantity'];
    incomingQuantity = json['incomingQuantity'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributorStockId'] = this.distributorStockId;
    data['productId'] = this.productId;
    data['productSkuId'] = this.productSkuId;
    data['productName'] = this.productName;
    data['productSkuCode'] = this.productSkuCode;
    data['thresholdQuantity'] = this.thresholdQuantity;
    data['currentQuantity'] = this.currentQuantity;
    data['onHoldQuantity'] = this.onHoldQuantity;
    data['incomingQuantity'] = this.incomingQuantity;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['modifiedOn'] = this.modifiedOn;
    data['modifiedBy'] = this.modifiedBy;
    return data;
  }
}
