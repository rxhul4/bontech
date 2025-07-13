class LoginModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  LoginModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? parentId;
  String? userEmail;
  String? userName;
  String? phoneNo;
  String? totUserTypeId;
  String? totUserTypeName;
  String? token;
  String? userProfilePic;
  Organization? organization;

  Data(
      {this.userId,
        this.parentId,
        this.userEmail,
        this.userName,
        this.phoneNo,
        this.totUserTypeId,
        this.totUserTypeName,
        this.token,
        this.userProfilePic,
        this.organization});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    parentId = json['parent_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    phoneNo = json['phone_no'];
    totUserTypeId = json['tot_user_type_id'];
    totUserTypeName = json['tot_user_type_name'];
    token = json['token'];
    userProfilePic = json['user_profile_pic'];
    organization = json['organization'] != null
        ? new Organization.fromJson(json['organization'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['parent_id'] = this.parentId;
    data['user_email'] = this.userEmail;
    data['user_name'] = this.userName;
    data['phone_no'] = this.phoneNo;
    data['tot_user_type_id'] = this.totUserTypeId;
    data['tot_user_type_name'] = this.totUserTypeName;
    data['token'] = this.token;
    data['user_profile_pic'] = this.userProfilePic;
    if (this.organization != null) {
      data['organization'] = this.organization!.toJson();
    }
    return data;
  }
}

class Organization {
  String? orgId;
  String? orgName;
  String? totOrgTypeId;

  Organization({this.orgId, this.orgName, this.totOrgTypeId});

  Organization.fromJson(Map<String, dynamic> json) {
    orgId = json['org_id'];
    orgName = json['org_name'];
    totOrgTypeId = json['tot_org_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['org_id'] = this.orgId;
    data['org_name'] = this.orgName;
    data['tot_org_type_id'] = this.totOrgTypeId;
    return data;
  }
}
