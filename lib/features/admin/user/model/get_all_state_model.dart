class GetAllStateModel {
  bool? isError;
  bool? isValidationFailed;
  String? errorCode;
  String? message;
  List<StateData>? data;

  GetAllStateModel(
      {this.isError,
        this.isValidationFailed,
        this.errorCode,
        this.message,
        this.data});

  GetAllStateModel.fromJson(Map<String, dynamic> json) {
    isError = json['isError'];
    isValidationFailed = json['isValidationFailed'];
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StateData>[];
      json['data'].forEach((v) {
        data!.add(new StateData.fromJson(v));
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

class StateData {
  String? stateId;
  String? stateName;
  String? countryId;
  String? countryName;
  String? createdOn;

  StateData(
      {this.stateId,
        this.stateName,
        this.countryId,
        this.countryName,
        this.createdOn});

  StateData.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['created_on'] = this.createdOn;
    return data;
  }
}
