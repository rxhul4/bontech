import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_all_order_status_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_all_sales_man_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';

class SalesOrderProvider extends ChangeNotifier {
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool _hasMore = true;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  bool get hasMore => _hasMore;

  int _page = 1;

  GetAllSalesmanOrderModel? getAllSalesmanOrderModel;
  GetAllSalesmanOrderByIdModel? getAllSalesmanOrderByIdModel;
  GetAllOrderStatusModel? getAllOrderStatusModel;

  List<SaleOrderListItem> _activeSalesOrderList = [];
  List<SaleOrderListItem> _completeSalesOrderList = [];

  List<SaleOrderListItem> get activeSalesOrderList => _activeSalesOrderList;

  List<SaleOrderListItem> get completeSalesOrderList => _completeSalesOrderList;

  TextEditingController qtyController = TextEditingController();

  void resetOrderControllers() {
    _activeSalesOrderList.clear();
    _completeSalesOrderList.clear();
    _isLoading = false;
    _hasMore = true;
    _page = 1;
    notifyListeners();
  }

  fetchOrderHistory(bool? isActive) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    try {
      List<SaleOrderListItem> newOrderList = await apiCallGetAllSalesmanOrder(
        pageNo: _page,
        isActive: isActive,
      );

      if (newOrderList.isEmpty) {
        _hasMore = false;
      } else {
        if (newOrderList.length < 10) {
          _hasMore = false;
        }
        isActive == true
            ? _activeSalesOrderList.addAll(newOrderList)
            : _completeSalesOrderList.addAll(newOrderList);
        _page++;
      }
    } catch (e) {
      print("something went wrong");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<List<SaleOrderListItem>> apiCallGetAllSalesmanOrder({
    int? pageNo,
    bool? isActive,
  }) async {
    var dealerId = PreferenceHelper.getString(PreferenceHelper.PARENT_ID);

    try {
      Map<String, dynamic> body = {
        "pageNo": pageNo,
        "pageSize": 10,
        "isActive": isActive,
        "dealer_id": dealerId,
        "appOs": "mobile",
      };
      String endPoint = ApiConstants.getAllSalesmanOrders;
      var response = await callPostMethod(endPoint, body);
      getAllSalesmanOrderModel = GetAllSalesmanOrderModel.fromJson(
        json.decode(response),
      );
      if (getAllSalesmanOrderModel?.isError == false &&
          getAllSalesmanOrderModel?.isValidationFailed == false) {}
      print("reponse : $response");
    } catch (e) {
      print('catch at get getAllSalesmanOrderModel $e');
    }
    return getAllSalesmanOrderModel?.data?.listItem ?? [];
  }

  apiCallAllSalesManOrderDetailById(String? salesOrderId) async {
    print("$salesOrderId");
    _isFetching = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {"order_id": salesOrderId, "appOs": "mobile"};
      String endPoint = ApiConstants.getSalesmanOrderDetails;
      var response = await callPostMethod(endPoint, body);
      getAllSalesmanOrderByIdModel = GetAllSalesmanOrderByIdModel.fromJson(
        json.decode(response),
      );
      if (getAllSalesmanOrderByIdModel?.isError == false &&
          getAllSalesmanOrderByIdModel?.isValidationFailed == false) {
        await apiCallGetAllOrderStatus();
      }
      print("reponse : $response");
    } catch (e) {
      print('catch at get order details by id $e');
    }
    _isFetching = false;
    notifyListeners();
  }

  apiCallGetAllOrderStatus() async {
    // _isFetching = true;
    // notifyListeners();
    try {
      String endPoint = ApiConstants.getAllOrderStatus;
      var response = await callGetMethod(endPoint);
      getAllOrderStatusModel = GetAllOrderStatusModel.fromJson(
        json.decode(response),
      );
    } catch (e) {
      print('catch at GeneralProvider $e');
    }
    // _isFetching = false;
    // notifyListeners();/
    return getAllOrderStatusModel;
  }
}
