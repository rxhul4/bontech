class GetAllHospitalModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  List<GetAllHospitalData>? data;

  GetAllHospitalModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetAllHospitalModel.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetAllHospitalData>[];
      json['data'].forEach((v) {
        data!.add(new GetAllHospitalData.fromJson(v));
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

class GetAllHospitalData {
  String? hospitalId;
  String? hospitalName;
  String? hospitalEmail;
  String? hospitalPhoneNo;
  String? hospitalAddress;
  String? countryId;
  String? stateId;
  String? cityId;

  GetAllHospitalData(
      {this.hospitalId,
        this.hospitalName,
        this.hospitalEmail,
        this.hospitalPhoneNo,
        this.hospitalAddress,
        this.countryId,
        this.stateId,
        this.cityId});

  GetAllHospitalData.fromJson(Map<String, dynamic> json) {
    hospitalId = json['hospitalId'];
    hospitalName = json['hospitalName'];
    hospitalEmail = json['hospitalEmail'];
    hospitalPhoneNo = json['hospitalPhoneNo'];
    hospitalAddress = json['hospitalAddress'];
    countryId = json['countryId'];
    stateId = json['stateId'];
    cityId = json['cityId'];
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
    return data;
  }
}
