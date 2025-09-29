import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/genral/home/model/product_card_model.dart';
import 'package:sales_app_redesign/features/genral/search/model/search_model.dart';

class SearchProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  SearchModel? searchModel;

  TextEditingController searchController = TextEditingController();


  List<ProductItem> filteredProducts = [];

  clearListAndSearchModel(){
    searchController.clear();
    filteredProducts.clear();
    notifyListeners();
  }



  apiCallSearch({String? categoryId}) async {
    filteredProducts.clear();
    _isLoading = true;
    // String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);

    try {
      Map<String, dynamic> body = {
        "searchFilter": searchController.text.trim(),
        "pageNo": 1,
        "pageSize": 10,
        "sortBy": "Created On",
        "sortDir": "desc",
        "category_id": categoryId,
        "appOs": ""
      };
      String endPoint = ApiConstants.searchApi;
      var response = await callPostMethod(endPoint, body);
      searchModel = SearchModel.fromJson(json.decode(response));
      print('yooooooooooo $response');
      if(searchModel?.isError  == false && searchModel?.isValidationFailed == false){
        searchModel?.data?.listItem?.forEach((product) {
          filteredProducts.add(ProductItem(id: product.productId ?? "", name: product.productName ?? '', code: product.productCode ?? "", imageUrl: product.imagePath ?? ""));
        },);
      }

    } catch (e) {
      print("Catch At Search $e");
    }
    _isLoading = false;
    notifyListeners();
  }




}
