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
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart'
    as detail_res;
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_category.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_viewtype.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_sku_by_product_varient_id.dart';

import '../../../sales/dashboard/dashboard.dart';

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

  List<detail_res.ColorData> colorVariantList = [];
  List<detail_res.Steps> stepVariantList = [];
  List<detail_res.MaterialData> materialVariantList = [];
  List<detail_res.Side> sideVariantList = [];

  List<detail_res.ProductInfo?> prefCartProductList = [];

  detail_res.ColorData? selectedColorVariant;
  detail_res.Side? selectedSideVariant;
  detail_res.Steps? selectedSizeVariant;
  detail_res.MaterialData? selectedMaterialVariant;

  TextEditingController qtyEditController = TextEditingController();

  // List<>

  GetProductByCategoryModel? getProductByCategoryModel;
  GetProductByProductId? getProductByProductId;
  HomViewTypeByIdModel? homViewTypeByIdModel;
  detail_res.ProductInfo? productInfoResponse;
  ProductSkuByProductVariantId? productSkuByProductVariantId;
  SalesOrderProductList? salesOrderProductList;
  CartModel? cartModel;
  int cartTotal = 0;
  int totalQty = 0;

  FlutterCarouselController carouselController = FlutterCarouselController();

  // AllCategoryModel? allCategoryModel;
  // SalesProductsViewModel? salesProductsViewModel;

  // GetFavouriteProductsModel? getFavouriteProductsModel;
  // CommonResponseModel? commonResponseModel;.

  void resetProductData() {
    sideVariantList.clear();
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

      if (productInfoResponse == null) {
        print("Product data not found.");
        return;
      }

      print("skuId: ${productInfoResponse?.productVariantId}");

      // Prepare the product variant to be added
      final ProductInfo productVariant = ProductInfo(
        productVariantId: productInfoResponse?.productVariantId,
        productId: productInfoResponse?.productId,
        productName: productInfoResponse?.productName,
        productCategoryName: productInfoResponse?.productCategoryName,
        qty: productInfoResponse?.qty,
        selectedSize: selectedSizeVariant,
        selectedMaterial: selectedMaterialVariant,
        price: productInfoResponse?.price,
        image: productInfoResponse?.image,
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
        final int currentQty = existingItem?.qty ?? 1;
        final int addedQty = productVariant.qty ?? 1;
        existingItem?.qty = (currentQty + addedQty);
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

  void addProductToOrder({ProductInfo? product,required BuildContext context}){

    print("productData${product?.productName}");
    print("productSize${selectedSideVariant?.name}");
    print("productMaterial${product?.selectedMaterial?.name}");
   String?  productListJson =  PreferenceHelper.getString("ProductList");
   List<SalesOrderProductList> orderProductList = [];


   if (productListJson != null && productListJson.isNotEmpty) {
     List<dynamic> jsonList = jsonDecode(productListJson);
     orderProductList = jsonList.map((item) => SalesOrderProductList.fromJson(item)).toList();
   }

   SalesOrderProductList salesOrderProductList = SalesOrderProductList(
     productSKUID: product?.productVariantId,
     productName: product?.productName,
     quantity: product?.qty,
     size: selectedSizeVariant?.name,
     material: selectedMaterialVariant?.name,
     price: product?.price,
     subAmount: ((product?.price ?? 0) * (product?.qty ?? 0)),

   );

   orderProductList.add(salesOrderProductList);


   String updatedJson = jsonEncode(orderProductList);

   print("UpdatedJson$updatedJson");
    AppUtils.showSnackBarWithColor(
      context: context,
      message: "Your Product has Added to Order",
    );

   PreferenceHelper.setString("ProductList", updatedJson);




  }

  List<ProductInfo> getCartList(String cartKey) {
    try {
      final String cartString = PreferenceHelper.getString(cartKey) ?? '';

      if (cartString.isEmpty) {
        return [];
      }

      final Map<String, dynamic> cartJson = jsonDecode(cartString);
      cartModel = CartModel.fromJson(cartJson);
      calculateSubtotal();

      return cartModel?.productInfo ?? [];
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error in getCartList: $e\n$stackTrace");
      }
      return [];
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
    cartTotal = 0;
    totalQty = 0;
    cartModel = CartModel();
    updateCartItemCount();
    notifyListeners();
  }

  updateProductQty(int qty) async {
    productInfoResponse?.qty = qty;
    notifyListeners();
  }

  updateProductQtyFromCartListingScreen(
    int index,
    int qty,
    String cartkey,
  ) async {
    cartModel?.productInfo?[index].qty = qty;
    /* calculated price for cart screen */
    cartModel?.productInfo?[index].calculatedPrice =
        qty * (cartModel?.productInfo?[index].price ?? 0);
    final encodedCart = cartModel?.toJson();
    final cartStringUpdated = convertJsonToString(encodedCart);
    PreferenceHelper.setString(cartkey, cartStringUpdated);
    // emit(ProductState().init());
    // calculateSubtotal();
    getCartItemCount();
    calculateSubtotal();
    notifyListeners();
  }

  void calculateSubtotal() {
    cartTotal = 0;
    totalQty = 0;

    cartModel?.productInfo?.forEach((product) {
      final price = product.price;
      final qty = product.qty;

      if (price != null && qty != null) {
        cartTotal += price * qty;
        totalQty += qty;
      }
    });
  }

  refreshScreenOnSizeChange(
    String? productId,
    detail_res.Steps newItem,
    int? index,
  ) {
    selectedSizeIndex.value = index;
    selectedSizeVariant = newItem;
    apiCallGetProductSkuIdByProductVariants(
      productId: productId,
      index: index,
      isSize: true,
      selectedSideId: selectedSideVariant?.id,
      selectedMaterialID: selectedMaterialVariant?.id,
      selectedSizeId: selectedSizeVariant?.id,
    );
    notifyListeners();

    // apiCallGetProductDetails(productId);
  }

  // refreshScreenOnColorChange(
  //     String? productId,
  //     detail_res.ColorData newItem,
  //     int? index,
  //     ) {
  //   selectedColorIndex.value = index;
  //   selectedColorVariant = newItem;
  //   apiCallGetProductSkuIdByProductVariants(
  //     productId: productId,
  //     index: index,
  //     isColor: true,
  //     selectedColorId: selectedColorVariant?.id,
  //     selectedMaterialID: selectedMaterialVariant?.id,
  //     selectedSizeId: selectedSizeVariant?.id,
  //   );
  //   notifyListeners();
  //
  // }

  refreshScreenOnSideChange(
    String? productId,
    detail_res.Side newItem,
    int? index,
  ) {
    selectedSideIndex.value = index;
    selectedSideVariant = newItem;
    apiCallGetProductSkuIdByProductVariants(
      productId: productId,
      index: index,
      isColor: true,
      selectedMaterialID: selectedMaterialVariant?.id,
      selectedSizeId: selectedSizeVariant?.id,
      selectedSideId: selectedSideVariant?.id,
    );
    notifyListeners();
  }

  refreshScreenOnMaterialChange(
    String? productId,
    detail_res.MaterialData newItem,
    int? index,
  ) {
    selectedMaterialIndex.value = index;
    selectedMaterialVariant = newItem;
    apiCallGetProductSkuIdByProductVariants(
      productId: productId,
      index: index,
      isMaterial: true,
      selectedMaterialID: selectedMaterialVariant?.id,
      selectedSizeId: selectedSizeVariant?.id,
      selectedSideId: selectedSideVariant?.id,
    );
    notifyListeners();
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

  Future<List<ProductList>> apiCallGetHomeView({String? viewTypeId, int? page}) async {
    String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isFetching = true;
    // notifyListeners();
    try {
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

  Future<GetProductByProductId?> apiCallGetProductById(
    String? productId,
  ) async {
    print("kkkkkkkkkk1");

    _isFetching = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {"product_id": productId};
      String endPoint = ApiConstants.getProductSkuByProductId;
      var response = await callPostMethod(endPoint, body);
      getProductByProductId = GetProductByProductId.fromJson(
        json.decode(response),
      );
      if (getProductByProductId?.isError == false &&
          getProductByProductId?.isValidationFailed == false) {
        if ((getProductByProductId?.data?.productInfo ?? []).isNotEmpty) {
          productInfoResponse = getProductByProductId?.data?.productInfo?[0];
          productInfoResponse?.qty = 1;

          selectedColorVariant = productInfoResponse?.productVariant?.color;
          selectedMaterialVariant =
              productInfoResponse?.productVariant?.material;
          selectedSizeVariant = productInfoResponse?.productVariant?.steps;
          selectedSideVariant = productInfoResponse?.productVariant?.side;
          print("SelectedSideVar${selectedSideVariant?.name}");

          productInfoResponse?.allVariants?.forEach((action) async {
            if ((action.color ?? []).isNotEmpty) {
              colorVariantList = action.color ?? [];
            }
            if ((action.steps ?? []).isNotEmpty) {
              stepVariantList = action.steps ?? [];
            }
            if ((action.material ?? []).isNotEmpty) {
              materialVariantList = action.material ?? [];
            }

            if ((action.side ?? []).isNotEmpty) {
              sideVariantList = action.side ?? [];
            }
          });
          selectedColorIndex.value = colorVariantList.indexWhere(
            (element) => element.id == selectedColorVariant?.id,
          );
          selectedMaterialIndex.value = materialVariantList.indexWhere(
            (element) => element.id == selectedMaterialVariant?.id,
          );
          selectedSizeIndex.value = stepVariantList.indexWhere(
            (element) => element.id == selectedSizeVariant?.id,
          );
          selectedSideIndex.value = sideVariantList.indexWhere(
            (element) => element.id == selectedSideVariant?.id,
          );
          productVariantsId.value = [
            selectedSideVariant?.id,
            // selectedColorVariant?.id,
            selectedMaterialVariant?.id,
            selectedSizeVariant?.id,
          ];
          // getProductFromCartPreference();
        }

        Future.delayed(Duration(milliseconds: 100), () {
          if ((productInfoResponse?.productImages ?? []).isNotEmpty) {
            carouselController.jumpToPage(0);
          }
          notifyListeners();
          // emit(SuccessState());
        });
      }
      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Product By Category ${e}');
    }
    _isFetching = false;
    notifyListeners();
    return getProductByProductId;
  }

  apiCallGetProductSkuIdByProductVariants({
    String? productId,
    String? selectedSideId,
    String? selectedSizeId,
    String? selectedMaterialID,
    int? index,
    bool isColor = false,
    bool isMaterial = false,
    bool isSize = false,
    bool isSide = false,
  }) async {
    _isLoading = true;
    try {
      // Dynamically add only non-null and non-empty IDs
      List<String> productAttributesIds = [];
      if (selectedSideId?.isNotEmpty == true) productAttributesIds.add(selectedSideId ?? "");
      if (selectedSizeId?.isNotEmpty == true) productAttributesIds.add(selectedSizeId?? "");
      if (selectedMaterialID?.isNotEmpty == true) productAttributesIds.add(selectedMaterialID ?? "");

      Map<String, dynamic> body = {
        "product_id": productId,
        "product_attributes_ids": productAttributesIds,
      };

      String endPoint = ApiConstants.getProductSkuIdByProductVariants;
      var response = await callPostMethod(endPoint, body);

      productSkuByProductVariantId = ProductSkuByProductVariantId.fromJson(
        json.decode(response),
      );

      if (productSkuByProductVariantId?.isError == false &&
          productSkuByProductVariantId?.isValidationFailed == false) {
        productInfoResponse?.qty = 1;
        productInfoResponse?.productVariantId = productSkuByProductVariantId?.data?.productSkuId;
        productInfoResponse?.price = productSkuByProductVariantId?.data?.price;
        productInfoResponse?.productImages = productSkuByProductVariantId?.data?.productSkuImage;
      }

      print('yooooooooooo $response');
    } catch (e) {
      print('catch at get Product By Category $e');
    }
    _isLoading = false;
    notifyListeners();
  }

}
