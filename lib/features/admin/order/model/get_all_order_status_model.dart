class GetAllOrderStatusModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  List<DropDownData>? dropDownData;

  GetAllOrderStatusModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.dropDownData});

  GetAllOrderStatusModel.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['data'] != null) {
      dropDownData = <DropDownData>[];
      json['data'].forEach((v) {
        dropDownData!.add(new DropDownData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isError'] = this.isError;
    data['isValidationFailed'] = this.isValidationFailed;
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.dropDownData != null) {
      data['data'] = this.dropDownData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDownData {
  String? orderStatusId;
  String? orderStatusType;
  String? totGroup;
  int? totKey;
  int? totSequence;
  String? totCode;
  String? createdOn;

  DropDownData(
      {this.orderStatusId,
        this.orderStatusType,
        this.totGroup,
        this.totKey,
        this.totSequence,
        this.totCode,
        this.createdOn});

  DropDownData.fromJson(Map<String, dynamic> json) {
    orderStatusId = json['order_status_id'];
    orderStatusType = json['order_status_type'];
    totGroup = json['tot_group'];
    totKey = json['tot_key'];
    totSequence = json['tot_sequence'];
    totCode = json['tot_code'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status_id'] = this.orderStatusId;
    data['order_status_type'] = this.orderStatusType;
    data['tot_group'] = this.totGroup;
    data['tot_key'] = this.totKey;
    data['tot_sequence'] = this.totSequence;
    data['tot_code'] = this.totCode;
    data['created_on'] = this.createdOn;
    return data;
  }
}
