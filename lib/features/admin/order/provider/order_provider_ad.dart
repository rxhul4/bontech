import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/features/admin/order/model/change_order_status_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_all_order_status_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_all_sales_man_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_detail_order_by_id_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';
import 'package:sales_app_redesign/features/genral/cart/model/dealer_order_model.dart';

class OrderProviderAd extends ChangeNotifier {
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






  GetDistributorOrderModel? getDistributorOrderModel;
  GetDistributorOrderByIdModel? getDistributorOrderByIdModel;
  GetAllSalesmanOrderModel? getAllSalesmanOrderModel;
  GetAllSalesmanOrderByIdModel? getAllSalesmanOrderByIdModel;
  ChangeOrderStatusModel? changeOrderStatusModel;
  GetAllOrderStatusModel? getAllOrderStatusModel;
  AddOrderModelAd? addOrderModelAd;


  List<ListItem> _myOrderList = [];
  List<SaleOrderListItem> _salesOrderList = [];
  List<ListItem> _myPastOrderList = [];
  List<SaleOrderListItem> _pastSalesOrderList = [];

  int _page = 1;

  TextEditingController qtyController = TextEditingController();
  TextEditingController deliveryNotesController = TextEditingController();

  List<ListItem> get myOrderList => _myOrderList;
  List<ListItem> get myPastOrderList => _myPastOrderList;
  List<SaleOrderListItem> get salesOrderList => _salesOrderList;
  List<SaleOrderListItem> get pastSalesOrderList => _pastSalesOrderList;

  List<SalesOrderProductList> _salesOrderProductList = [];
  List<SalesOrderProductList> get salesOrderProductList => _salesOrderProductList;

  int _totalAmount = 0;
  int get totalAmount => _totalAmount;



