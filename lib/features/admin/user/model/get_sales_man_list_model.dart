class GetSalesManListModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  List<SalesMenListData>? data;

  GetSalesManListModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetSalesManListModel.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SalesMenListData>[];
      json['data'].forEach((v) {
        data!.add(new SalesMenListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isError'] = this.isError;
    data['isValidationFailed'] = this.isValidationFailed;
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesMenListData {
  String? userId;
  String? userName;
  String? phoneNo;
  String? userEmail;
  bool? isAdmin;
  String? orgId;
  String? employeeTitle;
  String? totUserTypeId;
  String? totTypeUserGroup;
  String? totTypeUserName;
  String? countryId;
  String? stateId;
  String? cityId;
  String? address;
  String? pinCode;
  String? userProfilePic;
  String? userPassword;
  String? dealerId;
  List<String>? categoryIds;
  String? productId;
  String? totTypeMaterialId;
  String? bannerId;
  String? parentId;
  String? orgName;
  String? totOrgTypeId;
  String? createdOn;
  String? roleId;
  String? roleName;

  SalesMenListData(
      {this.userId,
        this.userName,
        this.phoneNo,
        this.userEmail,
        this.isAdmin,
        this.orgId,
        this.employeeTitle,
        this.totUserTypeId,
        this.totTypeUserGroup,
        this.totTypeUserName,
        this.countryId,
        this.stateId,
        this.cityId,
        this.address,
        this.pinCode,
        this.userProfilePic,
        this.userPassword,
        this.dealerId,
        this.categoryIds,
        this.productId,
        this.totTypeMaterialId,
        this.bannerId,
        this.parentId,
        this.orgName,
        this.totOrgTypeId,
        this.createdOn,
        this.roleId,
        this.roleName});

  SalesMenListData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    phoneNo = json['phone_no'];
    userEmail = json['user_email'];
    isAdmin = json['is_admin'];
    orgId = json['org_id'];
    employeeTitle = json['employee_title'];
    totUserTypeId = json['tot_user_type_id'];
    totTypeUserGroup = json['tot_type_user_group'];
    totTypeUserName = json['tot_type_user_name'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    address = json['address'];
    pinCode = json['pin_code'];
    userProfilePic = json['user_profile_pic'];
    userPassword = json['user_password'];
    dealerId = json['dealer_id'];
    categoryIds = json['category_ids'];
    productId = json['product_id'];
    totTypeMaterialId = json['tot_type_material_id'];
    bannerId = json['banner_id'];
    parentId = json['parent_id'];
    orgName = json['org_name'];
    totOrgTypeId = json['tot_org_type_id'];
    createdOn = json['created_on'];
    roleId = json['role_id'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['phone_no'] = this.phoneNo;
    data['user_email'] = this.userEmail;
    data['is_admin'] = this.isAdmin;
    data['org_id'] = this.orgId;
    data['employee_title'] = this.employeeTitle;
    data['tot_user_type_id'] = this.totUserTypeId;
    data['tot_type_user_group'] = this.totTypeUserGroup;
    data['tot_type_user_name'] = this.totTypeUserName;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['address'] = this.address;
    data['pin_code'] = this.pinCode;
    data['user_profile_pic'] = this.userProfilePic;
    data['user_password'] = this.userPassword;
    data['dealer_id'] = this.dealerId;
    data['category_ids'] = this.categoryIds;
    data['product_id'] = this.productId;
    data['tot_type_material_id'] = this.totTypeMaterialId;
    data['banner_id'] = this.bannerId;
    data['parent_id'] = this.parentId;
    data['org_name'] = this.orgName;
    data['tot_org_type_id'] = this.totOrgTypeId;
    data['created_on'] = this.createdOn;
    data['role_id'] = this.roleId;
    data['role_name'] = this.roleName;
    return data;
  }
}
