import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/admin/dashboard_ad/dashboard_ad.dart';
import 'package:sales_app_redesign/features/admin/pending_order/model/pending_order_model.dart';
import 'package:sales_app_redesign/features/genral/cart/model/cart_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';

import '../../../../main.dart';
import '../../../sales/dashboard/dashboard.dart';

class PendingOrderProvider extends ChangeNotifier{
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

  int cartTotal = 0;
  int totalQty = 0;


  List<ProductData1> localPendingOrderList = [];

  //models
  PendingOrderResponse? pendingOrderResponse;
  CartModel? cartModel;

  TextEditingController qtyEditController = TextEditingController();

  //apiCall
  apiCallGetMyPendingOrders() async {
    localPendingOrderList.clear();
    _isFetching = true;

    var userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    try {
      Map<String, dynamic> body = {
        "userId": userId,
      };
      String endPoint = ApiConstants.getPendingProductsSummary;
      var response = await callPostMethod(endPoint, body);
      pendingOrderResponse = PendingOrderResponse.fromJson(
        json.decode(response),
      );
      if(pendingOrderResponse?.isError == false && pendingOrderResponse?.isValidationFailed == false){
        pendingOrderResponse?.pendingProductData.forEach((product) async {

          await addProductToLocalList(product);

        },);
      }
      print("reponse : $response");
    } catch (e) {
      print('catch at get pendingOrderResponse $e');
    }
    _isFetching = false;
    notifyListeners();
  }


  removeProductFromLocalList(index){
    localPendingOrderList.removeAt(index);
    notifyListeners();

  }

  Future addProductToLocalList(ProductData1 product)async{
     localPendingOrderList.add(product);
    for (var localProductData in localPendingOrderList) {
      updateProductListQty(localProductData.pendingQuantity, localProductData);
      print("productQTy${localProductData.pendingQuantity}");
    }


  }

  updateProductListQty(int qty, ProductData1 productData){
    productData.pendingQuantity = qty;
    notifyListeners();
  }

  void addToCartData({
    required BuildContext context,
    List<ProductData1>? productData,
  }) {
    try {
      // Retrieve existing cart data from preferences
      final String cartString =
          PreferenceHelper.getString(PreferenceHelper.CART_MODEL_LIST_AD) ?? '';

      cartModel = (cartString.isNotEmpty)
          ? CartModel.fromJson(jsonDecode(cartString))
          : CartModel();

      if (kDebugMode) {
        print(
          'Decoded Cart Data: ${cartModel?.productInfo?.map((e) => e.productId)}',
        );
      }

      if (productData == null || productData.isEmpty) {
        print("Product data not found.");
        return;
      }

      // Loop over all products to add/update
      for (final data in productData) {
        print("skuId: ${data.productVariantId}");

        final Product productVariant = Product(
          productVariantId: data.productVariantId,
          productId: data.productId,
          productName: data.productName,
          productCategoryName: data.categoryName,
          productQty: data.pendingQuantity ?? 0,
          productVariant: data.productVariant,
          price: data.productPrice,
          image: data.imagePath,
        );

        cartModel?.productInfo ??= [];

        final int existingIndex = cartModel!.productInfo!
            .indexWhere((item) => item.productVariantId == productVariant.productVariantId);

        if (existingIndex != -1) {
          // Already exists → update qty
          final existingItem = cartModel!.productInfo![existingIndex];
          final int currentQty = existingItem.productQty ?? 0;
          final int addedQty = productVariant.productQty ?? 0;
          existingItem.productQty = currentQty + addedQty;
        } else {
          // Not found → add new
          cartModel!.productInfo!.add(productVariant);
        }
      }

      // Save updated cart data
      final encodedCart = cartModel?.toJson();
      final cartStringUpdated = convertJsonToString(encodedCart);
      PreferenceHelper.setString(
          PreferenceHelper.CART_MODEL_LIST_AD, cartStringUpdated);

      updateCartItemCount();
      cartItemCount = cartModel?.productInfo?.length ?? 0;
      notifyListeners();

      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Your products have been added to Cart",
      );

      if (kDebugMode) {
        print('Updated Cart Data: $encodedCart');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error in addToCartData: $e\n$stackTrace");
      }
    }
  }



  Future<void> updateCartItemCount() async {
    PreferenceHelper.setInt(
      PreferenceHelper.cartItem,
      cartModel?.productInfo?.length ?? 0,
    );
    cartItemCount = PreferenceHelper.getInt(PreferenceHelper.cartItem) ?? 0 ;
    // notifyListeners();
  }










}