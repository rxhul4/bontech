class GetAllCountryModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  List<CountryData>? data;

  GetAllCountryModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetAllCountryModel.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CountryData>[];
      json['data'].forEach((v) {
        data!.add(new CountryData.fromJson(v));
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

class CountryData {
  String? countryId;
  String? countryName;
  String? twoDigitCode;
  String? threeDigitCode;
  String? phoneCode;
  String? createdOn;

  CountryData(
      {this.countryId,
        this.countryName,
        this.twoDigitCode,
        this.threeDigitCode,
        this.phoneCode,
        this.createdOn});

  CountryData.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
    twoDigitCode = json['two_digit_code'];
    threeDigitCode = json['three_digit_code'];
    phoneCode = json['phone_code'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['two_digit_code'] = this.twoDigitCode;
    data['three_digit_code'] = this.threeDigitCode;
    data['phone_code'] = this.phoneCode;
    data['created_on'] = this.createdOn;
    return data;
  }
}
