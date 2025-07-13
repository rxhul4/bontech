import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_all_sales_man_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/presentation/order_detail_screen.dart';

class CommonSalesOrderHistoryItemWidget extends StatefulWidget {
  const CommonSalesOrderHistoryItemWidget({
    super.key,
    this.index,
    this.item,
    this.callBack,
    required this.isSalesSide
  });

  final int? index;
  final SaleOrderListItem? item;
  final Function? callBack;
  final bool isSalesSide;

  @override
  State<CommonSalesOrderHistoryItemWidget> createState() =>
      _CommonSalesOrderHistoryItemWidgetState();
}

class _CommonSalesOrderHistoryItemWidgetState
    extends State<CommonSalesOrderHistoryItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: widget.item?.salesmanOrderId,isAdmin: false,isSalesSide: widget.isSalesSide,),)).then((value) {
            if(widget.callBack != null){
              widget.callBack!();
            }

          },);
        },
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.colorPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: AppColors.colorSecondary.withOpacity(0.25),
                blurRadius: 0,
                spreadRadius: 0.0,
                offset: const Offset(0, 1.5),
              ),
              // BoxShadow(
              //   color: Colors.black.withOpacity(0.6),
              //   blurRadius: 30,
              //   offset: const Offset(0, 12),
              // ),
            ],
          ),
          padding:
          const EdgeInsets.only(left: 12, top: 12, bottom: 10, right: 12),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: 'Order #${widget.item?.trackingNo ?? ''}'.textWidget(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorLightGrey,
                          fontFamily: AppConstants.fontFamilyPoppins),
                    ),
                    10.toSizedBoxWidth,
                    "${AppConstants.currencySymbol}${(widget.item?.totalAmount ?? "0.0")}"
                        .textWidget(
                        color: AppColors.colorWhite,
                        fontSize: 14,
                        fontFamily: AppConstants.fontFamilyRoboto,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                10.toSizedBoxHeight,
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: (widget.item?.totOrderStatus ?? '').textWidget(
                            color: AppColors.colorWhite,
                            fontSize: 12,
                            fontFamily: AppConstants.fontFamilyPoppins,
                            fontWeight: FontWeight.w500),
                      ),
                      AppUtils.getDate(
                          date: "${widget.item?.orderDate}", format: "MMM dd,yyyy")
                          .textWidget(
                          color: AppColors.colorLightGrey,
                          fontSize: 12,
                          fontFamily: AppConstants.fontFamilyPoppins,
                          fontWeight: FontWeight.w500)
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
