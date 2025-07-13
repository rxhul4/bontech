
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/update_quantity_dialog_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/local_model/order_by_user.dart';
import 'package:sales_app_redesign/features/admin/order/model/local_model/order_product_model.dart';
import 'package:sales_app_redesign/features/admin/order/presentation/order_list_screen.dart';
import 'package:sales_app_redesign/features/admin/order/provider/order_provider_ad.dart';

class UserOrderScreen extends StatefulWidget {
  OrderedProductModel? productModel;
  UserOrderScreen({super.key,this.productModel});

  @override
  State<UserOrderScreen> createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen> {

  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  int calculateTotalPriceForProduct() {
    int total = 0;
    for (var user in userOrderList) {
      total += (user.qty ?? 0) * (widget.productModel?.price ?? 0);
    }
    return total;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              centerTitle: true,
              title: "Product",
              isBackVisible: true,
              isCartVisible: true,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Column(
              children: [
                productInfo(),
                10.toSizedBoxHeight,
                Divider(
                  thickness: 0.2,
                  color: AppColors.colorLightGrey.withOpacity(
                    0.9,
                  ),
                ),
                10.toSizedBoxHeight,
                listOfOrderedProduct()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget productInfo() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: 'Order #${widget.productModel?.productName}'.textWidget(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorLightGrey,
                      ),
                    ),
                    "${AppConstants.currencySymbol}${(calculateTotalPriceForProduct())}"
                        .textWidget(
                      color: AppColors.colorWhite,
                      fontSize: 15,
                      fontFamily: AppConstants.fontFamilyRoboto,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                10.toSizedBoxHeight,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ("Qty : ${widget.productModel?.quantity}").textWidget(
                        color: AppColors.colorWhite,
                        fontSize: 13,
                        fontFamily: AppConstants.fontFamilyPoppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // AppUtils.getDate(
                    //   date: "${orderData?.orderDate}",
                    //   format: "MMM dd,yyyy",
                    // ).textWidget(
                    //   color: AppColors.colorLightGrey,
                    //   fontSize: 13,
                    //   fontFamily: AppConstants.fontFamilyPoppins,
                    //   fontWeight: FontWeight.w500,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  listOfOrderedProduct() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: userOrderList.length,
        itemBuilder: (context, index) {
          return _listItemSalesOrderItem(userOrderList[index]);
        },
      ),
    );
  }

  Widget _listItemSalesOrderItem(OrderByUserModel userList) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.colorLightGrey,
      ),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Slidable(


        key: UniqueKey(),
        // endActionPane: ActionPane(
        //   extentRatio: 0.3,
        //   dragDismissible: false,
        //   motion: const ScrollMotion(),
        //   dismissible: DismissiblePane(
        //     dismissalDuration: const Duration(milliseconds: 1000),
        //     dismissThreshold: 0.1,
        //     onDismissed: () {},
        //   ),
        //   children: [
        //     // CustomSlidableAction(
        //     //   padding: EdgeInsets.only(top: 0, bottom: 0),
        //     //   onPressed: (context) {
        //     //     // _orderProviderAd.qtyController.clear();
        //     //     // _orderProviderAd.qtyController.text =
        //     //     //     (item?.quantity ?? 1).toString();
        //     //     // _showAlertDialogUpdateQuantity(item?.productSKUID);
        //     //   },
        //     //   borderRadius: BorderRadius.only(
        //     //     topRight: Radius.circular(0),
        //     //     bottomRight: Radius.circular(0),
        //     //   ),
        //     //   // backgroundColor: AppColors.colorLightGrey,
        //     //   foregroundColor: AppColors.colorPrimary,
        //     //   backgroundColor: AppColors.colorLightGrey,
        //     //   child: Icon(Icons.edit, size: 26, color: Colors.orange),
        //     // ),
        //     // 4.toSizedBoxWidth,
        //     // CustomSlidableAction(
        //     //   padding: EdgeInsets.only(top: 0, bottom: 0),
        //     //   onPressed: (context) {
        //     //     AppUtils.showCustomTwoBtnDialog(
        //     //       ctx: context,
        //     //       dialogBtnTextRight: "Yes",
        //     //       dialogBtnTextLeft: "No",
        //     //       dialogMessage:
        //     //       "Are you sure you want to remove this product From Order?",
        //     //       dialogTitle: "Alert",
        //     //       dialogBtnRightFnc: () async {
        //     //         // if (item?.productSKUID == null) {
        //     //         //   return;
        //     //         // }
        //     //         // _orderProviderAd.removeProductFromLocal(
        //     //         //   item?.productSKUID ?? "",
        //     //         // );
        //     //       },
        //     //     );
        //     //   },
        //     //   borderRadius: BorderRadius.only(
        //     //     topRight: Radius.circular(12),
        //     //     bottomRight: Radius.circular(12),
        //     //   ),
        //     //   // backgroundColor: AppColors.colorLightGrey,
        //     //   foregroundColor: AppColors.colorPrimary,
        //     //   backgroundColor: AppColors.colorLightGrey,
        //     //
        //     //   child: Icon(Icons.delete, size: 26, color: Colors.red),
        //     // ),
        //   ],
        // ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // if (_orderCubit.orderDetails?.state == OrderStatusType.draft) {
            // if (_orderCubit.isAllowUpdateOrder) {
            //   _orderCubit.qtyEditController.clear();
            //   _orderCubit.qtyEditController.text =
            //       (item?.quantity ?? 1).toString();
            //   _showAlertDialogUpdateQuantity(item?.id);
            // }
          },
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorSecondary.withOpacity(0.25),
                  blurRadius: 0,
                  spreadRadius: 0.0,
                  offset: const Offset(0, 2),
                ),
                // BoxShadow(
                //   color: Colors.white.withOpacity(0.6),
                //   blurRadius: 30,
                //   offset: const Offset(0, 0),
                // ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (userList.userName ?? "")
                              .textWidget(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppConstants.fontFamilyPoppins,
                            fontSize: fontSizeMedium,
                            color: AppColors.colorLightGrey,
                          ),
                        ],
                      ),
                    ),
                    '${AppConstants.currencySymbol}${(userList.qty ?? 0) * (widget.productModel?.price ?? 0)}'
                        .textWidget(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamilyRoboto,
                      fontSize: fontSizeNormal,
                      color: AppColors.colorLightGrey,
                    ),


                    // (_orderProviderAd
                    //     .getDistributorOrderByIdModel
                    //     ?.data
                    //     ?.totOrderStatus ??
                    //     "")
                    //     .textWidget(
                    //   fontWeight: FontWeight.w400,
                    //   fontFamily: AppConstants.fontFamilyPoppins,
                    //   fontSize: 13,
                    //   color: AppColors.colorWhite,
                    // ),
                  ],
                ),

                5.toSizedBoxHeight,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            2.toSizedBoxHeight,
                          'Qty :'.richTextView(
                            textSpanList: [
                              const WidgetSpan(child: SizedBox(width: 3)),
                              TextSpan(
                                text: userList.qty.toString(),
                                style: const TextStyle(
                                  color: AppColors.colorWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          2.toSizedBoxHeight,
                          ' | Price :'.richTextView(
                            textSpanList: [
                              const WidgetSpan(child: SizedBox(width: 3)),
                              TextSpan(
                                text: widget.productModel?.price.toString(),
                                style: const TextStyle(
                                  color: AppColors.colorWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
  updateProductQty(int qty, OrderedProductModel productList) async {
    setState(() {
      productList.quantity = qty;
    });


  }

  Widget _productItemCountView(OrderedProductModel productList) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                if ((productList.quantity ?? 1) > 1) {
                  updateProductQty((productList.quantity ?? 1) - 1,productList);
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
            InkWell(
              onTap: () {
                quantityController.text = '${productList.quantity ?? 1}';
                showAlertDialog(
                  context: context,
                  title: "Update Quantity",
                  isTitleCenter: true,
                  widget: UpdateQuantityDialogWidget(
                    qtyTextEditingController: quantityController,
                    positiveCallBack: (val) {
                      setState(() {
                        productList.quantity = int.parse(val);
                      });},
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical:8,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: ("${productList.quantity}")
                    .textWidget(
                  fontSize: fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  color: AppColors.colorWhite,
                ),
              ),
            ),
            InkWell(
              onTap: () {

                updateProductQty((productList.quantity ?? 1) + 1,productList);
                // _productProvider.updateProductQty(
                //   (_productProvider.productInfoResponse?.qty ?? 1) + 1,
                // );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: AppUtils.commonGradientBoxDecoration(
                  borderRadius: 8,
                ),
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: AppColors.colorWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
