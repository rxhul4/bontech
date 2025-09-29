import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/genral/home/model/product_card_model.dart';
import 'package:sales_app_redesign/features/sales/category/model/all_category_model.dart';

class CategoryProvider extends ChangeNotifier{
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  CategoryModel? categoryModel;

  final TextEditingController searchCtrl = TextEditingController();
  List<ProductItem> categoryList = [];


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


  apiCallGetAllCategoryForSalesMan() async {
    String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    String? parentId = PreferenceHelper.getString(PreferenceHelper.PARENT_ID);
    String? userTypeId = PreferenceHelper.getString(PreferenceHelper.USER_TYPE_ID);

    print("kkkkkkkkkk1");

    _isFetching = true;
    // notifyListeners();
    try {
      Map<String,dynamic> body = {
        "user_id": userId,
        "parent_id": parentId,
        "tot_user_type_id": userTypeId,
        "appOs": ""
      };
      String endPoint = ApiConstants.getAssignedCategory;
      var response = await callPostMethod(endPoint,body);
      categoryModel = CategoryModel.fromJson(json.decode(response));
      if(categoryModel?.isError == false && categoryModel?.isValidationFailed == false){
        categoryModel?.data?.forEach((product) {
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