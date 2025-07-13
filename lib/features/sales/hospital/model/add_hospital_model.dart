class AddHospitalModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  Data? data;

  AddHospitalModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  AddHospitalModel.fromJson(Map<String, dynamic> json) {
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
  String? hospitalId;
  String? hospitalName;
  String? hospitalEmail;
  String? hospitalPhoneNo;
  String? hospitalAddress;
  String? countryId;
  String? stateId;
  String? cityId;
  String? salesmanId;

  Data(
      {this.hospitalId,
        this.hospitalName,
        this.hospitalEmail,
        this.hospitalPhoneNo,
        this.hospitalAddress,
        this.countryId,
        this.stateId,
        this.cityId,
        this.salesmanId
      });

  Data.fromJson(Map<String, dynamic> json) {
    hospitalId = json['hospitalId'];
    hospitalName = json['hospitalName'];
    hospitalEmail = json['hospitalEmail'];
    hospitalPhoneNo = json['hospitalPhoneNo'];
    hospitalAddress = json['hospitalAddress'];
    countryId = json['countryId'];
    stateId = json['stateId'];
    cityId = json['cityId'];
    salesmanId = json['salesmanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hospitalId'] = this.hospitalId;
    data['hospitalName'] = this.hospitalName;
    data['hospitalEmail'] = this.hospitalEmail;
    data['hospitalPhoneNo'] = this.hospitalPhoneNo;
    data['hospitalAddress'] = this.hospitalAddress;
    data['countryId'] = this.countryId;
    data['stateId'] = this.stateId;
    data['cityId'] = this.cityId;
    data['salesmanId'] = this.salesmanId;
    return data;
  }
}
