import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/admin/stock/model/bulk_qty_update_by_category_model.dart';
import 'package:sales_app_redesign/features/admin/stock/model/get_distributor_stock.dart';
import 'package:sales_app_redesign/features/admin/stock/model/update_distributor_stock_model.dart';

class StockProvider extends ChangeNotifier {
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

  ///textEditingController
  TextEditingController bulkThresholdQtyTextEditingController= TextEditingController();
  TextEditingController thresholdQtyTextEditingController= TextEditingController();
  TextEditingController physicalQtyTextEditingController= TextEditingController();

  ///resetFnc
  void resetProductData() {
    _stockProductList.clear();
    _hasMore = true;
    _page = 1;
  }

  ///model
  GetDistributorStock? getDistributorStock;
  UpdateDistributorStockModel? updateDistributorStockModel;
  BulkUpdateQtyByCategoryModel? bulkUpdateQtyByCategoryModel;

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
      // _isFetching = true;
      String? distributorId = PreferenceHelper.getString(
        PreferenceHelper.USER_ID,
      );

      Map<String, dynamic> body = {
        "distributor_id": distributorId,
        "category_id": categoryId,
        "pageNo": page,
        "pageSize": 10,
        "appOs": "",
      };
      String endPoint = ApiConstants.getDistributorStock;
      var response = await callPostMethod(endPoint, body);
      getDistributorStock = GetDistributorStock.fromJson(json.decode(response));
      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Product By Category ${e}');
    }
    // _isFetching = false;
    // notifyListeners();
    return getDistributorStock?.data?.listItem ?? [];
  }

  ///updateDistributorStock
  ///
  apiCallUpdateDistributorStock({
      String?  distributorProductId,
    String? categoryId
    }) async {
    // _isAdding = true;

      try {
        Map<String, dynamic> body = {
          "distributorStockId": distributorProductId,
          "currentQuantity": int.parse(physicalQtyTextEditingController.text),
          "thresholdQuantity": int.parse(thresholdQtyTextEditingController.text),
          "appOs": "mobile"
        };
        String endPoint = ApiConstants.updateDistributorStock;
        var response = await callPostMethod(endPoint, body);
        updateDistributorStockModel = UpdateDistributorStockModel.fromJson(json.decode(response));
        if(updateDistributorStockModel?.isError == false && updateDistributorStockModel?.isValidationFailed == false){
          resetProductData();
          await fetchProductListForCategory(categoryId);
        }

        print('yooooooooooo $response');

      } catch (e) {
        print('catch at get Product By Category ${e}');
      }
      // _isAdding = false;
      // notifyListeners();
      // return getDistributorStock?.data?.listItem ?? [];
    }



  apiCallUpdateBulkQtyByCategoryId({
    String?  distributorProductId,
    String? categoryId
  }) async {
    _isAdding = true;

    try {
      String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);

      Map<String, dynamic> body = {
        "distributorId": userId,
        "categoryId": categoryId,
        "thresholdQuantity":  int.parse(bulkThresholdQtyTextEditingController.text),
        "appOs": ""
      };
      String endPoint = ApiConstants.updateByCategory;
      var response = await callPostMethod(endPoint, body);
      bulkUpdateQtyByCategoryModel = BulkUpdateQtyByCategoryModel.fromJson(json.decode(response));
      if(bulkUpdateQtyByCategoryModel?.isError == false && bulkUpdateQtyByCategoryModel?.isValidationFailed == false){
        resetProductData();
        await fetchProductListForCategory(categoryId);
      }

      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Product By Category ${e}');
    }
    _isAdding = false;
    notifyListeners();
    // return getDistributorStock?.data?.listItem ?? [];
  }

}
