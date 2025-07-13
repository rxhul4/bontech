class GetAllCityModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  List<CityData>? data;

  GetAllCityModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetAllCityModel.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CityData>[];
      json['data'].forEach((v) {
        data!.add(new CityData.fromJson(v));
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

class CityData {
  String? cityId;
  String? cityName;
  String? stateId;
  String? stateName;
  String? countryId;
  String? countryName;
  String? createdOn;

  CityData(
      {this.cityId,
        this.cityName,
        this.stateId,
        this.stateName,
        this.countryId,
        this.countryName,
        this.createdOn});

  CityData.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityName = json['city_name'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['created_on'] = this.createdOn;
    return data;
  }
}
