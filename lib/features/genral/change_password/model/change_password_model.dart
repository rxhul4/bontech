class ChangePasswordModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  ChangePasswordModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? userPassword;
  String? modifiedOn;
  String? modifiedBy;
  bool? isActive;

  Data(
      {this.userId,
        this.userPassword,
        this.modifiedOn,
        this.modifiedBy,
        this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userPassword = json['user_password'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_password'] = this.userPassword;
    data['modified_on'] = this.modifiedOn;
    data['modified_by'] = this.modifiedBy;
    data['is_active'] = this.isActive;
    return data;
  }
}
