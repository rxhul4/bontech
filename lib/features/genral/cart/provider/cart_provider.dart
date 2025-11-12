import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/genral/cart/model/dealer_order_model.dart';
import 'package:sales_app_redesign/features/genral/cart/model/sales_order_model.dart';
import 'package:sales_app_redesign/features/genral/instruments/model/intrument_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart';

class CartProvider extends ChangeNotifier {
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  List<Map<String, dynamic>> orderDatas = [];
  List<Map<String, dynamic>> instrumentsReq = [];

  //textEditingController
  TextEditingController notesController = TextEditingController();

  //model

  AddOrderModelAd? addOrderModelAd;
  SalesOrderModel? salesOrderModel;

  //prepareCheckOutReq
  List<Map<String, dynamic>> prepareCheckOutReq(List<Product> productList) {
    orderDatas.clear();
    if (productList.isEmpty) {
      return [];
    }
    for (var product in productList) {
      orderDatas.add({
        "productId": product.productVariantId,
        "quantity": product.productQty,
      });
    }
    return orderDatas;
  }

  //prepareCheckOutReq
  List<Map<String, dynamic>> prepareInstrumentsCheckOutReq(List<InstrumentModel> instruments) {
    instrumentsReq.clear();
    if (instruments.isEmpty) {
      return [];
    }
    for (var data in instruments) {
      instrumentsReq.add({
        "itemCode": data.code,
        "itemDescription": data.description,
        "size": data.size,
        "quantity": data.quantity,
        "imageUrls": data.images
      });
    }
    return instrumentsReq;
  }


  //apiCallCheckOut
  apiCallAddOrderAD(List<Product>? productList,List<InstrumentModel>? instrumentList,Function()? callback) async {
    var userid = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isLoading = true;
    // notifyListeners();

    try {
      prepareCheckOutReq(productList ?? []);
      prepareInstrumentsCheckOutReq(instrumentList ?? []);
      Map<String, dynamic> body = {
        "userId": userid,
        "delivery_note": notesController.text,
        "orderDatas": orderDatas,
        "instruments" :instrumentsReq,
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
        if(callback != null){
          callback();
        }
        PreferenceHelper.remove(PreferenceHelper.CART_MODEL_LIST_AD);

      }
      print("response : ${response}");
    } catch (e) {
      print("inCatch ${addOrderModelAd?.message}");
      print("inCatchE ${e}");
    }
    _isLoading = false;
    notifyListeners();
  }

  apiCallAddOrder(
      {String? userId,List<Product>? productList,String? hospitalId,Function()? callback}) async {
    var userid = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isLoading = true;
    try {
      prepareCheckOutReq(productList ?? []);
    Map<String, dynamic> body ={
      "userId":userid,
      "hospitalId" : hospitalId,
      "orderDatas" : orderDatas
    };
    print("body $body");
      String endPoint = ApiConstants.addSalesOrder;
      var response = await callPostMethod(endPoint, body);
      salesOrderModel = SalesOrderModel.fromJson(json.decode(response));
      if(salesOrderModel?.isError ==false && salesOrderModel?.isValidationFailed ==false){
        if(callback != null){
          callback();
        }
        PreferenceHelper.remove(PreferenceHelper.CART_MODEL_LIST);

      }
      print("response : ${response}");
    } catch (e) {
      print("inCatch ${salesOrderModel?.message}");
      print("inCatchE ${e}");
    }
    _isLoading = false;
    notifyListeners();
    // return addSalesOrderModel;
  }


}
