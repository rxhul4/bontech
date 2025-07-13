import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/genral/search/model/search_model.dart';

class SearchProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  SearchModel? searchModel;

  apiCallSearch({String? search, String? categoryId}) async {
    _isLoading = true;
    String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);

    try {
      Map<String, dynamic> body = {
        "user_id": userId,
        "name": search,
        "category_id": categoryId,
        "appOs": "",
      };
      String endPoint = ApiConstants.searchApi;
      var response = await callPostMethod(endPoint, body);
      searchModel = SearchModel.fromJson(json.decode(response));
      print('yooooooooooo $response');

    } catch (e) {}
    _isLoading = false;
    notifyListeners();
  }


  void clearSearchResults() {
    searchModel = null;
    notifyListeners();
  }
}
