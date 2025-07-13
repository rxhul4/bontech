import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_app_redesign/core/capitlize_string.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/user/model/add_user_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/delete_user_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_city_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_country_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_state_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_sales_man_list_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_user_by_id_model.dart';

class UserProvider extends ChangeNotifier {
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  //TextController
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  //model
  GetSalesManListModel? getSalesManListModel;
  DeleteUserResModel? deleteUserResModel;
  GetAllCountryModel? getAllCountryModel;
  GetAllStateModel? getAllStateModel;
  GetAllCityModel? getAllCityModel;
  AddUserModel? addUserModel;
  GetUserByIdModel? getUserByIdModel;

  // screen variables
  CountryData? selectedCountry;
  StateData? selectedState;
  CityData? selectedCity;
  File? _image;
  File? get image => _image;
  var imageFull;
  String? imageUrl;
  String? image64;

  ///ClearFnc
  clearAllVariable() async {
    userNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    pinCodeController.clear();
    addressController.clear();
    getAllCountryModel = GetAllCountryModel();
    getAllStateModel = GetAllStateModel();
    getAllCityModel = GetAllCityModel();
    selectedCountry = null;
    selectedState = null;
    selectedCity = null;
    _image = null;
    imageFull = null;
    imageUrl = null;
    image64 = null;

    // notifyListeners();
    await apiCallGetAllCountry();
  }

  ///ImageFnc
  Future getImage() async {
    if (Platform.isIOS) {
      var status1 = await Permission.photos.request();
      if (status1.isDenied || status1.isPermanentlyDenied) {
        print(status1.isPermanentlyDenied);
        print(status1.isDenied);
        openAppSettings();
      } else {
        print(status1.isPermanentlyDenied);
        print(status1.isDenied);
        imageFull = await ImagePicker.platform.getImageFromSource(
          source: ImageSource.gallery,
        );
        if (imageFull?.path != null) {
          final bytes = await imageFull.readAsBytes();
          // setState(() {
          _image = File(imageFull?.path ?? '');
          image64 = "data:image/png;base64," + base64Encode(bytes);
          notifyListeners();
          // });
        }
      }
    } else {
      var status = await Permission.storage.request();
      var statusNew = await Permission.photos.request();
      if (status.isGranted || statusNew.isGranted) {
        imageFull = await ImagePicker.platform.getImageFromSource(
          source: ImageSource.gallery,
        );
        final bytes = await imageFull.readAsBytes();
        if (imageFull?.path != null) {
          _image = File(imageFull?.path ?? '');
          image64 = "data:image/png;base64," + base64Encode(bytes);
          notifyListeners();
        }
      } else {
        openAppSettings();
      }
    }
  }

