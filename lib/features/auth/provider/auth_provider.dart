import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/features/auth/model/login_model.dart';
import 'package:sales_app_redesign/features/genral/change_password/model/change_password_model.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/preference_helper.dart';

class AuthProvider with ChangeNotifier {
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  LoginModel? loginModel;
  ChangePasswordModel? changePasswordModel;
  // ChangePasswordModel? changePasswordModel;
  // CommonResponseModel? commonResponseModel;

  Future<LoginModel?> apiCallLogin(
      {String? email, String? phoneNumber, String? password}) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> body = {"user_email": email, "user_password": password};
    try {
      String endPoint = ApiConstants.logIn;
      var response = await callPostMethod(endPoint, body);
      loginModel = LoginModel.fromJson(json.decode(response));
      print("response : ${response}");
    } catch (e) {
      print("inCatch ${loginModel?.message}");
      print("inCatchE ${e}");
    }
    _isLoading = false;
    notifyListeners();
    return loginModel;
  }


  apiCallChangePassword(
      {String? newPassword,Function()? onSuccess}) async {
    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isLoading = true;
    // notifyListeners();
    Map<String, dynamic> body = {
      "user_id": userId,
      "user_password": newPassword
    };
    try {
      String endPoint = ApiConstants.changePassword;
      var response = await callPostMethod(endPoint, body);
      print("yoooo ${response}");
      changePasswordModel = ChangePasswordModel.fromJson(json.decode(response));
      if(changePasswordModel?.isError == false && changePasswordModel?.isValidationFailed == false){
        if(onSuccess != null){
          onSuccess();
        }

      }
    } catch (e) {
      print("inCatch ${changePasswordModel?.message}");
      print("inCatchE ${e}");
    }
    _isLoading = false;
    notifyListeners();
    // return changePasswordModel;
  }

  // Future<ChangePasswordModel?> apiCallChangePassword(
  //     {String? newPassword}) async {
  //   var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
  //   _isLoading = true;
  //   notifyListeners();
  //   Map<String, dynamic> body = {
  //     "user_id": userId,
  //     "user_password": newPassword
  //   };
  //   try {
  //     String endPoint = ApiConstants.changePassword;
  //     var response = await callPostMethod(endPoint, body);
  //     print("yoooo ${response}");
  //     changePasswordModel = ChangePasswordModel.fromJson(json.decode(response));
  //   } catch (e) {
  //     print("inCatch ${changePasswordModel?.message}");
  //     print("inCatchE ${e}");
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  //   return changePasswordModel;
  // }

}
