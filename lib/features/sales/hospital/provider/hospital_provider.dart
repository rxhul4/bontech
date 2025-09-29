import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/capitlize_string.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_city_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_country_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_state_model.dart';
import 'package:sales_app_redesign/features/sales/hospital/model/add_hospital_model.dart';
import 'package:sales_app_redesign/features/sales/hospital/model/common_response_model.dart';
import 'package:sales_app_redesign/features/sales/hospital/model/get_all_hospital.dart';
import 'package:sales_app_redesign/features/sales/hospital/model/get_hospital_by_id_model.dart';

class HospitalProvider extends ChangeNotifier{

  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;


  //model
  GetAllHospitalModel? getAllHospitalModel;
  GetHospitalByIdModel? getHospitalByIdModel;
  GetAllCountryModel? getAllCountryModel;
  GetAllStateModel? getAllStateModel;
  GetAllCityModel? getAllCityModel;
  AddHospitalModel? addHospitalModel;
  CommonResponseModel? commonResponseModel;


  //Variable
  GetAllHospitalData? selectedHospital;
  CountryData? selectedCountry;
  StateData? selectedState;
  CityData? selectedCity;

  //TextController
  TextEditingController hospitalNameController = TextEditingController();
  TextEditingController hospitalEmailController = TextEditingController();
  TextEditingController hospitalPhoneNoController = TextEditingController();
  TextEditingController hospitalAddressController = TextEditingController();

  ///Clear Fnc
  clearAllVariable() async {
    hospitalNameController.clear();
    hospitalEmailController.clear();
    hospitalPhoneNoController.clear();
    hospitalAddressController.clear();
    getAllCountryModel = GetAllCountryModel();
    getAllStateModel = GetAllStateModel();
    getAllCityModel = GetAllCityModel();
    selectedCountry = null;
    selectedState = null;
    selectedCity = null;
    // notifyListeners();
    await apiCallGetAllCountry();
  }

  fillValuesForEditFnc(GetHospitalByIdModel? getHospitalById){
    hospitalNameController.text = getHospitalById?.data?.hospitalName ?? '';
    hospitalEmailController.text =  getHospitalById?.data?.hospitalEmail ?? '';
    hospitalPhoneNoController.text = getHospitalById?.data?.hospitalPhoneNo ?? '';
    hospitalAddressController.text = getHospitalById?.data?.hospitalAddress ?? '';
    apiCallGetAllCountry(isEdit: true,hospitalById: getHospitalById);
    // imageUrl = getUserByIdModel?.data?.userProfilePic ?? "";
  }

  ///dropdownFnc
  changeCountry(CountryData? value) async {
    selectedCountry = value;
    selectedState = null;
    selectedCity = null;
    getAllStateModel = GetAllStateModel();
    getAllCityModel = GetAllCityModel();

    notifyListeners();
    print("SelectedCountry${selectedCountry?.countryName}");
    await apiCallGetAllState(countryId: selectedCountry?.countryId ?? "");
  }

  changeState(StateData? value) async {
    selectedState = value;
    selectedCity = null;
    getAllCityModel = GetAllCityModel();

    notifyListeners();
    print("SelectedState${selectedState?.stateName}");
    await apiCallGetAllCity(stateId: selectedState?.stateId ?? "");
  }

  changeCity(CityData? value) async {
    selectedCity = value;
    notifyListeners();
    print("selectedCity${selectedCity?.cityName}");
    // await apiCallGetAllState(selectedCity?.stateId ?? "");
  }

  onChangeHospital(GetAllHospitalData? hospitalData){
    selectedHospital = hospitalData;
    notifyListeners();
  }

