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


  //models
  PendingOrderResponse? pendingOrderResponse;
  CartModel? cartModel;

  TextEditingController qtyEditController = TextEditingController();

  //apiCall
  apiCallGetMyPendingOrders() async {
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
        pendingOrderResponse?.pendingProductData.forEach((product) {
          updateProductListQty(product.pendingQuantity, product);
        },);
      }
      print("reponse : $response");
    } catch (e) {
      print('catch at get pendingOrderResponse $e');
    }
    _isFetching = false;
    notifyListeners();
  }

  updateProductListQty(int qty, ProductData1 productData){
    productData.pendingQuantity = qty;
    notifyListeners();
  }

  void addToCartData({required BuildContext context,ProductData1? productData}) {
    try {
      // Retrieve existing cart data from preferences
      final String cartString = PreferenceHelper.getString(PreferenceHelper.CART_MODEL_LIST_AD) ?? '';

      // Map<String, dynamic> jsonMap = jsonDecode(cartString);

      cartModel =
      (cartString != null && cartString.isNotEmpty)
          ? CartModel.fromJson(jsonDecode(cartString))
          : CartModel();

      if (kDebugMode) {
        print(
          'Decoded Cart Data: ${cartModel?.productInfo?.map((e) => e.productId)}',
        );
      }

      if (productData == null) {
        print("Product data not found.");
        return;
      }

      print("skuId: ${productData.productVariantId}");

      // Prepare the product variant to be added
      final Product productVariant = Product(
        productVariantId: productData.productVariantId,
        productId: productData.productId,
        productName: productData.productName,
        productCategoryName: productData.categoryName,
        productQty: productData.pendingQuantity ?? 0,
        productVariant: productData.productVariant,
        price: productData.productPrice,
        image: productData.imagePath,
      );

      // Add or update product in cart
      cartModel?.productInfo ??= [];
      final int existingIndex =
          cartModel?.productInfo?.indexWhere(
                (item) => item.productVariantId == productVariant.productVariantId,
          ) ??
              0;

      if (existingIndex >= 0) {
        final existingItem = cartModel?.productInfo?[existingIndex];
        final int currentQty = existingItem?.productQty ?? 1;
        final int addedQty = productVariant.productQty ?? 1;
        existingItem?.productQty = (currentQty + addedQty);
      } else {
        cartModel?.productInfo?.add(productVariant);
      }

      // Save updated cart data
      final encodedCart = cartModel?.toJson();
      final cartStringUpdated = convertJsonToString(encodedCart);
      updateCartItemCount();

      PreferenceHelper.setString(PreferenceHelper.CART_MODEL_LIST_AD, cartStringUpdated);
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Your Product has Added to Cart",
      );

      if (kDebugMode) {
        print('Updated Cart Data: $encodedCart');
      }
      cartItemCount = cartModel?.productInfo?.length ?? 0;
      notifyListeners();

      // updateCartItemCount(cart.listData?.length);
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