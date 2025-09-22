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

class OrderListScreen extends StatefulWidget {
  String? title;
  bool? isSalesOrderScreen;
  bool? isCartVisible;

  OrderListScreen({
    super.key,
    this.title,
    this.isSalesOrderScreen,
    this.isCartVisible,
  });

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late OrderProviderAd _orderProviderAd;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _orderProviderAd = Provider.of<OrderProviderAd>(context, listen: false);
    // _orderProviderAd.resetOrderControllers();
    fetchOrders(_tabController.index);
    // _tabController.addListener(() {
    //
    //
    // });
  }

  fetchOrders(int index) {
    _orderProviderAd.resetOrderControllers();
    if (widget.isSalesOrderScreen == true) {
      index == 0
          ? _orderProviderAd.fetchSalesOrderList(true)
          : _orderProviderAd.fetchSalesOrderList(false);
    } else {
      index == 0
          ? _orderProviderAd.fetchMyOrderList(true)
          : _orderProviderAd.fetchMyOrderList(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProviderAd>(
      builder: (context, orderProvider, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(
              centerTitle: true,
              title: widget.title,
              isBackVisible: true,
              isCartVisible: widget.isCartVisible ?? false,
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                5.toSizedBoxHeight,
                _buildTabBar(),
                5.toSizedBoxHeight,
                Expanded(child: _buildTabView(orderProvider)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return AppUtils.commonContainer(
      height: 45,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: AppUtils.commonBoxDecoration(
        borderRadius: AppUtils.borderRadiusAll(raduis: 5),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 2),
      ),
      child: TabBar(
        onTap: (value) {
          fetchOrders(value);
        },
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        indicatorWeight: 0,
        dividerHeight: 0,
        isScrollable: false,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: AppColors.colorPrimary,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        indicator: AppUtils.commonGradientBoxDecoration(borderRadius: 5),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: [_buildTabLabel('Active'), _buildTabLabel('Completed')],
      ),
    );
  }

  Widget _buildTabLabel(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      child: title.textWidget(
        fontWeight: FontWeight.bold,
        fontSize: fontSizeNormal,
        color: AppColors.colorLightGrey,
      ),
    );
  }

  Widget _buildTabView(OrderProviderAd orderProvider) {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        widget.isSalesOrderScreen == false
            ? _buildMyOrderList(orderProvider.myOrderList, orderProvider)
            : _buildSalesOrderList(orderProvider.salesOrderList, orderProvider),
        widget.isSalesOrderScreen == false
            ? _buildMyOrderList(orderProvider.myPastOrderList, orderProvider)
            : _buildSalesOrderList(
              orderProvider.pastSalesOrderList,
              orderProvider,
            ),
      ],
    );
  }

  Widget _buildMyOrderList(List<ListItem> item, OrderProviderAd orderProvider) {
    return RefreshIndicator(
      onRefresh: () {
        orderProvider.resetOrderControllers();
        return _tabController.index == 0
            ? orderProvider.fetchMyOrderList(true)
            : orderProvider.fetchMyOrderList(false);
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              (_tabController.index == 0
                  ? !orderProvider.isLoadingActive &&
                      orderProvider.hasMoreActive
                  : !orderProvider.isLoadingPast &&
                      orderProvider.hasMorePast)) {
            _tabController.index == 0
                ? orderProvider.fetchMyOrderList(true)
                : orderProvider.fetchMyOrderList(false);
          }
          return false;
        },
        child:
            // 👇 show full loader only if list is empty
            (item.isEmpty &&
                    (_tabController.index == 0
                        ? orderProvider.isLoadingActive
                        : orderProvider.isLoadingPast))
                ? const Center(child: CircleLoadingIndicatorWidget())
                : item.isEmpty
                ? AppUtils.noDataWidget()
                : ListView.builder(
                  itemCount:
                      item.length +
                      (_tabController.index == 0
                          ? (orderProvider.hasMoreActive ? 1 : 0)
                          : (orderProvider.hasMorePast ? 1 : 0)),
                  itemBuilder: (context, index) {
                    if (index == item.length) {
                      // 👇 only show bottom loader during pagination
                      return Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                      item: item[index],
                      isAdmin: true,
                      // callBack: () {
                      //   return _tabController.index == 0
                      //       ? orderProvider.fetchMyOrderList(true)
                      //       : orderProvider.fetchMyOrderList(false);
                      // },
                    );
                  },
                ),
      ),
    );
  }

  Widget _buildSalesOrderList(
    List<SaleOrderListItem> item,
    OrderProviderAd orderProvider,
  ) {
    return RefreshIndicator(
      onRefresh: () {
        orderProvider.resetOrderControllers();
        return _tabController.index == 0
            ? orderProvider.fetchSalesOrderList(true)
            : orderProvider.fetchSalesOrderList(false);
      },
      child: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              (_tabController.index == 0
                  ? !orderProvider.isLoadingActive &&
                      orderProvider.hasMoreActive
                  : !orderProvider.isLoadingPast &&
                      orderProvider.hasMorePast)) {
            _tabController.index == 0
                ? orderProvider.fetchSalesOrderList(true)
                : orderProvider.fetchSalesOrderList(false);
          }
          return false;
        },
        child:
            (item.isEmpty &&
                    (_tabController.index == 0
                        ? orderProvider.isLoadingActive
                        : orderProvider.isLoadingPast))
                ? CircleLoadingIndicatorWidget()
                : item.isEmpty
                ? AppUtils.noDataWidget()
                : ListView.builder(
                  itemCount:
                      item.length +
                      (_tabController.index == 0
                          ? (orderProvider.hasMoreActive ? 1 : 0)
                          : (orderProvider.hasMorePast ? 1 : 0)),
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
                        orderProvider.resetOrderControllers();
                        return _tabController.index == 0
                            ? orderProvider.fetchSalesOrderList(true)
                            : orderProvider.fetchSalesOrderList(false);
                      },
                    );
                  },
                ),
      ),
    );
  }
}
