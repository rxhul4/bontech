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
                preferredSize: const Size(double.infinity,appBarSize),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  child: AppBarWidget(
                    isBackVisible: true,
                    title: "CART",
                    isCartVisible: false,
                  ),
                ),
              ),
              body:
                  (productProvider.cartModel?.productInfo == null ||
                          productProvider.cartModel?.productInfo == [] ||
                          (productProvider.cartModel?.productInfo?.length == 0))
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
                            // ✅ Changed from fixed height to Expanded
                            child: ListView.builder(
                              itemCount:
                                  productProvider
                                      .cartModel
                                      ?.productInfo
                                      ?.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return _listItem(
                                  index,
                                  productProvider
                                      .cartModel
                                      ?.productInfo?[index],
                                  productProvider,
                                );
                              },
                            ),
                          ),
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
                  dialogMessage: "Are you sure you want to remove this product from cart?",
                  dialogTitle: "Alert",
                  dialogBtnRightFnc: () {
                    if (widget.isAdmin == true) {
                      productProvider.removeProductFromCartListingScreen(index, PreferenceHelper.CART_MODEL_LIST_AD);
                    } else {
                      productProvider.removeProductFromCartListingScreen(index, PreferenceHelper.CART_MODEL_LIST);
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
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
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

                        '${AppConstants.currencySymbol}${item?.price?.toStringAsFixed(2) ?? 0}'
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
                            children: item!.productVariant!.entries.map((entry) {
                              final key = entry.key;
                              final value = entry.value;

                              return '$key: '.richTextView(
                                fontFamily: AppConstants.fontFamilyPoppins,
                                fontSize: fontSizeNormal,
                                color: AppColors.colorLightGrey,
                                textSpanList: [
                                  const WidgetSpan(child: SizedBox(width: 2)),
                                  TextSpan(

                                    text: value.name ?? 'N/A',
                                    style: TextStyle(
                                      color: AppColors.colorWhite,
                                      fontSize: fontSizeSmall,
                                      fontFamily: AppConstants.fontFamilyPoppins,
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
              showDialog(context: context, builder: (context) {
                return UpdateQuantityDialogWidget(
                  qtyTextEditingController: _productProvider.qtyEditController,
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
              },);

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

              // _productCubit.updateProductQtyFromCartListingScreen(
              //     index, (item?.qty ?? 1) + 1);
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
        margin: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 20),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Frost(
              blur: 16,
              opacity: .22,
              radius: 14,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
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
            widget.isAdmin == true ?  GestureDetector(
              onTap: () {

                showDialog(
                  context: context, builder: (context) {
                  return DeliveryNotesDialogWidget(
                    notesController: _cartProvider.notesController,
                    positiveCallBack: (val) {
                      _cartProvider.apiCallAddOrderAD(
                        productProvider.cartModel?.productInfo,
                            () {
                          _cartProvider.notesController.clear();
                          productProvider.clearList();
                          // PreferenceHelper.remove(PreferenceHelper.remove(key))
                        },
                      );
                    },
                  );
                },);

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
                    borderRadius: 16
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
                      child: const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),

                    ),
                    const SizedBox(width: 10),
                    "Confirm Order".textWidget(
                      color: AppColors.colorWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      latterSpacing: 0
                    ),
                  ],
                ),
              ),
            ) :  GestureDetector(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SelectHospitalScreen(
                      cartModel: productProvider.cartModel,
                    ),
                  ),
                ).then((value) {
                  
                  productProvider.clearList();
                  productProvider.getCartList(PreferenceHelper.CART_MODEL_LIST);
                });
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: AppUtils.commonGradientBoxDecoration(
                    borderRadius: 16
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
                      child: const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),

                    ),
                    const SizedBox(width: 10),
                    "Select Hospital".textWidget(
                        color: AppColors.colorWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        latterSpacing: 0
                    ),
                  ],
                ),
              ),
            ) ,

          ],
        ),
      ),
    );
  }
  //
  // Widget _subTotalView(ProductProvider productProvider) {
  //   return Visibility(
  //     visible:
  //         ((productProvider.cartModel?.productInfo != null) ||
  //             productProvider.cartModel?.productInfo != [] ||
  //             productProvider.cartModel?.productInfo?.length != 0),
  //     child: Frost(
  //       padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
  //       child: Column(
  //         children: [
  //           SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               // const Spacer(),
  //               'Total (${productProvider.totalQty} Items) : '.textWidget(
  //                 color: AppColors.colorWhite,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: fontSizeNormal,
  //               ),
  //               '${AppConstants.currencySymbol}${productProvider.cartTotal}'
  //                   .textWidget(
  //                     color: AppColors.colorWhite,
  //                     fontSize: fontSizeMedium,
  //                     fontFamily: AppConstants.fontFamilyRoboto,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //
  //           widget.isAdmin == true
  //               ? ActionSlider.standard(
  //                 action: (controller) {
  //                   // controller.loading();
  //                   showAlertDialog(
  //                     title: "Distributor Note",
  //                     isTitleCenter: true,
  //                     widget: DeliveryNotesDialogWidget(
  //                       notesController: _cartProvider.notesController,
  //                       positiveCallBack: (val) {
  //                         _cartProvider.apiCallAddOrderAD(
  //                           productProvider.cartModel?.productInfo,
  //                           () {
  //                             _cartProvider.notesController.clear();
  //                             productProvider.clearList();
  //                             // PreferenceHelper.remove(PreferenceHelper.remove(key))
  //                           },
  //                         );
  //                       },
  //                     ),
  //                     context: context,
  //                   );
  //                   // controller.success();
  //                 },
  //                 sliderBehavior: SliderBehavior.move,
  //                 rolling: false,
  //                 backgroundColor: AppColors.colorLightGrey,
  //                 customForegroundBuilder: (p0, p1, p2) {
  //                   return Container(
  //                     width: 80,
  //                     height: 80,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       gradient: LinearGradient(
  //                         colors: [AppColors.gradient1, AppColors.gradient2],
  //                         begin: Alignment.topLeft,
  //                         end: Alignment.bottomRight,
  //                       ),
  //                     ),
  //                     child: Icon(
  //                       Icons.done,
  //                       color: AppColors.colorWhite,
  //                       size: 30,
  //                     ),
  //                   );
  //                 },
  //
  //                 child: Shimmer(
  //                   child: "Confirm Order".textWidget(
  //                     color: AppColors.colorDarkGrey,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               )
  //               : CommonButtonWidget(
  //                 buttonText: "Select Hospital",
  //                 onPressed: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder:
  //                           (context) => SelectHospitalScreen(
  //                             cartModel: productProvider.cartModel,
  //                           ),
  //                     ),
  //                   ).then((value) {
  //                     productProvider.clearList();
  //                   });
  //                 },
  //               ),
  //
  //           // ActionSlider.custom(
  //           //   // height: 80,
  //           //   width: double.infinity,
  //           //   backgroundColor: AppColors.colorLightGrey,
  //           //
  //           //   foregroundBuilder: (p0, p1, p2) {
  //           //   return Container(
  //           //     // width: 80,
  //           //     height: 80,
  //           //     decoration: BoxDecoration(
  //           //       shape: BoxShape.circle,
  //           //       gradient: LinearGradient(
  //           //         colors: [
  //           //           AppColors.gradient1,
  //           //           AppColors.gradient2,
  //           //         ],
  //           //         begin: Alignment.topLeft,
  //           //         end: Alignment.bottomRight,
  //           //       ),
  //           //     ),
  //           //     child: Icon(
  //           //       Icons.done,
  //           //       color: AppColors.colorWhite,
  //           //       size: 30,
  //           //     ),
  //           //   );
  //           // },)
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
