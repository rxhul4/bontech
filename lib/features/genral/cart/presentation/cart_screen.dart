import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common/common_button_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/notes_dialog_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/update_quantity_dialog_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/admin/dashboard_ad/dashboard_ad.dart';
import 'package:sales_app_redesign/features/genral/cart/model/cart_model.dart';
import 'package:sales_app_redesign/features/genral/cart/provider/cart_provider.dart';
import 'package:sales_app_redesign/features/genral/instruments/model/intrument_model.dart';
import 'package:sales_app_redesign/features/genral/instruments/pages/add_instruments_screen.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/sales/dashboard/dashboard.dart';
import 'package:sales_app_redesign/features/sales/hospital/presentation/select_hospital_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CartScreen extends StatefulWidget {
  bool? isAdmin;

  CartScreen({super.key, this.isAdmin});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // late ProductCubit _productCubit;
  // late CartCubit _cartCubit;

  late ProductProvider _productProvider;
  late CartProvider _cartProvider;

  //cart provider
  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _productProvider.cartModel = CartModel();
    if (widget.isAdmin == true) {
      _productProvider.getCartList(PreferenceHelper.CART_MODEL_LIST_AD);
    } else {
      _productProvider.getCartList(PreferenceHelper.CART_MODEL_LIST);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Stack(
          children: [
            AppScaffold(
              // bgColor: AppColors.colorPrimary,
              appBar: PreferredSize(
                preferredSize: const Size(double.infinity, appBarSize),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  child: AppBarWidget(
                    isBackVisible: true,
                    title: "CART",
                    isCartVisible: false,
                  ),
                ),
              ),
              body: (
                  (productProvider.cartModel?.productInfo == null ||
                      productProvider.cartModel!.productInfo!.isEmpty)
              )
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppUtils.emptyCartWidget(),
                  10.toSizedBoxHeight,
                  CommonButtonWidget(
                    buttonText: "Continue Shopping",
                    onPressed: () {
                      if (widget.isAdmin == true) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreenAD(),
                          ),
                              (route) => false,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                              (route) => true,
                        );
                      }
                    },
                    verticalPadding: 10,
                    fontSize: fontSizeSmall,
                    horizontalMargin: 120,
                  ),
                ],
              )
                  : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          /// 🛒 PRODUCT LIST
                          if (productProvider.cartModel?.productInfo != null &&
                              productProvider.cartModel!.productInfo!
                                  .isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Products",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: productProvider
                                      .cartModel?.productInfo?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    return _listItem(
                                      index,
                                      productProvider.cartModel!
                                          .productInfo![index],
                                      productProvider,
                                    );
                                  },
                                ),
                              ],
                            ),

                          /// 🧰 INSTRUMENT LIST
                          // if (productProvider.cartModel?.instrumentInfo != null &&
                          //     productProvider.cartModel!.instrumentInfo!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Instruments",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productProvider.cartModel
                                    ?.instruments?.length ?? 0,
                                itemBuilder: (context, index) {
                                  print("data");
                                  return _instrumentListItem(
                                    index,
                                    productProvider.cartModel!
                                        .instruments![index],
                                    productProvider,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 💰 SUBTOTAL OR FOOTER
                  _subTotalView(productProvider),
                ],
              ),

            ),
            _cartProvider.isLoading == true
                ? CircleLoadingIndicatorWidget()
                : SizedBox(),
          ],
        );
      },
    );
  }

  Widget _instrumentListItem(int index, InstrumentModel? item,
      ProductProvider productProvider) {
    Uint8List images = base64Decode(item?.images.first
        .split(',')
        .last ?? "");
    return Frost(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   color: AppColors.colorLightGrey,
      // ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          extentRatio: 0.20,
          dragDismissible: false,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            dismissalDuration: const Duration(milliseconds: 1000),
            dismissThreshold: 0.1,
            onDismissed: () {},
          ),
          children: [
            CustomSlidableAction(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              onPressed: (context) {
                AppUtils.showCustomTwoBtnDialog(
                  ctx: context,
                  dialogBtnTextRight: "Yes",
                  dialogBtnTextLeft: "No",
                  dialogMessage:
                  "Are you sure you want to remove this product from cart?",
                  dialogTitle: "Alert",
                  dialogBtnRightFnc: () {
                    if (widget.isAdmin == true) {
                      productProvider.removeProductFromCartListingScreen(
                        index,
                        PreferenceHelper.CART_MODEL_LIST_AD,
                      );
                    } else {
                      productProvider.removeProductFromCartListingScreen(
                        index,
                        PreferenceHelper.CART_MODEL_LIST,
                      );
                    }
                  },
                );
              },
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              foregroundColor: AppColors.colorWhite,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.delete, size: 26, color: AppColors.colorWhite),
            ),
          ],
        ),
        child: Frost(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image section
              Image.memory(
                images,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Error loading image');
                },
              ),

              AppUtils.commonSizedBox(width: 10),

              // Product info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Name + Price
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: (item?.name ?? '').textWidget(
                        fontSize: fontSizeNormal,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorWhite,
                      ),
                    ),
                    5.toSizedBoxWidth,

                    '${AppConstants.currencySymbol}${item?.price ?? 0}'
                        .textWidget(
                      color: AppColors.colorWhite,
                      fontSize: fontSizeNormal,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamilyRoboto,
                    ),
                  ],
                ),

                5.toSizedBoxHeight,

                /// 🔽 Product Variant ListView
                Expanded(
                  child: (item?.quantity ?? '').textWidget(
                    fontSize: fontSizeNormal,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorWhite,
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     if ((item?.productVariant?.isNotEmpty ?? false))
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children:
                  //         item!.productVariant!.entries.map((entry) {
                  //           final key = entry.key;
                  //           final value = entry.value;
                  //
                  //           return '$key: '.richTextView(
                  //             fontFamily: AppConstants.fontFamilyPoppins,
                  //             fontSize: fontSizeNormal,
                  //             color: AppColors.colorLightGrey,
                  //             textSpanList: [
                  //               const WidgetSpan(
                  //                 child: SizedBox(width: 2),
                  //               ),
                  //               TextSpan(
                  //                 text: value.name ?? 'N/A',
                  //                 style: TextStyle(
                  //                   color: AppColors.colorWhite,
                  //                   fontSize: fontSizeSmall,
                  //                   fontFamily:
                  //                   AppConstants.fontFamilyPoppins,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ],
                  //           );
                  //         }).toList(),
                  //       ),
                  //     _productItemCountView(index, item),
                  //   ],
                  // ),

                  /// 🔽 Quantity stepper or actions
                  // _productItemCountView(index, item),
                ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItem(int index, Product? item, ProductProvider productProvider) {
    return Frost(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   color: AppColors.colorLightGrey,
      // ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          extentRatio: 0.20,
          dragDismissible: false,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            dismissalDuration: const Duration(milliseconds: 1000),
            dismissThreshold: 0.1,
            onDismissed: () {},
          ),
          children: [
            CustomSlidableAction(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              onPressed: (context) {
                AppUtils.showCustomTwoBtnDialog(
                  ctx: context,
                  dialogBtnTextRight: "Yes",
                  dialogBtnTextLeft: "No",
                  dialogMessage:
                  "Are you sure you want to remove this product from cart?",
                  dialogTitle: "Alert",
                  dialogBtnRightFnc: () {
                    if (widget.isAdmin == true) {
                      productProvider.removeProductFromCartListingScreen(
                        index,
                        PreferenceHelper.CART_MODEL_LIST_AD,
                      );
                    } else {
                      productProvider.removeProductFromCartListingScreen(
                        index,
                        PreferenceHelper.CART_MODEL_LIST,
                      );
                    }
                  },
                );
              },
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              foregroundColor: AppColors.colorWhite,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.delete, size: 26, color: AppColors.colorWhite),
            ),
          ],
        ),
        child: Frost(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image section
              (item?.image ?? '').toNetWorkImage(
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              AppUtils.commonSizedBox(width: 10),

              // Product info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: (item?.productName ?? '').textWidget(
                            fontSize: fontSizeNormal,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorWhite,
                          ),
                        ),
                        5.toSizedBoxWidth,

                        '${AppConstants.currencySymbol}${item?.price
                            ?.toStringAsFixed(2) ?? 0}'
                            .textWidget(
                          color: AppColors.colorWhite,
                          fontSize: fontSizeNormal,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConstants.fontFamilyRoboto,
                        ),
                      ],
                    ),

                    5.toSizedBoxHeight,

                    /// 🔽 Product Variant ListView
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if ((item?.productVariant?.isNotEmpty ?? false))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            item!.productVariant!.entries.map((entry) {
                              final key = entry.key;
                              final value = entry.value;

                              return '$key: '.richTextView(
                                fontFamily: AppConstants.fontFamilyPoppins,
                                fontSize: fontSizeNormal,
                                color: AppColors.colorLightGrey,
                                textSpanList: [
                                  const WidgetSpan(
                                    child: SizedBox(width: 2),
                                  ),
                                  TextSpan(
                                    text: value.name ?? 'N/A',
                                    style: TextStyle(
                                      color: AppColors.colorWhite,
                                      fontSize: fontSizeSmall,
                                      fontFamily:
                                      AppConstants.fontFamilyPoppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        _productItemCountView(index, item),
                      ],
                    ),

                    /// 🔽 Quantity stepper or actions
                    // _productItemCountView(index, item),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _productItemCountView(int index, Product? item) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if ((item?.productQty ?? 1) > 1) {
                _productProvider.updateProductQtyFromCartListingScreen(
                  index,
                  (item?.productQty ?? 1) - 1,
                  widget.isAdmin == true
                      ? PreferenceHelper.CART_MODEL_LIST_AD
                      : PreferenceHelper.CART_MODEL_LIST,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1.3, color: AppColors.colorWhite),
              ),
              child: const Icon(
                Icons.remove,
                size: 16,
                color: AppColors.colorWhite,
              ),
            ),
          ),
          // 12.toSizedBoxWidth,
          InkWell(
            onTap: () {
              _productProvider.qtyEditController.text =
              '${item?.productQty ?? 1}';
              showDialog(
                context: context,
                builder: (context) {
                  return UpdateQuantityDialogWidget(
                    qtyTextEditingController:
                    _productProvider.qtyEditController,
                    positiveCallBack: (val) {
                      _productProvider.updateProductQtyFromCartListingScreen(
                        index,
                        int.parse(val),
                        widget.isAdmin == true
                            ? PreferenceHelper.CART_MODEL_LIST_AD
                            : PreferenceHelper.CART_MODEL_LIST,
                      );
                    },
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10.0,
              ),
              child: ('${item?.productQty ?? 1}').textWidget(
                fontSize: fontSizeMedium,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                color: AppColors.colorWhite,
              ),
            ),
          ),
          // 12.toSizedBoxWidth,
          InkWell(
            onTap: () {
              _productProvider.updateProductQtyFromCartListingScreen(
                index,
                (item?.productQty ?? 1) + 1,
                widget.isAdmin == true
                    ? PreferenceHelper.CART_MODEL_LIST_AD
                    : PreferenceHelper.CART_MODEL_LIST,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: AppUtils.commonGradientBoxDecoration(borderRadius: 8),
              child: const Icon(
                Icons.add,
                size: 16,
                color: AppColors.colorWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subTotalView(ProductProvider productProvider) {
    return Visibility(
      visible:
      ((productProvider.cartModel?.productInfo != null) ||
          productProvider.cartModel?.productInfo != [] ||
          productProvider.cartModel?.productInfo?.length != 0),
      child: Frost(
        blur: 16,
        opacity: .22,
        radius: 14,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Frost(
              blur: 16,
              opacity: .22,
              radius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Spacer(),
                  'Total (${productProvider.totalQty} Items)'.textWidget(
                    color: AppColors.colorWhite.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  '${AppConstants.currencySymbol}${productProvider.cartTotal}'
                      .textWidget(
                    color: AppColors.colorWhite,
                    fontSize: fontSizeMedium,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
            ),
            const Spacer(),
            widget.isAdmin == true
                ? GestureDetector(
              onTap: () {
                AppUtils.showCustomTwoBtnDialog(
                  ctx: context,
                  rightPop: false,
                  dialogBtnTextLeft: "No",
                  dialogBtnTextRight: "Yes",
                  dialogTitle: "instruments",
                  dialogMessage: "Do you want to add instruments?",
                  dialogBtnRightFnc: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AddInstrumentsScreen(),)).then((
                        value) {
                      if (widget.isAdmin == true) {
                        _productProvider.getCartList(PreferenceHelper.CART_MODEL_LIST_AD);
                      } else {
                        _productProvider.getCartList(PreferenceHelper.CART_MODEL_LIST);
                      }
                    },);
                  },);

                // showDialog(

                //   context: context, builder: (context) {
                //   return DeliveryNotesDialogWidget(
                //     notesController: _cartProvider.notesController,
                //     positiveCallBack: (val) {
                //       _cartProvider.apiCallAddOrderAD(
                //         productProvider.cartModel?.productInfo,
                //             () {
                //           _cartProvider.notesController.clear();
                //           productProvider.clearList();
                //           // PreferenceHelper.remove(PreferenceHelper.remove(key))
                //         },
                //       );
                //     },
                //   );
                // },);

                // showAlertDialog(
                //   title: "Distributor Note",
                //   isTitleCenter: true,
                //
                //   widget: DeliveryNotesDialogWidget(
                //     notesController: _cartProvider.notesController,
                //     positiveCallBack: (val) {
                //       _cartProvider.apiCallAddOrderAD(
                //         productProvider.cartModel?.productInfo,
                //             () {
                //           _cartProvider.notesController.clear();
                //           productProvider.clearList();
                //           // PreferenceHelper.remove(PreferenceHelper.remove(key))
                //         },
                //       );
                //     },
                //   ),
                //   context: context,
                // );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: AppUtils.commonGradientBoxDecoration(
                  borderRadius: 16,
                ),
                // decoration: BoxDecoration(
                //   gradient: const LinearGradient(
                //     colors: [Color(0xFF5C9DFF), Color(0xFF3E7BFA)],
                //   ),
                //   borderRadius: BorderRadius.circular(16),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black.withOpacity(.25),
                //       blurRadius: 10,
                //       offset: const Offset(0, 6),
                //     ),
                //   ],
                // ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    "Confirm Order".textWidget(
                      color: AppColors.colorWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      latterSpacing: 0,
                    ),
                  ],
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                        SelectHospitalScreen(
                          cartModel: productProvider.cartModel,
                        ),
                  ),
                ).then((value) {
                  productProvider.clearList();
                  productProvider.getCartList(
                    PreferenceHelper.CART_MODEL_LIST,
                  );
                });
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: AppUtils.commonGradientBoxDecoration(
                  borderRadius: 16,
                ),
                // decoration: BoxDecoration(
                //   gradient: const LinearGradient(
                //     colors: [Color(0xFF5C9DFF), Color(0xFF3E7BFA)],
                //   ),
                //   borderRadius: BorderRadius.circular(16),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black.withOpacity(.25),
                //       blurRadius: 10,
                //       offset: const Offset(0, 6),
                //     ),
                //   ],
                // ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    "Select Hospital".textWidget(
                      color: AppColors.colorWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      latterSpacing: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