  ///Validations
  checkValidationForAddUser(BuildContext context,Function()? onSuccess) {
    if (hospitalNameController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Name",
        giveColor: AppColors.colorSecondary
      );
    } else if (hospitalEmailController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Email",
          giveColor: AppColors.colorSecondary
          );
    } else if (!StringCasingExtension.validateEmail(
        hospitalEmailController.text)) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Valid Email Address",
          giveColor: AppColors.colorSecondary
          );
    } else if (hospitalPhoneNoController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Phone Number",giveColor: AppColors.colorSecondary

          );
    } else if (hospitalAddressController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Address",
          giveColor: AppColors.colorSecondary
          );
    } else if (selectedCountry == null ) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Select Hospital Country",
          giveColor: AppColors.colorSecondary
          );
    } else if (selectedState == null ) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Select Hospital State",
          giveColor: AppColors.colorSecondary
        );
    } else if (selectedCity == null) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Select Hospital City",
          giveColor: AppColors.colorSecondary
      );
    } else {
      //callApi
      apiCallAddHospital(onSuccess);

    }
  }
  checkValidationForEditUser(BuildContext context,Function()? onSuccess,String? hospitalId) {
    if (hospitalNameController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Name",
      );
    } else if (hospitalEmailController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Email",
          );
    } else if (!StringCasingExtension.validateEmail(
        hospitalEmailController.text)) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Valid Email Address",
          );
    } else if (hospitalPhoneNoController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Phone Number",
          );
    } else if (hospitalAddressController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Hospital Address",
          );
    } else if (selectedCountry == null ) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Select Hospital Country",
          );
    } else if (selectedState == null ) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Select Hospital State",
        );
    } else if (selectedCity == null) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Select Hospital City",
      );
    } else {
      //callApi
      apiCallUpdateHospital(hospitalId: hospitalId,onSuccess: onSuccess);

    }
  }

  ///ApiCalls
  apiCallGetAllHospital({ bool? isFromSelectionPage}) async {
    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isFetching = true;
    // notifyListeners();
    try {
      String endPoint ="${ApiConstants.getAllHospital}?salesman_id=$userId";
      var response = await callGetMethod(endPoint);
      getAllHospitalModel = GetAllHospitalModel.fromJson(json.decode(response));
      if(getAllHospitalModel?.isError == false && getAllHospitalModel?.isValidationFailed == false){
        onChangeHospital(getAllHospitalModel?.data?.first);

      }
      print('response ${getAllHospitalModel?.toJson()}');
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isFetching = false;
    notifyListeners();
    // return getAllHospitalModel;
  }

  //add Hospital
  apiCallAddHospital(Function()? onSuccess) async {
    _isAdding = true;
    // notifyListeners();
    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    try {
      Map<String, dynamic> body = {
        "hospitalName": hospitalNameController.text,
        "hospitalEmail": hospitalEmailController.text,
        "hospitalPhoneNo": hospitalPhoneNoController.text,
        "hospitalAddress": hospitalAddressController.text,
        "countryId": selectedCountry?.countryId,
        "stateId": selectedState?.stateId,
        "cityId": selectedCity?.cityId,
        "salesmanId": userId
      };
      String endPoint = ApiConstants.addHospital;
      var response = await callPostMethod(endPoint, body);
      addHospitalModel = AddHospitalModel.fromJson(json.decode(response));
      if (addHospitalModel?.isError == false &&
          addHospitalModel?.isValidationFailed == false) {
        if (onSuccess != null) {
          onSuccess();
        }
      }
      print('response ${addHospitalModel?.toJson()}');
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isAdding = false;
    notifyListeners();
    // return addHospitalModel;
  }

  //getHospitalById
  apiCallGetHospitalByHospitalId({String? hospitalId}) async {
    _isFetching = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {
        "hospital_id":hospitalId
      };
      String endPoint = ApiConstants.getHospitalById;
      var response = await callPostMethod(endPoint, body);
      getHospitalByIdModel = GetHospitalByIdModel.fromJson(json.decode(response));
      if(getHospitalByIdModel?.isError  == false && getHospitalByIdModel?.isValidationFailed ==false){
        fillValuesForEditFnc(getHospitalByIdModel);
      }


    } catch (e) {
      print('catch at ProfileProvider ${e}');
    }
    _isFetching = false;
    notifyListeners();
    // return getHospitalByIdModel;
  }


  //update Hospital
  apiCallUpdateHospital({
  String? hospitalId, Function()? onSuccess,

  }) async {
    _isAdding = true;
    // notifyListeners();
    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    try {
      Map<String, dynamic> body = {
        "hospitalId": hospitalId,
        "hospitalName": hospitalNameController.text,
        "hospitalEmail": hospitalEmailController.text,
        "hospitalPhoneNo": hospitalPhoneNoController.text,
        "hospitalAddress": hospitalAddressController.text,
        "countryId": selectedCountry?.countryId,
        "stateId": selectedState?.stateId,
        "cityId": selectedCity?.cityId,
        "salesmanId": userId
      };
      String endPoint = ApiConstants.updateHospital;
      var response = await callPostMethod(endPoint, body);
      addHospitalModel = AddHospitalModel.fromJson(json.decode(response));
      print('response ${addHospitalModel?.toJson()}');
      if(addHospitalModel?.isError == false && addHospitalModel?.isValidationFailed == false){
        if(onSuccess != null){
          onSuccess();
        }
      }
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isAdding = false;
    notifyListeners();
    // return addHospitalModel;
  }


  //deleteHospital
 apiCallDeleteHospital({String? hospitalId}) async {
    _isFetching = true;
    notifyListeners();
    try {
      Map<String, dynamic> body = {
        "hospital_id":hospitalId
      };
      String endPoint = ApiConstants.deleteHospital;
      var response = await callPostMethod(endPoint, body);
      commonResponseModel = CommonResponseModel.fromJson(json.decode(response));
      if(commonResponseModel?.isError == false && commonResponseModel?.isValidationFailed == false){
       await apiCallGetAllHospital();
      }
      print('response ${commonResponseModel?.toJson()}');

    } catch (e) {
      print('catch at ProfileProvider ${e}');
    }
    _isFetching = false;
    notifyListeners();
    return commonResponseModel;
  }







  apiCallGetAllCountry({bool? isEdit,GetHospitalByIdModel? hospitalById}) async {
    _isLoading = true;
    // notifyListeners();
    try {
      String endPoint = ApiConstants.getAllCountry;
      var response = await callGetMethod(endPoint);
      getAllCountryModel = GetAllCountryModel.fromJson(json.decode(response));
      if (getAllCountryModel?.isError == false &&
          getAllCountryModel?.isValidationFailed == false) {
        if(isEdit == true){
          selectedCountry = getAllCountryModel?.data?.where((element) => element.countryId == hospitalById?.data?.countryId,).first;
          apiCallGetAllState(countryId: selectedCountry?.countryId ?? "",isEdit: true,hospitalById: hospitalById);
        }
      }
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isLoading = false;
    notifyListeners();
    // return getAllCountryModel;
  }

  //getAllState
  apiCallGetAllState({required String countryId, bool? isEdit, GetHospitalByIdModel? hospitalById}) async {
    _isLoading = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {"country_id": countryId};
      String endPoint = ApiConstants.getAllState;
      var response = await callPostMethod(endPoint, body);
      getAllStateModel = GetAllStateModel.fromJson(json.decode(response));
      if (getAllStateModel?.isError == false &&
          getAllStateModel?.isValidationFailed == false) {
        if(isEdit == true){
          selectedState = getAllStateModel?.data?.where((element) => element.stateId == hospitalById?.data?.stateId).first;
          apiCallGetAllCity(stateId: selectedState?.stateId ?? "",isEdit: true,hospitalById: hospitalById);
        }
        // if(selectedState != null){
        //   apiCallGetAllCity(selectedState?.stateId?? "");
        // }
      }
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isLoading = false;
    notifyListeners();
    // return getAllStateModel;
  }

  //GetAllCity
  apiCallGetAllCity({required String stateId, bool? isEdit, GetHospitalByIdModel? hospitalById})async {
    _isLoading = true;
    try {
      Map<String, dynamic> body = {"state_id": stateId};
      String endPoint = ApiConstants.getAllCity;
      var response = await callPostMethod(endPoint, body);
      getAllCityModel = GetAllCityModel.fromJson(json.decode(response));
      if(getAllCityModel?.isError == false && getAllCityModel?.isValidationFailed == false){
        if(isEdit == true){
          selectedCity  = getAllCityModel?.data?.where((element) => element.cityId == hospitalById?.data?.cityId,).first;
        }
      }
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isLoading = false;
    notifyListeners();
  }




}