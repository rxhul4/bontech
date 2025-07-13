class AddUserModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  AddUserModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  AddUserModel.fromJson(Map<String, dynamic> json) {
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
  String? userName;
  String? phoneNo;
  String? userEmail;
  String? orgId;
  String? totUserTypeId;
  String? totTypeUserGroup;
  String? totTypeUserName;
  String? countryId;
  String? countryName;
  String? stateName;
  String? cityName;
  String? stateId;
  String? cityId;
  String? address;
  String? pinCode;
  String? userProfilePic;
  String? userPassword;
  String? parentId;
  String? orgName;
  String? totOrgTypeId;
  String? roleId;
  String? roleName;

  Data(
      {this.userId,
        this.userName,
        this.phoneNo,
        this.userEmail,
        this.orgId,
        this.totUserTypeId,
        this.totTypeUserGroup,
        this.totTypeUserName,
        this.countryId,
        this.countryName,
        this.stateName,
        this.cityName,
        this.stateId,
        this.cityId,
        this.address,
        this.pinCode,
        this.userProfilePic,
        this.userPassword,
        this.parentId,
        this.orgName,
        this.totOrgTypeId,
        this.roleId,
        this.roleName});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    phoneNo = json['phone_no'];
    userEmail = json['user_email'];
    orgId = json['org_id'];
    totUserTypeId = json['tot_user_type_id'];
    totTypeUserGroup = json['tot_type_user_group'];
    totTypeUserName = json['tot_type_user_name'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    address = json['address'];
    pinCode = json['pin_code'];
    userProfilePic = json['user_profile_pic'];
    userPassword = json['user_password'];
    parentId = json['parent_id'];
    orgName = json['org_name'];
    totOrgTypeId = json['tot_org_type_id'];
    roleId = json['role_id'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['phone_no'] = this.phoneNo;
    data['user_email'] = this.userEmail;
    data['org_id'] = this.orgId;
    data['tot_user_type_id'] = this.totUserTypeId;
    data['tot_type_user_group'] = this.totTypeUserGroup;
    data['tot_type_user_name'] = this.totTypeUserName;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['state_name'] = this.stateName;
    data['city_name'] = this.cityName;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['address'] = this.address;
    data['pin_code'] = this.pinCode;
    data['user_profile_pic'] = this.userProfilePic;
    data['user_password'] = this.userPassword;
    data['parent_id'] = this.parentId;
    data['org_name'] = this.orgName;
    data['tot_org_type_id'] = this.totOrgTypeId;
    data['role_id'] = this.roleId;
    data['role_name'] = this.roleName;
    return data;
  }
}
