import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/admin/category_ad/model/category_model_ad.dart';
import 'package:sales_app_redesign/features/admin/home/model/product_card_model.dart';
import 'package:sales_app_redesign/features/sales/category/model/all_category_model.dart';

class CategoryProviderAD extends ChangeNotifier{
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  CategoryModelAd? categoryModelAd;

  List<ProductItem> categoryList = [];

  final TextEditingController searchCtrl = TextEditingController();

  resetCategoryList(){
    categoryList.clear();
  }

  onSearch(String value) {
    print("value$value");

    categoryList
        .where((element) =>
        element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

     notifyListeners();
  }


  apiCallGetAllCategoryForDistributor() async {
    String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);

    print("kkkkkkkkkk1");

    _isFetching = true;
    // notifyListeners();
    try {
      Map<String,dynamic> body = {
        "distributor_id": userId,
        "appOs": ""
      };
      String endPoint = ApiConstants.getDistributorAssignedCategory;
      var response = await callPostMethod(endPoint,body);
      categoryModelAd = CategoryModelAd.fromJson(json.decode(response));
      if(categoryModelAd?.isError == false && categoryModelAd?.isValidationFailed == false){
        categoryModelAd?.data?.forEach((product) {
          categoryList.add(ProductItem(id: product.categoryId ?? "", name: product.categoryName ?? "", code: product.createdOn ?? "", imageUrl: product.categoryImage ?? ""));
        },);
      }
      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Category $e');
    }
    _isFetching = false;
    notifyListeners();
    // return allCategoryModel;
  }


}