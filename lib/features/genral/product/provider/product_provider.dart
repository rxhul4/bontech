import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart'
    show FlutterCarouselController;
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/admin/dashboard_ad/dashboard_ad.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';
import 'package:sales_app_redesign/features/genral/cart/model/cart_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart'
    as detail_res;
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_category.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_viewtype.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_sku_by_product_varient_id.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_sku_by_product_varient_id.dart'
    as response;

import '../../../../main.dart';
import '../../../sales/dashboard/dashboard.dart';
import '../model/get_product_by_productId_model.dart' as response;

class ProductProvider with ChangeNotifier {
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

  List<ListItem> _categoryProduct = [];
  List<ProductList> _totProduct = [];
  int _page = 1;

  List<ListItem> get categoryProduct => _categoryProduct;

  List<ProductList> get totProduct => _totProduct;

  ValueNotifier<List<String?>> productVariantsId = ValueNotifier<List<String?>>(
    [],
  );

  ValueNotifier<int?> selectedSizeIndex = ValueNotifier<int?>(null);
  ValueNotifier<int?> selectedColorIndex = ValueNotifier<int?>(null);
  ValueNotifier<int?> selectedMaterialIndex = ValueNotifier<int?>(null);
  ValueNotifier<int?> selectedSideIndex = ValueNotifier<int?>(null);

  TextEditingController qtyEditController = TextEditingController();

  GetProductByCategoryModel? getProductByCategoryModel;
  HomViewTypeByIdModel? homViewTypeByIdModel;
  ProductSkuByProductVariantId? productSkuByProductVariantId;
  SalesOrderProductList? salesOrderProductList;
  CartModel? cartModel;
  int cartTotal = 0;
  int totalQty = 0;

  ProductResponse? productResponse;
  response.Product? product;

  FlutterCarouselController carouselController = FlutterCarouselController();

  // List<AllVariants>? allVariantsList = [];

  // AllCategoryModel? allCategoryModel;
  // SalesProductsViewModel? salesProductsViewModel;

  // GetFavouriteProductsModel? getFavouriteProductsModel;
  // CommonResponseModel? commonResponseModel;.

  void resetProductData() {
    _categoryProduct.clear();
    _totProduct.clear();
    _hasMore = true;
    _page = 1;
  }

