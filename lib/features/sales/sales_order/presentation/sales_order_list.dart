import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_all_sales_man_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_distributor_order_model.dart';
import 'package:sales_app_redesign/features/admin/order/presentation/widget/common_order_history_item_widget.dart';
import 'package:sales_app_redesign/features/admin/order/presentation/widget/common_sales_order_item_widget.dart';
import 'package:sales_app_redesign/features/admin/order/provider/order_provider_ad.dart';
import 'package:sales_app_redesign/features/sales/sales_order/sales_order_provider/SalesOrderProvider.dart';

class SalesOrderListScreen extends StatefulWidget {
  String? title;
  bool? isCartVisible;

  SalesOrderListScreen({super.key, this.title,this.isCartVisible});

  @override
  State<SalesOrderListScreen> createState() => _SalesOrderListScreenState();
}

class _SalesOrderListScreenState extends State<SalesOrderListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late SalesOrderProvider _salesOrderProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        _fetchDataBasedOnTab();
      }
    });

    // Initial load
    Future.delayed(Duration.zero, () {
      _fetchDataBasedOnTab();
    });


  }

  void _fetchDataBasedOnTab() {
    final salesOrderProvider = context.read<SalesOrderProvider>();
    salesOrderProvider.resetOrderControllers();
    if (_tabController.index == 0) {
      salesOrderProvider.fetchOrderHistory(true);
    } else {
      salesOrderProvider.fetchOrderHistory(false);
    }
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SalesOrderProvider>(builder: (context, salesOrderProvider, child) {
      return AppScaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, appBarSize),
          child: AppBarWidget(centerTitle: true, title: widget.title,isBackVisible: true,isCartVisible: widget.isCartVisible ?? true,),
        ),
        body: Column(
          children: [
            5.toSizedBoxHeight,
            _tabBar(),
            5.toSizedBoxHeight,
            Expanded(child: _tabView(salesOrderProvider)),
          ],
        ),
      );
    },);
  }

  Widget _tabBar() {
    return AppUtils.commonContainer(
      height: 45,
      width: double.infinity,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: AppUtils.commonBoxDecoration(
        // color: AppColors.colorBg,
        borderRadius: AppUtils.borderRadiusAll(raduis: 5),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 2),
      ),
      child: TabBar(

        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        indicatorWeight: 0,
        dividerHeight: 0,

        isScrollable: false,
        indicatorSize: TabBarIndicatorSize.tab,
        // padding: EdgeInsets.zero,
        // indicatorPadding: EdgeInsets.zero,
        indicatorColor: AppColors.colorPrimary,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        // labelPadding: EdgeInsets.zero,
        indicator: AppUtils.commonGradientBoxDecoration(borderRadius: 5),

        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: [
          Container(
            // margin: const EdgeInsets.only(bottom: 5),
            padding: EdgeInsets.only(top: 7, bottom: 7, right: 14, left: 14),
            // decoration: ,
            child: 'Active'.textWidget(
              fontWeight: FontWeight.bold,
              fontSize: fontSizeNormal,
              color: AppColors.colorLightGrey,
            ),
          ),
          Container(
            // margin: const EdgeInsets.only(bottom: 5),
            padding: EdgeInsets.only(top: 7, bottom: 7, right: 14, left: 14),
            // decoration: BoxDecoration(),
            child: 'Completed'.textWidget(
              fontWeight: FontWeight.bold,
              fontSize: fontSizeNormal,
              textAlign: TextAlign.center,
              color: AppColors.colorLightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabView(SalesOrderProvider salesOrderProvider) {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children:  [
        _buildSalesOrderList(salesOrderProvider.activeSalesOrderList, salesOrderProvider),
        _buildSalesOrderList(salesOrderProvider.completeSalesOrderList, salesOrderProvider),
      ],
    );
  }



  Widget _buildSalesOrderList(
      List<SaleOrderListItem> item,
      SalesOrderProvider salesOrderProvider,
      ) {

    return RefreshIndicator(
      onRefresh: () {
        salesOrderProvider.resetOrderControllers();
        return  _tabController.index == 0
            ? salesOrderProvider.fetchOrderHistory(true)
            : salesOrderProvider.fetchOrderHistory(false);
      },
      child: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !salesOrderProvider.isLoading) {
            _tabController.index == 0
                ? salesOrderProvider.fetchOrderHistory(true)
                : salesOrderProvider.fetchOrderHistory(false);
          }
          return false;
        },
        child: salesOrderProvider.isLoading ? CircleLoadingIndicatorWidget() : item.isEmpty
            ? AppUtils.noDataWidget()
            : ListView.builder(
          itemCount: item.length + (salesOrderProvider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == item.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.colorSecondary,
                      ),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            }
            return CommonOrderHistoryItemWidget(
              index: index,
              salesItem: item[index],
              isAdmin: false,
              callBack: () {
                return _tabController.index == 0
                    ? salesOrderProvider.fetchOrderHistory(true)
                    : salesOrderProvider.fetchOrderHistory(false);
              },
            );
          },
        ),
      ),
    );
  }


  // _buildMySalesOrderList(PagingController<int, SaleOrderListItem> controller) {
  //   return PagedListView(
  //     pagingController: controller,
  //     builderDelegate: PagedChildBuilderDelegate<SaleOrderListItem>(
  //       animateTransitions: true,
  //       firstPageProgressIndicatorBuilder: (context) {
  //         return CircleLoadingIndicatorWidget();
  //       },
  //       noItemsFoundIndicatorBuilder: (context) {
  //         print("--------$SaleOrderListItem");
  //         return AppUtils.noDataWidget();
  //       },
  //
  //       newPageProgressIndicatorBuilder: (context) {
  //         return Padding(
  //           padding: const EdgeInsets.only(top: 30),
  //           child: CircleLoadingIndicatorWidget(),
  //         );
  //       },
  //
  //       itemBuilder: (context, item, index) {
  //         return CommonSalesOrderHistoryItemWidget(
  //           isSalesSide: true,
  //           index: index,
  //           item: item,
  //         );
  //       },
  //     ),
  //   );
  // }

}
