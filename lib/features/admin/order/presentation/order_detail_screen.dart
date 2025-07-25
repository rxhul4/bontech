import 'package:action_slider/action_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common/no_data_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/bulk_product_quantity_update_dialog_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/notes_dialog_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/update_quantity_dialog_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_detail_order_by_id_model.dart'
    as od;
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_detail_order_by_id_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart'
    as slOd;
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';
import 'package:sales_app_redesign/features/admin/order/provider/order_provider_ad.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_listing_page.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    this.orderId,
    this.isAdmin,
    this.isSalesSide = false,
  });

  final String? orderId;
  final bool? isAdmin;
  final bool? isSalesSide;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrderProviderAd _orderProviderAd;

  @override
  void initState() {
    super.initState();
    _orderProviderAd = Provider.of<OrderProviderAd>(context, listen: false);
    if (widget.isAdmin == true) {
      _orderProviderAd.apiCallGetDistributorOrderDetailsById(widget.orderId);
    } else {
      _orderProviderAd.apiCallAllSalesManOrderDetailById(widget.orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProviderAd>(
      builder: (context, orderDetails, child) {
        if (kDebugMode) {
          print(
            'logcat :: status key == ${orderDetails.getDistributorOrderByIdModel?.data?.totOrderStatus}',
          );
          print(
            'logcat :: status key == ${orderDetails.getAllSalesmanOrderByIdModel?.data?.totOrderStatus}',
          );
        }

        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              onBackPressed: null,
              title: "Order Details",
              isBackVisible: true,
              isCartVisible: false,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child:
                orderDetails.isFetching
                    ? CircleLoadingIndicatorWidget()
                    : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              5.toSizedBoxHeight,
                              widget.isAdmin == true
                                  ? _orderInfoView(
                                    orderDetails
                                        .getDistributorOrderByIdModel
                                        ?.data,
                                  )
                                  : _salesOrderInfoView(
                                    _orderProviderAd
                                        .getAllSalesmanOrderByIdModel
                                        ?.data,
                                  ),
                              10.toSizedBoxHeight,
                              Divider(
                                thickness: 0.2,
                                color: AppColors.colorLightGrey.withOpacity(
                                  0.9,
                                ),
                              ),
                              10.toSizedBoxHeight,
                              widget.isAdmin == false
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _salesOrderHospitalView(
                                        _orderProviderAd
                                            .getAllSalesmanOrderByIdModel
                                            ?.data,
                                      ),
                                      10.toSizedBoxHeight,
                                      Divider(
                                        thickness: 0.2,
                                        color: AppColors.colorLightGrey
                                            .withOpacity(0.9),
                                      ),
                                      10.toSizedBoxHeight,
                                    ],
                                  )
                                  : SizedBox(),

                              'Product List'.textWidget(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeExtraLarge,
                                color: AppColors.colorWhite,
                              ),
                              5.toSizedBoxHeight,
                              widget.isAdmin == true
                                  ? _orderList(
                                    orderDetails
                                        .getDistributorOrderByIdModel
                                        ?.data,
                                  )
                                  : _salesOrderList(
                                    orderDetails
                                        .getAllSalesmanOrderByIdModel
                                        ?.data,
                                    // _orderProviderAd.salesOrderProductList,
                                  ),

                              widget.isAdmin == true
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      10.toSizedBoxHeight,
                                      Divider(
                                        thickness: 0.2,
                                        color: AppColors.colorLightGrey
                                            .withOpacity(0.9),
                                      ),
                                      10.toSizedBoxHeight,

                                      'Notes'.textWidget(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSizeExtraLarge,
                                        color: AppColors.colorWhite,
                                      ),
                                      10.toSizedBoxHeight,
                                      _distributorNote(
                                        orderDetails
                                            .getDistributorOrderByIdModel,
                                      ),
                                      10.toSizedBoxHeight,
                                      _manufacturerNote(
                                        orderDetails
                                            .getDistributorOrderByIdModel,
                                      ),
                                    ],
                                  )
                                  : SizedBox(),
                            ],
                          ),
                        ),

                        widget.isSalesSide == true
                            ? widget.isAdmin == false
                                ? _statusChangeBtn(
                                  orderDetails
                                      .getAllSalesmanOrderByIdModel
                                      ?.data,
                                )
                                : SizedBox()
                            : SizedBox(),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Widget _orderInfoView(od.Data? orderData) {
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
                      child: 'Order #${orderData?.trackingNo}'.textWidget(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorLightGrey,
                      ),
                    ),
                    "${AppConstants.currencySymbol}${(orderData?.totalAmount)}"
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
                      child: (orderData?.totOrderStatus ?? "").textWidget(
                        color: AppColors.colorWhite,
                        fontSize: 13,
                        fontFamily: AppConstants.fontFamilyPoppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppUtils.getDate(
                      date: "${orderData?.orderDate}",
                      format: "MMM dd,yyyy",
                    ).textWidget(
                      color: AppColors.colorLightGrey,
                      fontSize: 13,
                      fontFamily: AppConstants.fontFamilyPoppins,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderList(od.Data? orderData) {
    return (orderData?.dealerOrderDetails ?? []).isEmpty
        ? const Padding(padding: EdgeInsets.all(10.0), child: NoDataWidget())
        : ListView.builder(
          itemCount: (orderData?.dealerOrderDetails ?? []).length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            od.DealerOrderDetails? item = orderData?.dealerOrderDetails?[index];
            return _listItemOrderItem(item);
          },
        );
  }

  Widget _salesOrderInfoView(slOd.Data? orderData) {
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
                      child: 'Order #${orderData?.trackingNo}'.textWidget(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorLightGrey,
                      ),
                    ),
                    "${AppConstants.currencySymbol}${(_orderProviderAd.totalAmount)}"
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
                      child: (orderData?.totOrderStatus ?? "").textWidget(
                        color: AppColors.colorWhite,
                        fontSize: 13,
                        fontFamily: AppConstants.fontFamilyPoppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppUtils.getDate(
                      date: "${orderData?.orderDate}",
                      format: "MMM dd,yyyy",
                    ).textWidget(
                      color: AppColors.colorLightGrey,
                      fontSize: 13,
                      fontFamily: AppConstants.fontFamilyPoppins,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _salesOrderHospitalView(slOd.Data? orderData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Delivery information'.textWidget(
          fontWeight: FontWeight.bold,
          fontSize: fontSizeExtraLarge,
          color: AppColors.colorWhite,
        ),
        10.toSizedBoxHeight,
        Container(
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: '${orderData?.salesmanName}'.textWidget(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorLightGrey,
                    ),
                  ),
                ],
              ),
              10.toSizedBoxHeight,
              Row(
                children: [
                  Expanded(
                    child: '${orderData?.hospitalName?.trim()}'.textWidget(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorLightGrey,
                    ),
                  ),
                  "${(orderData?.hospitalPhoneNo)}".textWidget(
                    color: AppColors.colorWhite,
                    fontSize: 14,
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
                    child: (orderData?.hospitalAddress ?? "").textWidget(
                      color: AppColors.colorWhite,
                      fontSize: 13,
                      fontFamily: AppConstants.fontFamilyPoppins,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _salesOrderList(slOd.Data? orderData) {
    return (orderData?.salesOrderDetails ?? []).isEmpty
        ? const Padding(padding: EdgeInsets.all(10.0), child: NoDataWidget())
        : ListView.builder(
          itemCount: (orderData?.salesOrderDetails ?? []).length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            slOd.SalesOrderProductList? item = orderData?.salesOrderDetails?[index];
            return _listItemSalesOrderItem(item);
          },
        );
  }

  Widget _statusChangeBtn(slOd.Data? orderData) {
    return Builder(
      builder: (context) {
        final status = orderData?.totOrderStatus;
        print("status$status");
        switch (status) {
          case 'Pending':
          return ActionSlider.standard(
                action: (controller) {
                  AppUtils.showCustomTwoBtnDialog(
                    ctx: context,
                    dialogTitle: "Accept",
                    dialogMessage:
                        "Are you sure do you want to change Status 'Accept' ",
                    dialogBtnTextRight: "Accept",
                    dialogBtnTextLeft: "Cancel",
                    dialogBtnRightFnc: () {
                      String? id = _orderProviderAd.findStatusId("Accepted");
                      _orderProviderAd.apiCallChangeOrderStatus(
                        orderId: orderData?.salesmanOrderId,
                        orderStatusId: id,
                        salesManId: orderData?.salesmanId,
                      );

                      //api Call
                    },
                  );
                },
                sliderBehavior: SliderBehavior.move,
                rolling: false,
                backgroundColor: AppColors.colorLightGrey,
                customForegroundBuilder: (p0, p1, p2) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.gradient1, AppColors.gradient2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.done,
                      color: AppColors.colorWhite,
                      size: 30,
                    ),
                  );
                },

                child: Shimmer(
                  child: "Accept Order".textWidget(
                    color: AppColors.colorDarkGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
          case "Accepted":
            return ActionSlider.standard(
              action: (controller) {
                AppUtils.showCustomTwoBtnDialog(
                  ctx: context,
                  dialogTitle: "In Progress Order",
                  dialogMessage:
                      "Are you sure do you want to change Status 'In Progress' ",
                  dialogBtnTextRight: "In Progress",
                  dialogBtnTextLeft: "Cancel",
                  dialogBtnRightFnc: () {
                    String? id = _orderProviderAd.findStatusId("In Progress");
                    _orderProviderAd.apiCallChangeOrderStatus(
                      orderId: orderData?.salesmanOrderId,
                      orderStatusId: id,
                      salesManId: orderData?.salesmanId,
                    );
                    //api Call
                  },
                );
              },
              sliderBehavior: SliderBehavior.move,
              rolling: false,
              backgroundColor: AppColors.colorLightGrey,
              customForegroundBuilder: (p0, p1, p2) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.gradient1, AppColors.gradient2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.done,
                    color: AppColors.colorWhite,
                    size: 30,
                  ),
                );
              },

              child: Shimmer(
                child: "In Progress".textWidget(
                  color: AppColors.colorDarkGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          case "In Progress":
            return ActionSlider.standard(
              action: (controller) {

                _showAlertDialogOrderDeliverUpdateQuantity();
                // AppUtils.showCustomTwoBtnDialog(
                //   ctx: context,
                //   dialogTitle: "Deliver Order",
                //   dialogMessage:
                //       "Are you sure do you want to change Status 'Deliver' ",
                //   dialogBtnTextRight: "Deliver",
                //   dialogBtnTextLeft: "Cancel",
                //   dialogBtnRightFnc: () {
                //     //api Call
                //     String? id = _orderProviderAd.findStatusId("Deliver");
                //
                //
                //     // _orderProviderAd.apiCallChangeOrderStatus(
                //     //   orderId: orderData?.salesmanOrderId,
                //     //   orderStatusId: id,
                //     //   salesManId: orderData?.salesmanId,
                //     // );
                //   },
                // );
              },
              sliderBehavior: SliderBehavior.move,
              rolling: false,
              backgroundColor: AppColors.colorLightGrey,
              customForegroundBuilder: (p0, p1, p2) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.gradient1, AppColors.gradient2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.done,
                    color: AppColors.colorWhite,
                    size: 30,
                  ),
                );
              },

              child: Shimmer(
                child: "Deliver Order".textWidget(
                  color: AppColors.colorDarkGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }


  void _showAlertDialogOrderDeliverUpdateQuantity() {
    showAlertDialog(
      context: context,
      title: "Deliver Quantity",
      isTitleCenter: true,
      widget: BulkProductQtyUpdateDialogWidget(
        productList: _orderProviderAd.getAllSalesmanOrderByIdModel?.data?.salesOrderDetails,
        positiveCallBack: () {
        },
      ),
    );
  }

  Widget _distributorNote(
    GetDistributorOrderByIdModel? getDistributorOrderByIdModel,
  ) {
    return _noteTile(
      "📌 Distributor Note",
      getDistributorOrderByIdModel?.data?.distributorNote,
    );
  }

  Widget _manufacturerNote(
    GetDistributorOrderByIdModel? getDistributorOrderByIdModel,
  ) {
    return _noteTile(
      "📝 Manufacturer Note",
      getDistributorOrderByIdModel?.data?.manufactureDeliveryNote,
    );
  }

  Widget _noteTile(String title, String? note) {
    return AppUtils.commonContainer(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title.textWidget(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.colorWhite,
          ),
          "${note?.isNotEmpty == true ? note : 'No Notes'}".textWidget(
            fonStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.colorWhite,
          ),
        ],
      ),
    );
  }

  // Widget _orderReceiveList() {
  //   return (_orderCubit.orderPickingListResponse?.data ?? []).isEmpty
  //       ? const Padding(
  //     padding: EdgeInsets.all(10.0),
  //     child: NoDataWidget(),
  //   )
  //       : ListView.builder(
  //       itemCount:
  //       (_orderCubit.orderPickingListResponse?.data ?? []).length,
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         op.PickingData? item =
  //         _orderCubit.orderPickingListResponse?.data?[index];
  //         print(
  //             "------------------${_orderCubit.orderPickingListResponse?.data?[index].status}");
  //
  //         return _listItemOrderPickingItem(item);
  //       });
  // }

  Widget _listItemOrderItem(od.DealerOrderDetails? item) {
    return InkWell(
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
        margin: EdgeInsets.symmetric(vertical: 8),
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
              children: [
                Expanded(
                  child: '${item?.productName}'.textWidget(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontFamilyPoppins,
                    fontSize: fontSizeMedium,
                    color: AppColors.colorLightGrey,
                  ),
                ),
                (_orderProviderAd
                            .getDistributorOrderByIdModel
                            ?.data
                            ?.totOrderStatus ??
                        "")
                    .textWidget(
                      fontWeight: FontWeight.w400,
                      fontFamily: AppConstants.fontFamilyPoppins,
                      fontSize: 13,
                      color: AppColors.colorWhite,
                    ),
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
                            text: '${item?.quantity?.toInt()}',
                            style: const TextStyle(
                              color: AppColors.colorWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      2.toSizedBoxHeight,
                      ' | Side :'.richTextView(
                        textSpanList: [
                          const WidgetSpan(child: SizedBox(width: 3)),
                          TextSpan(
                            text: item?.size ?? 'N/A',
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
            5.toSizedBoxHeight,
            Row(
              children: [
                Expanded(
                  child: (item?.material ?? 'N/A').textWidget(
                    fontWeight: FontWeight.w400,
                    fontFamily: AppConstants.fontFamilyRoboto,
                    fontSize: 13,
                    color: AppColors.colorWhite,
                  ),
                ),
                '${AppConstants.currencySymbol}${item?.price}'.textWidget(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamilyRoboto,
                  fontSize: fontSizeNormal,
                  color: AppColors.colorLightGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _listItemSalesOrderItem(slOd.SalesOrderProductList? item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.colorLightGrey,
      ),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: InkWell(
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
                children: [
                  Expanded(
                    child: '${item?.productName}'.textWidget(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontFamilyPoppins,
                      fontSize: fontSizeMedium,
                      color: AppColors.colorLightGrey,
                    ),
                  ),

                  'Delivered Qty :'.richTextView(
                    textSpanList: [
                      const WidgetSpan(child: SizedBox(width: 3)),
                      TextSpan(
                        text: '${item?.quantity?.toInt()}',
                        style: const TextStyle(
                          color: AppColors.colorWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                              text: '${item?.quantity?.toInt()}',
                              style: const TextStyle(
                                color: AppColors.colorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        2.toSizedBoxHeight,
                        ' | Side :'.richTextView(
                          textSpanList: [
                            const WidgetSpan(child: SizedBox(width: 3)),
                            TextSpan(
                              text: item?.size ?? 'N/A',
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
              5.toSizedBoxHeight,
              Row(
                children: [
                  Expanded(
                    child: (item?.material ?? 'N/A').textWidget(
                      fontWeight: FontWeight.w400,
                      fontFamily: AppConstants.fontFamilyRoboto,
                      fontSize: 13,
                      color: AppColors.colorWhite,
                    ),
                  ),
                  '${AppConstants.currencySymbol}${item?.price}'.textWidget(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontFamilyRoboto,
                    fontSize: fontSizeNormal,
                    color: AppColors.colorLightGrey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget _listItemSalesOrderItem(slOd.SalesOrderProductList? item) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       color: AppColors.colorLightGrey,
  //     ),
  //     margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
  //     child: Slidable(
  //       key: UniqueKey(),
  //       endActionPane: ActionPane(
  //         extentRatio: 0.5,
  //         dragDismissible: false,
  //         motion: const ScrollMotion(),
  //         dismissible: DismissiblePane(
  //           dismissalDuration: const Duration(milliseconds: 1000),
  //           dismissThreshold: 0.1,
  //           onDismissed: () {},
  //         ),
  //         children: [
  //           CustomSlidableAction(
  //             padding: EdgeInsets.only(top: 0, bottom: 0),
  //             onPressed: (context) {
  //               _orderProviderAd.qtyController.clear();
  //               _orderProviderAd.qtyController.text =
  //                   (item?.quantity ?? 1).toString();
  //               _showAlertDialogUpdateQuantity(item?.productSKUID);
  //             },
  //             borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(0),
  //               bottomRight: Radius.circular(0),
  //             ),
  //             // backgroundColor: AppColors.colorLightGrey,
  //             foregroundColor: AppColors.colorPrimary,
  //             backgroundColor: AppColors.colorLightGrey,
  //             child: Icon(Icons.edit, size: 26, color: Colors.orange),
  //           ),
  //           4.toSizedBoxWidth,
  //           CustomSlidableAction(
  //             padding: EdgeInsets.only(top: 0, bottom: 0),
  //             onPressed: (context) {
  //               AppUtils.showCustomTwoBtnDialog(
  //                 ctx: context,
  //                 dialogBtnTextRight: "Yes",
  //                 dialogBtnTextLeft: "No",
  //                 dialogMessage:
  //                     "Are you sure you want to remove this product From Order?",
  //                 dialogTitle: "Alert",
  //                 dialogBtnRightFnc: () async {
  //                   if (item?.productSKUID == null) {
  //                     return;
  //                   }
  //                   _orderProviderAd.removeProductFromLocal(
  //                     item?.productSKUID ?? "",
  //                   );
  //                 },
  //               );
  //             },
  //             borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(12),
  //               bottomRight: Radius.circular(12),
  //             ),
  //             // backgroundColor: AppColors.colorLightGrey,
  //             foregroundColor: AppColors.colorPrimary,
  //             backgroundColor: AppColors.colorLightGrey,
  //
  //             child: Icon(Icons.delete, size: 26, color: Colors.red),
  //           ),
  //         ],
  //       ),
  //       child: InkWell(
  //         onTap: () {
  //           // if (_orderCubit.orderDetails?.state == OrderStatusType.draft) {
  //           // if (_orderCubit.isAllowUpdateOrder) {
  //           //   _orderCubit.qtyEditController.clear();
  //           //   _orderCubit.qtyEditController.text =
  //           //       (item?.quantity ?? 1).toString();
  //           //   _showAlertDialogUpdateQuantity(item?.id);
  //           // }
  //         },
  //         child: Container(
  //           // margin: EdgeInsets.symmetric(vertical: 8),
  //           decoration: BoxDecoration(
  //             color: AppColors.colorPrimary,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: Colors.white.withOpacity(0.08)),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: AppColors.colorSecondary.withOpacity(0.25),
  //                 blurRadius: 0,
  //                 spreadRadius: 0.0,
  //                 offset: const Offset(0, 2),
  //               ),
  //               // BoxShadow(
  //               //   color: Colors.white.withOpacity(0.6),
  //               //   blurRadius: 30,
  //               //   offset: const Offset(0, 0),
  //               // ),
  //             ],
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //           width: double.infinity,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: '${item?.productName}'.textWidget(
  //                       fontWeight: FontWeight.bold,
  //                       fontFamily: AppConstants.fontFamilyPoppins,
  //                       fontSize: fontSizeMedium,
  //                       color: AppColors.colorLightGrey,
  //                     ),
  //                   ),
  //                   (_orderProviderAd
  //                               .getDistributorOrderByIdModel
  //                               ?.data
  //                               ?.totOrderStatus ??
  //                           "")
  //                       .textWidget(
  //                         fontWeight: FontWeight.w400,
  //                         fontFamily: AppConstants.fontFamilyPoppins,
  //                         fontSize: 13,
  //                         color: AppColors.colorWhite,
  //                       ),
  //                 ],
  //               ),
  //               5.toSizedBoxHeight,
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Expanded(
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         2.toSizedBoxHeight,
  //                         'Qty :'.richTextView(
  //                           textSpanList: [
  //                             const WidgetSpan(child: SizedBox(width: 3)),
  //                             TextSpan(
  //                               text: '${item?.quantity?.toInt()}',
  //                               style: const TextStyle(
  //                                 color: AppColors.colorWhite,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         2.toSizedBoxHeight,
  //                         ' | Side :'.richTextView(
  //                           textSpanList: [
  //                             const WidgetSpan(child: SizedBox(width: 3)),
  //                             TextSpan(
  //                               text: item?.size ?? 'N/A',
  //                               style: const TextStyle(
  //                                 color: AppColors.colorWhite,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               5.toSizedBoxHeight,
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: (item?.material ?? 'N/A').textWidget(
  //                       fontWeight: FontWeight.w400,
  //                       fontFamily: AppConstants.fontFamilyRoboto,
  //                       fontSize: 13,
  //                       color: AppColors.colorWhite,
  //                     ),
  //                   ),
  //                   '${AppConstants.currencySymbol}${item?.price}'.textWidget(
  //                     fontWeight: FontWeight.bold,
  //                     fontFamily: AppConstants.fontFamilyRoboto,
  //                     fontSize: fontSizeNormal,
  //                     color: AppColors.colorLightGrey,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showAlertDialogUpdateQuantity(String? productSkuId) {
    showAlertDialog(
      context: context,
      title: "Quantity Update",
      isTitleCenter: true,
      widget: UpdateQuantityDialogWidget(
        qtyTextEditingController: _orderProviderAd.qtyController,
        positiveCallBack: (val) {
          _orderProviderAd.updateProductFromLocal(
            productSkuId: productSkuId,
            newQuantity: int.parse(_orderProviderAd.qtyController.text),
          );
        },
      ),
    );
  }
}
