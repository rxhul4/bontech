import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/admin/stock/model/get_distributor_stock.dart';

class StockProvider extends ChangeNotifier{

  ///variables
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;
  bool _hasMore = true;
  int _page = 1;

  List<StockList> _stockProductList = [];

  List<StockList> get stockProductList => _stockProductList;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  bool get hasMore => _hasMore;


  ///resetFnc
  void resetProductData() {
    _stockProductList.clear();
    _hasMore = true;
    _page = 1;
  }



  ///model
  GetDistributorStock? getDistributorStock;


  ///paginationFnc
  fetchProductListForCategory(String? categoryId) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    try {
      List<StockList> newOrderList = await apiCallGetDistributorStock(
        categoryId: categoryId,
        page: _page,
      );

      if (newOrderList.isEmpty) {
        _hasMore = false;
      } else {
        if (newOrderList.length < 10) {
          _hasMore = false;
        }
        _stockProductList.addAll(newOrderList);
        // isActive ==true ? _myOrderList.addAll(newOrderList) : _myPastOrderList.addAll(newOrderList);
        _page++;
      }
    } catch (e) {
      print("something went wrong");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  ///apiCalls
  Future<List<StockList>> apiCallGetDistributorStock({
    String? categoryId,
    int? page,
  }) async {
    try {
    _isFetching = true;
    String? distributorId = PreferenceHelper.getString(PreferenceHelper.USER_ID);

      Map<String, dynamic> body = {
        "distributor_id": distributorId,
        "category_id": categoryId,
        "pageNo": page,
        "pageSize": 10,
        "appOs": ""
      };
      String endPoint = ApiConstants.getDistributorStock;
      var response = await callPostMethod(endPoint, body);
      getDistributorStock = GetDistributorStock.fromJson(
        json.decode(response),
      );
    _stockProductList.add(StockList(productName: "Product1",productSkuCode: "B01",currentQuantity: 05,incomingQuantity: 10,onHoldQuantity: 03,thresholdQuantity: 16));
      // if(getDistributorStock?.isError == false && getDistributorStock?.isValidationFailed == false){
      //
      // }
      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Product By Category ${e}');
    }
    _isFetching = false;
    notifyListeners();
    return getDistributorStock?.data?.listItem ?? [];
  }


}