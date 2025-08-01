import 'package:action_slider/action_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common/no_data_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/notes_dialog_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/update_quantity_dialog_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_all_sales_man_order_model.dart' as od;
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_detail_order_by_id_model.dart'
    as od;
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_detail_order_by_id_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart'
    as slOd;
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';
import 'package:sales_app_redesign/features/admin/order/provider/order_provider_ad.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_listing_page.dart';
import 'package:sales_app_redesign/features/sales/sales_order/sales_order_provider/SalesOrderProvider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SalesOrderOrderDetailsScreen extends StatefulWidget {
  const SalesOrderOrderDetailsScreen({
    super.key,
    this.orderId,
  });

  final String? orderId;

  @override
  State<SalesOrderOrderDetailsScreen> createState() => _SalesOrderOrderDetailsScreenState();
}

class _SalesOrderOrderDetailsScreenState extends State<SalesOrderOrderDetailsScreen> {
  late SalesOrderProvider _orderProviderAd;

  @override
  void initState() {
    super.initState();
    _orderProviderAd = Provider.of<SalesOrderProvider>(context, listen: false);
    _orderProviderAd.apiCallAllSalesManOrderDetailById(widget.orderId);

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
                              _salesOrderInfoView(
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

                              'Product List'.textWidget(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeExtraLarge,
                                color: AppColors.colorWhite,
                              ),
                              5.toSizedBoxHeight,
                              _orderList(
                                orderDetails
                                    .getAllSalesmanOrderByIdModel
                                    ?.data,
                                // _orderProviderAd.salesOrderProductList,
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
          ),
        );
      },
    );
  }


  Widget _orderList(slOd.Data? orderData) {
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



  Widget _listItemSalesOrderItem(slOd.SalesOrderProductList? item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.colorLightGrey,
      ),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: InkWell(
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
                    flex: 3,
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
                        text: '${item?.deliveredQuantity?.toInt()}',
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

}
