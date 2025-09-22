import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/presentation/order_list_screen.dart';
import 'package:sales_app_redesign/features/admin/order/provider/order_provider_ad.dart';

import '../../../../core/constants/app_size_constants.dart' show appBarSize;

class OrderScreenAd extends StatefulWidget {
  const OrderScreenAd({super.key});

  @override
  State<OrderScreenAd> createState() => _OrderScreenAdState();
}

class _OrderScreenAdState extends State<OrderScreenAd> {
  // late OrderProviderAd _orderProviderAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _orderProviderAd = Provider.of<OrderProviderAd>(context, listen: false);
    // _orderProviderAd.apiCallGetMyOrder()
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              centerTitle: false,
              title: "ORDER",
              isBackVisible: false,
              isAdmin: true,
              isCartVisible: true,
            ),
          ),
          body: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderListScreen(title: "My Order",isSalesOrderScreen: false,),));
                },
                child: AppUtils.commonContainer(
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                  height: 60,
                  width: double.infinity,
                  // padding: EdgeInsets.all(20),
                  decoration: AppUtils.commonGradientBoxDecoration(
                    borderRadius: 8,

                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      'My Order'.textWidget(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.colorWhite
                      )
                    ],
                  )
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderListScreen(title: "Sales Order",isSalesOrderScreen: true,),));
                },
                child: AppUtils.commonContainer(
                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    height: 60,
                    width: double.infinity,
                    // padding: EdgeInsets.all(20),
                    decoration: AppUtils.commonGradientBoxDecoration(
                      borderRadius: 8,

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        'Sales Order'.textWidget(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.colorWhite
                        )
                      ],
                    )
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}
