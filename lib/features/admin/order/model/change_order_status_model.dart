class ChangeOrderStatusModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  ChangeOrderStatusModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  ChangeOrderStatusModel.fromJson(Map<String, dynamic> json) {
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
  String? salesOrderStatusId;
  String? orderId;
  String? userId;
  String? orderStatusId;

  Data(
      {this.salesOrderStatusId, this.orderId, this.userId, this.orderStatusId});

  Data.fromJson(Map<String, dynamic> json) {
    salesOrderStatusId = json['sales_order_status_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    orderStatusId = json['order_status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sales_order_status_id'] = this.salesOrderStatusId;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['order_status_id'] = this.orderStatusId;
    return data;
  }
}