  fetchMyOrderList(bool? isActive)async{

    if(_isLoading || !_hasMore)return;
    _isLoading = true;

    try{
      List<ListItem> newOrderList = await apiCallGetMyOrder(pageNo: _page,isActive: isActive);


      if(newOrderList.isEmpty){
        _hasMore = false;

      }else{
        if(newOrderList.length < 10){
          _hasMore = false;
        }
        isActive ==true ? _myOrderList.addAll(newOrderList) : _myPastOrderList.addAll(newOrderList);
        _page++;
      }
    }catch(e){
      print("something went wrong");
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }


  fetchSalesOrderList(bool? isActive)async{

    if(_isLoading || !_hasMore)return;
    _isLoading = true;

    try{
      List<SaleOrderListItem> newOrderList = await apiCallGetAllSalesmanOrder(pageNo: _page,isActive: isActive);

      if(newOrderList.isEmpty){
        _hasMore = false;


      }else{
        if(newOrderList.length < 10){
          _hasMore = false;
        }
        isActive == true ? _salesOrderList.addAll(newOrderList) : _pastSalesOrderList.addAll(newOrderList);
        _page++;
      }
    }catch(e){
      print("something went wrong");
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }




  void resetOrderControllers() {
    _myOrderList.clear();
    _myPastOrderList.clear();
    _pastSalesOrderList.clear();
    _salesOrderList.clear();
    _hasMore = true;
    _page =1;
  }


  String? findStatusId(String? status) {
    String? id;
    id =
        getAllOrderStatusModel?.dropDownData
            ?.firstWhere((element) => element.orderStatusType == status)
            .orderStatusId;

    return id;
  }

  Future<List<ListItem>> apiCallGetMyOrder({int? pageNo,bool? isActive}) async {
    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    try {
      Map<String, dynamic> body = {
        "pageNo": pageNo,
        "pageSize": 10,
        "userId": userId,
        "isActive" : isActive,
        "appOs": 'mobile',
      };
      String endPoint = ApiConstants.getAllMyOrders;
      var response = await callPostMethod(endPoint, body);
      getDistributorOrderModel = GetDistributorOrderModel.fromJson(
        json.decode(response),
      );
      print("reponse : $response");
    } catch (e) {
      print('catch at get getDistributorOrderModel $e');
    }
    return getDistributorOrderModel?.data?.listItem ?? [];
  }

  apiCallGetDistributorOrderDetailsById(String? distributorOrderId) async {
    _isFetching = true;
    try {
      Map<String, dynamic> body = {
        "distributorOrder_id": distributorOrderId,
        "appOs": "mobile",
      };
      String endPoint = ApiConstants.getMyOrderDetails;
      var response = await callPostMethod(endPoint, body);
      getDistributorOrderByIdModel = GetDistributorOrderByIdModel.fromJson(
        json.decode(response),
      );

      print("reponse : $response");
    } catch (e) {
      print('catch at get order details by id ${e}');
    }
    _isFetching = false;
    notifyListeners();
  }


  addProductListIntoLocal(List<SalesOrderProductList> salesOrderDetails){
    String jsonString = jsonEncode(
      salesOrderDetails.map((e) => e.toJson()).toList(),
    );
    print("String$jsonString");
    _totalAmount = calculateTotalAmount(salesOrderDetails);

    PreferenceHelper.setString("ProductList", jsonString);

    // Calculate and store total amount separately



  }

  int calculateTotalAmount(List<SalesOrderProductList> salesOrderDetails){
    int total = 0;
    for (var product in salesOrderDetails) {
      int price = product.price ?? 0;
      int qty = product.quantity ?? 0;
      total += price * qty;
      }
      print("totalAmount$total");
    return total;

  }


  Future<List<SalesOrderProductList>> getProductListFromLocal() async {
    String? jsonString = PreferenceHelper.getString("ProductList");

    print("JsonString$jsonString");

    if (jsonString == null || jsonString.isEmpty) return [];

    List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map((item) => SalesOrderProductList.fromJson(item))
        .toList();
  }

  Future<void> removeProductFromLocal(String productSkuId) async {
    String? jsonString = PreferenceHelper.getString("ProductList");

    if (jsonString == null || jsonString.isEmpty) return;

    List<dynamic> jsonList = jsonDecode(jsonString);

    // Convert to list of products
    List<SalesOrderProductList> productList =
    jsonList.map((item) => SalesOrderProductList.fromJson(item)).toList();

    // Remove the product with matching SKU ID
    productList.removeWhere((product) => product.productSKUID == productSkuId);

    // Convert back to JSON string
    String updatedJsonString = jsonEncode(productList);

    // Save back to local storage
     PreferenceHelper.setString("ProductList", updatedJsonString);
    _salesOrderProductList = await getProductListFromLocal();
    _totalAmount = calculateTotalAmount(_salesOrderProductList);
    notifyListeners();
  }

  updateProductFromLocal({String? productSkuId, int? newQuantity})async{
    String? jsonString = PreferenceHelper.getString("ProductList");
    if (jsonString == null || jsonString.isEmpty) return;

    List<dynamic> jsonList = jsonDecode(jsonString);

    List<SalesOrderProductList> productList =
    jsonList.map((item) => SalesOrderProductList.fromJson(item)).toList();


    for (var product in productList) {
      if (product.productSKUID == productSkuId) {
        product.quantity = newQuantity; // <- Make sure 'quantity' is the right field name
        break;
      }
    }

    // Save updated list
    String updatedJson = jsonEncode(productList);
    PreferenceHelper.setString("ProductList", updatedJson);
    _salesOrderProductList = await getProductListFromLocal();
    _totalAmount = calculateTotalAmount(_salesOrderProductList);
    notifyListeners();
  }

  refreshListFnc()async{
    _salesOrderProductList = await getProductListFromLocal();
    _totalAmount = calculateTotalAmount(_salesOrderProductList);
    print("SalesOrderList${_salesOrderProductList.length}");
    notifyListeners();
  }

  List<Map<String, dynamic>> prepareCheckOutReq(List<SalesOrderProductList> productList) {
    List<Map<String, dynamic>> orderDatas = [];

    print("ProductList$productList");

    if (productList.isEmpty) {
      return [];
    }

    for (var product in productList) {
      orderDatas.add({
        "productId": product.productSKUID,
        "quantity": product.quantity ?? 0,
      });
    }
    print("OrderData$orderDatas");
    return orderDatas;

  }


  apiCallAddOrderAD() async {
    var userid = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isLoading = true;
    // notifyListeners();

    try {

      List<Map<String, dynamic>> orderDatas = prepareCheckOutReq(_salesOrderProductList);
      print("orderData$orderDatas");
      Map<String, dynamic> body = {
        "userId": userid,
        "delivery_note": deliveryNotesController.text,
        "orderDatas": orderDatas,
        "appOs": "mobile",
      };
      if (kDebugMode) {
        print("body $body");
      }

      String endPoint = ApiConstants.addOrderAD;
      var response = await callPostMethod(endPoint, body);
      addOrderModelAd = AddOrderModelAd.fromJson(json.decode(response));
      if (addOrderModelAd?.isError == false &&
          addOrderModelAd?.isValidationFailed == false) {


      }
      print("response : ${response}");
    } catch (e) {
      print("inCatch ${addOrderModelAd?.message}");
      print("inCatchE ${e}");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<List<SaleOrderListItem>> apiCallGetAllSalesmanOrder({int? pageNo, bool? isActive}) async {
    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);

    try {
      Map<String, dynamic> body = {
        "pageNo": pageNo,
        "pageSize": 10,
        "isActive":  isActive,
        "dealer_id": userId,
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
        addProductListIntoLocal(getAllSalesmanOrderByIdModel?.data?.salesOrderDetails ?? []);

        _salesOrderProductList = await getProductListFromLocal();


      }
      print("reponse : $response");
    } catch (e) {
      print('catch at get order details by id $e');
    }
    _isFetching = false;
    notifyListeners();
  }

  //get all status

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

  //change status
  apiCallChangeOrderStatus({
    String? orderId,
    String? salesManId,
    String? orderStatusId,
    bool? isAcceptAndOrder,
  }) async {
    _isUploading = true;
    notifyListeners();
    try {
      Map<String, dynamic> body = {
        "order_id": orderId,
        "user_id": salesManId,
        "order_status_id": orderStatusId,
      };
      String endPoint = ApiConstants.changeOrderStatus;
      var response = await callPostMethod(endPoint, body);
      changeOrderStatusModel = ChangeOrderStatusModel.fromJson(
        json.decode(response),
      );
      if(changeOrderStatusModel?.isError == false && changeOrderStatusModel?.isValidationFailed ==false){
        if(isAcceptAndOrder == true ){
          await apiCallAddOrderAD();
        }
        await apiCallAllSalesManOrderDetailById(orderId);

      }
      print("reponse : $response");
    } catch (e) {
      print('catch at get Change OrderStatus ${e}');
    }
    _isUploading = false;
    notifyListeners();
    return changeOrderStatusModel;
  }
}