  deleteImage() {
    _image = null;
    notifyListeners();
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



  ///Validations
  checkValidationAddUser(
    BuildContext context,
    Function()? onSuccess,
  ) {
    if (_image == null &&
        (imageUrl == null || imageUrl == "") &&
        (image64 == null || image64 == "")) {
      AppUtils.showSnackBarWithColor(context: context, message: "Select Image");
    } else if (userNameController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Full Name",
      );
    } else if (emailController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(context: context, message: "Enter Email");
    } else if (!StringCasingExtension.validateEmail(emailController.text)) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Valid Email Address",
      );
    } else if (phoneNumberController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Phone Number",
      );
    } else if (passwordController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Password",
      );
    } else if (pinCodeController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter PinCode",
      );
    } else if (addressController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Address",
      );
    } else if (selectedCountry == null) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Select Salesman Country",
      );
    } else if (selectedState == null) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Select Salesman State",
      );
    } else if (selectedCity == null) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Select Salesman City",
      );
    } else {
      apiCallAddUser(onSuccess);
    }
  }

  checkValidationEditUser(
    BuildContext context,
    String? userId,
    Function()? onSuccess,
  ) {
    if (_image == null &&
        (imageUrl == null || imageUrl == "") &&
        (image64 == null || image64 == "")) {
      AppUtils.showSnackBarWithColor(context: context, message: "Select Image");
    } else if (userNameController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Full Name",
      );
    } else if (emailController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(context: context, message: "Enter Email");
    } else if (!StringCasingExtension.validateEmail(emailController.text)) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Valid Email Address",
      );
    } else if (phoneNumberController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Phone Number",
      );
    } else if (pinCodeController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter PinCode",
      );
    } else if (addressController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Address",
      );
    } else if (selectedCountry == null) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Select Salesman Country",
      );
    } else if (selectedState == null) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Select Salesman State",
      );
    } else if (selectedCity == null) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Select Salesman City",
      );
    } else {
      // apiCallEditUser;
      apiCallUpdateUser(onSuccess,userId );
    }
  }

  ///fillValueForEdit
  fillValuesForEditFnc(GetUserByIdModel? getUserByIdModel){
    userNameController.text = getUserByIdModel?.data?.userName ?? '';
    emailController.text =  getUserByIdModel?.data?.userEmail ?? '';
    phoneNumberController.text = getUserByIdModel?.data?.phoneNo ?? '';
    passwordController.text = getUserByIdModel?.data?.userPassword ?? '';
    pinCodeController.text = getUserByIdModel?.data?.pinCode ?? '';
    addressController.text = getUserByIdModel?.data?.address ?? '';
    apiCallGetAllCountry(isEdit: true,userById: getUserByIdModel);
    imageUrl = getUserByIdModel?.data?.userProfilePic ?? "";
  }

  ///Api Section
  //get all
  apiCallGetSalesManList() async {
    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isFetching = true;
    // notifyListeners();
    try {
      String endPoint = "${ApiConstants.getSalesManList}?user_id=$userId";
      var response = await callGetMethod(endPoint);
      getSalesManListModel = GetSalesManListModel.fromJson(
        json.decode(response),
      );
      if (getSalesManListModel?.isError == false &&
          getSalesManListModel?.isValidationFailed == false) {
        getSalesManListModel?.data
            ?.where((element) => element.parentId == userId)
            .toList();
      }
      print('response ${getSalesManListModel?.toJson()}');
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isFetching = false;
    notifyListeners();
    // return getSalesManListModel;
  }

  //deleteUser
  apiCallDeleteUser(String userId) async {
    _isFetching = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {"user_id": userId};
      String endPoint = ApiConstants.deleteUser;
      var response = await callPostMethod(endPoint, body);
      deleteUserResModel = DeleteUserResModel.fromJson(json.decode(response));
      if (deleteUserResModel?.isError == false &&
          deleteUserResModel?.isValidationFailed == false) {
        apiCallGetSalesManList();
      }
    } catch (e) {
      print('catch at DeleteUser ${e}');
    }
    _isFetching = false;
    notifyListeners();
    // return del;
  }

  apiCallAddUser(Function()? onSuccess) async {
    // print("${imageFile?.path}");
    _isAdding = true;
    // notifyListeners();
    try {
      var parentUserId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
      var orgId = PreferenceHelper.getString(PreferenceHelper.ORG_ID);
      var orgName = PreferenceHelper.getString(PreferenceHelper.ORG_NAME);
      var tot_org_type_id = PreferenceHelper.getString(
        PreferenceHelper.ORG_TYPE_ID,
      );
      Map<String, dynamic> body = {
        "user_name": userNameController.text,
        "phone_no": phoneNumberController.text,
        "user_email": emailController.text,
        "org_id": orgId,
        "role_id": null,
        "tot_user_type_id": AppConstants.userTypeSalesMen,
        "parent_id": parentUserId,
        "address": addressController.text,
        "city_id": selectedCity?.cityId,
        "state_id": selectedState?.stateId,
        "country_id": selectedCountry?.countryId,
        "pin_code": pinCodeController.text,
        "user_profile_pic": image64,
        "user_password": passwordController.text,
        "org_name": orgName,
        "tot_org_type_id": tot_org_type_id,
      };
      String endPoint = ApiConstants.addUser;
      var response = await callPostMethod(endPoint, body);
      addUserModel = AddUserModel.fromJson(json.decode(response));
      if (addUserModel?.isError == false &&
          addUserModel?.isValidationFailed == false) {
        if (onSuccess != null) {
          onSuccess();
        }
      }
      print('response ${addUserModel?.toJson()}');
    } catch (e) {
      print("inCatch ${addUserModel?.isError}");
      print("inCatchE ${e}");
    }
    _isAdding = false;
    notifyListeners();
  }

  apiCallUpdateUser(Function()? onSuccess,String? userId) async {
    // print("${imageFile?.path}");
    _isAdding = true;
    // notifyListeners();
    try {
      var parentUserId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
      var ordId = PreferenceHelper.getString(PreferenceHelper.ORG_ID);
      var orgName = PreferenceHelper.getString(PreferenceHelper.ORG_NAME);
      var tot_org_type_id = PreferenceHelper.getString(PreferenceHelper.ORG_TYPE_ID);
      Map<String, dynamic> body = {
        "user_id": userId,
        "user_name": userNameController.text,
        "phone_no": phoneNumberController.text,
        "user_email": emailController.text,
        "org_id": ordId,
        "role_id": null,
        "tot_user_type_id": AppConstants.userTypeSalesMen,
        "parent_id": parentUserId,
        "address": addressController.text,
        "city_id": selectedCity?.cityId,
        "state_id": selectedState?.stateId,
        "country_id": selectedCountry?.countryId,
        "pin_code": pinCodeController.text,
        "user_profile_pic": image64 ?? imageUrl,
        "user_password": passwordController.text,
        "org_name": orgName,
        "tot_org_type_id": tot_org_type_id
      };
      String endPoint = ApiConstants.updateUser;
      var response = await callPostMethod(endPoint, body);
      addUserModel = AddUserModel.fromJson(json.decode(response));
      if (addUserModel?.isError == false &&
          addUserModel?.isValidationFailed == false) {
        if (onSuccess != null) {
          onSuccess();
        }
      }
      print('response ${addUserModel?.toJson()}');
    } catch (e) {
      print("inCatch ${addUserModel?.isError}");
      print("inCatchE ${e}");
    }
    _isAdding = false;
    notifyListeners();
    // return addUserModel;
  }

  apiCallGetUserById(String userId) async {
    _isFetching = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {"user_id": userId};
      String endPoint = ApiConstants.getUserById;
      var response = await callPostMethod(endPoint, body);
      getUserByIdModel = GetUserByIdModel.fromJson(json.decode(response));
      if(getUserByIdModel?.isError == false && getUserByIdModel?.isValidationFailed == false){
        fillValuesForEditFnc(getUserByIdModel);

      }
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isFetching = false;
    notifyListeners();
    return getUserByIdModel;
  }

  //getAllCountry
  apiCallGetAllCountry({bool? isEdit,GetUserByIdModel? userById}) async {
    _isLoading = true;
    // notifyListeners();
    try {
      String endPoint = ApiConstants.getAllCountry;
      var response = await callGetMethod(endPoint);
      getAllCountryModel = GetAllCountryModel.fromJson(json.decode(response));
      if (getAllCountryModel?.isError == false &&
          getAllCountryModel?.isValidationFailed == false) {
        if(isEdit == true){
          selectedCountry = getAllCountryModel?.data?.where((element) => element.countryId == userById?.data?.countryId,).first;
          apiCallGetAllState(countryId: selectedCountry?.countryId ?? "",isEdit: true,userById: userById);
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
  apiCallGetAllState({required String countryId, bool? isEdit, GetUserByIdModel? userById}) async {
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
          selectedState = getAllStateModel?.data?.where((element) => element.stateId == userById?.data?.stateId).first;
          apiCallGetAllCity(stateId: selectedState?.stateId ?? "",isEdit: true,userById: userById);
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
  apiCallGetAllCity({required String stateId, bool? isEdit, GetUserByIdModel? userById})async {
    _isLoading = true;
    try {
      Map<String, dynamic> body = {"state_id": stateId};
      String endPoint = ApiConstants.getAllCity;
      var response = await callPostMethod(endPoint, body);
      getAllCityModel = GetAllCityModel.fromJson(json.decode(response));
      if(getAllCityModel?.isError == false && getAllCityModel?.isValidationFailed == false){
        if(isEdit == true){
          selectedCity  = getAllCityModel?.data?.where((element) => element.cityId == userById?.data?.cityId,).first;
        }
      }
    } catch (e) {
      print('catch at UserProvider ${e}');
    }
    _isLoading = false;
    notifyListeners();
  }
}