  fetchProductListForCategory(String? categoryId) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    try {
      List<ListItem> newOrderList = await apiCallGetProductByCategory(
        categoryId: categoryId,
        page: _page,
      );

      if (newOrderList.isEmpty) {
        _hasMore = false;
      } else {
        if (newOrderList.length < 10) {
          _hasMore = false;
        }
        _categoryProduct.addAll(newOrderList);
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

  fetchProductListUsingTotId(String? viewTypeId) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    try {
      List<ProductList> newOrderList = await apiCallGetHomeView(
        viewTypeId: viewTypeId,
        page: _page,
      );

      if (newOrderList.isEmpty) {
        _hasMore = false;
      } else {
        if (newOrderList.length < 10) {
          _hasMore = false;
        }
        _totProduct.addAll(newOrderList);
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

  getCartItemCount() {
    cartItemCount = PreferenceHelper.getInt(PreferenceHelper.cartItem) ?? 0;
    // notifyListeners();
  }

  Future<void> updateCartItemCount() async {
    PreferenceHelper.setInt(
      PreferenceHelper.cartItem,
      cartModel?.productInfo?.length ?? 0,
    );
    cartItemCount = PreferenceHelper.getInt(PreferenceHelper.cartItem) ?? 0;
  }

  //add product to Cart
  void addToCartData({required String cartKey, required BuildContext context}) {
    try {
      // Retrieve existing cart data from preferences
      final String cartString = PreferenceHelper.getString(cartKey) ?? '';

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

      if (product == null) {
        print("Product data not found.");
        return;
      }

      print("skuId: ${product?.productVariantId}");

      // Prepare the product variant to be added
      final Product productVariant = Product(
        productVariantId: product?.productVariantId,
        productId: product?.productId,
        productName: product?.productName,
        productCategoryName: product?.productCategoryName,
        productQty: product?.productQty ?? 0,
        productVariant: selectedVariants,
        price: product?.price,
        image: product?.image,
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
      PreferenceHelper.setString(cartKey, cartStringUpdated);
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

  CartModel? getCartList(String cartKey) {
    try {
      final String cartString = PreferenceHelper.getString(cartKey) ?? '';

      print("cartString$cartString");



      if (cartString.isEmpty) {
        return CartModel();
      }

      final Map<String, dynamic> cartJson = jsonDecode(cartString);
      cartModel = CartModel.fromJson(cartJson);
      calculateSubtotal();
      print("Cart${cartModel?.instruments?.length}");

      return cartModel;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error in getCartList: $e\n$stackTrace");
      }
      return CartModel();
    }
  }



  Future<void> removeProductFromCartListingScreen(
    int index,
    String cartKey,
  ) async {
    // prefCartProductList.removeAt(index);
    cartModel?.productInfo?.removeAt(index);
    // await updateCartItemCount();
    final encodedCart = cartModel?.toJson();
    final cartStringUpdated = convertJsonToString(encodedCart);
    PreferenceHelper.setString(cartKey, cartStringUpdated);
    updateCartItemCount();
    getCartList(cartKey);
    notifyListeners();
  }

  //Update Cart Product

  //getCartProduct

  //getItemCountOfCart

  // Remove Product from cart

  clearList() {
    cartModel?.productInfo?.clear();
    cartModel?.instruments?.clear();
    cartTotal = 0;
    totalQty = 0;
    cartModel = CartModel();
    updateCartItemCount();
    notifyListeners();
  }

  updateProductQty(int qty) async {
    product?.productQty = qty;
    notifyListeners();
  }

  updateProductQtyFromCartListingScreen(
    int index,
    int qty,
    String cartkey,
  ) async {
    cartModel?.productInfo?[index].productQty = qty;
    /* calculated price for cart screen */
    cartModel?.productInfo?[index].calculatedPrice =
        (product?.productQty ?? 0) *
        (cartModel?.productInfo?[index].price?.toInt() ?? 0);
    final encodedCart = cartModel?.toJson();
    final cartStringUpdated = convertJsonToString(encodedCart);
    PreferenceHelper.setString(cartkey, cartStringUpdated);
    // emit(ProductState().init());
    calculateSubtotal();
    getCartItemCount();
    calculateSubtotal();
    notifyListeners();
  }

  updateInstrumentQtyFromCartListingScreen(
      int index,
      int qty,
      String cartkey,
      ) async {
    cartModel?.instruments?[index].quantity = qty;
    final encodedCart = cartModel?.toJson();
    final cartStringUpdated = convertJsonToString(encodedCart);
    PreferenceHelper.setString(cartkey, cartStringUpdated);
    notifyListeners();
  }

  void calculateSubtotal() {
    cartTotal = 0;
    totalQty = 0;

    cartModel?.productInfo?.forEach((product) {
      final price = product.price;
      final qty = product.productQty;

      if (price != null && qty != null) {
        cartTotal += price.toInt() * qty;
        totalQty += qty;
      }
    });
  }

  Future<List<ListItem>> apiCallGetProductByCategory({
    String? categoryId,
    int? page,
  }) async {
    _isFetching = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {
        "category_id": categoryId,
        "pageNo": page,
        "pageSize": 10,
        "appOs": "",
      };
      String endPoint = ApiConstants.getProductByCategory;
      var response = await callPostMethod(endPoint, body);
      getProductByCategoryModel = GetProductByCategoryModel.fromJson(
        json.decode(response),
      );
      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Product By Category ${e}');
    }
    _isFetching = false;
    notifyListeners();
    return getProductByCategoryModel?.data?.listItem ?? [];
  }

  Future<List<ProductList>> apiCallGetHomeView({
    String? viewTypeId,
    int? page,
  }) async {
    try {
      String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
      _isFetching = true;
      Map<String, dynamic> body = {
        "user_id": userId,
        "view_type_id": viewTypeId,
        "pageNo": page,
        "pageSize": 10,
        "appOs": "",
      };
      String endPoint = ApiConstants.getHomeViewById;
      var response = await callPostMethod(endPoint, body);
      homViewTypeByIdModel = HomViewTypeByIdModel.fromJson(
        json.decode(response),
      );
      print('yooooooooooo $response');
    } catch (e) {
      print('catch at apiCallGetSalesProductsView ${e}');
    }
    _isFetching = false;
    notifyListeners();
    return homViewTypeByIdModel?.data?.listItem ?? [];
  }

  response.ProductVariant? selectedVariant;

  List<Map<String, dynamic>> selectedVariantList = [];

  Map<String, VariantOption> selectedVariants = {};

  Future<ProductResponse?> apiCallGetProductById(String? productId) async {
    print("kkkkkkkkkk1");

    _isFetching = true;
    selectedVariantList.clear();
    try {
      Map<String, dynamic> body = {"product_id": productId};
      String endPoint = ApiConstants.getProductSkuByProductId;
      var response1 = await callPostMethod(endPoint, body);
      productResponse = ProductResponse.fromJson(json.decode(response1));
      if (productResponse?.isError == false &&
          productResponse?.isValidationFailed == false) {
        product = productResponse?.data?.productInfo;
        product?.productQty = 1;
        final allVariants = product?.allVariants;
        final productVariantMap = product?.productVariant;

        if (allVariants != null && productVariantMap != null) {
          for (final variantAttr in allVariants) {
            final key = variantAttr.key;
            final options = variantAttr.value;

            if (key != null && productVariantMap.containsKey(key)) {
              final selectedVariant = productVariantMap[key];
              final matched = options?.firstWhere(
                (opt) => opt.id == selectedVariant?.id,
                orElse: () => VariantOption(),
              );

              if (matched?.id != null) {
                // Save the selected variant
                selectedVariants[key] = response.VariantOption(
                  id: matched?.id ?? "",
                  name: matched?.name,
                  attributeId: matched?.attributeId,
                );
              }
            }
          }
        }

        selectedVariantList = createListOfVariants(selectedVariants);

        print("ProductPrice${product?.price}");

        Future.delayed(Duration(milliseconds: 100), () {
          if ((productResponse?.data?.productInfo?.productImages ?? [])
              .isNotEmpty) {
            carouselController.jumpToPage(0);
          }
          notifyListeners();
        });
      }

      print('yooooooooooo $response1');
    } catch (e) {
      print('catch at get Product By Category ${e}');
    }
    _isFetching = false;
    notifyListeners();
    return productResponse;
  }

  List<Map<String, dynamic>> createListOfVariants(
    Map<String, VariantOption> selectedVariants,
  ) {
    List<Map<String, dynamic>> variantList =
        selectedVariants.entries.map((entry) {
          return {
            entry.key: {
              "id": entry.value.id,
              "name": entry.value.name,
              "attributeId": entry.value.attributeId,
            },
          };
        }).toList();
    print("ListOfObject${variantList.length}");
    return variantList;
  }

  void updateSelectedVariant(String key, VariantOption selectedOption) {
    selectedVariants[key] = selectedOption;

    selectedVariantList = createListOfVariants(selectedVariants);
    print("ListOfObject: ${jsonEncode(selectedVariantList)}");

    //apiCallToChangeSku
    apiCallGetProductSkuIdByProductVariants();

    notifyListeners(); // Or call setState if it's in a stateful widget
  }

  List<String> extractVariantIds(
    List<Map<String, dynamic>> selectedVariantList,
  ) {
    return selectedVariantList.map((variantMap) {
      final variantData = variantMap.values.first;
      return variantData["id"] as String;
    }).toList();
  }

  apiCallGetProductSkuIdByProductVariants() async {
    _isLoading = true;
    try {
      // Dynamically add only non-null and non-empty IDs
      List<String> productAttributesIds = [];

      productAttributesIds = extractVariantIds(selectedVariantList);

      Map<String, dynamic> body = {
        "product_id": productResponse?.data?.productInfo?.productId,
        "product_attributes_ids": productAttributesIds,
      };

      String endPoint = ApiConstants.getProductSkuIdByProductVariants;
      var response = await callPostMethod(endPoint, body);

      productSkuByProductVariantId = ProductSkuByProductVariantId.fromJson(
        json.decode(response),
      );

      if (productSkuByProductVariantId?.isError == false &&
          productSkuByProductVariantId?.isValidationFailed == false) {
        final product = productResponse?.data?.productInfo;
        product?.productQty = 1;
        product?.productVariantId = productSkuByProductVariantId?.data?.productSkuId;
        product?.price = double.parse(productSkuByProductVariantId?.data?.price.toString() ?? "",);
        product?.productImages = productSkuByProductVariantId?.data?.productSkuImage;
        product?.productDescription = productSkuByProductVariantId?.data?.itemDescription;
      }

      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Product By Category $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
