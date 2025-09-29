import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/bulk_qty_update_dialog_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/glass_sheet_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/update_quantity_dialog_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/core/utils/glow_arch_class.dart';
import 'package:sales_app_redesign/features/admin/stock/model/get_distributor_stock.dart';
import 'package:sales_app_redesign/features/admin/stock/provider/stock_provider.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_category.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_viewtype.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/produst_detail_screen.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/genral/search/presentation/search_delegate.dart';

class ProductListScreen extends StatefulWidget {
  String? categoryName;
  String? categoryId;

  ProductListScreen({super.key, this.categoryName, this.categoryId});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late StockProvider _stockProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stockProvider = Provider.of<StockProvider>(context, listen: false);
    _stockProvider.resetProductData();
    _stockProvider.fetchProductListForCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        return AppScaffold(
          bgColor: AppColors.colorPrimary,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(
              onBulkUpdate: (){
                showBulkQtyUpdateDialog();
              },
              isBulUpdateQty:  true,
              onBackPressed: () {
                Navigator.pop(context);
              },
              onPressedSearch: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductSearchDelegate(),));
              },
              isSearchVisible: true,
              isCartVisible: false,
              isBackVisible: true,
              title: widget.categoryName,
            ),
          ),
          body: Stack(
            children: [

              Column(
                children: [
                  10.toSizedBoxHeight,
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                            !stockProvider.isLoading &&
                            stockProvider.hasMore) {
                          stockProvider.fetchProductListForCategory(
                            widget.categoryId,
                          );
                        }
                        return false;
                      },
                      child: stockProvider.isLoading == true ? CircleLoadingIndicatorWidget() : stockProvider.stockProductList.isEmpty
                          ? AppUtils.noDataWidget()
                          : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: stockProvider.stockProductList.length,
                        itemBuilder: (context, index) {
                          return _listItemForCategory(
                            index: index,
                            item: stockProvider.stockProductList[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              /// This handles the "updating stock" loading (e.g. after editing product)
              stockProvider.isAdding
                  ? CircleLoadingIndicatorWidget()
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  Widget _listItemForCategory({int? index, StockList? item}) {
    return Frost(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Slidable(
        // enabled: true,
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
                //
                _stockProvider.thresholdQtyTextEditingController = TextEditingController(text: item?.thresholdQuantity.toString());
                _stockProvider.physicalQtyTextEditingController = TextEditingController(text: item?.currentQuantity.toString());
                showQtyUpdateDialog(item);
              },
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              backgroundColor: AppColors.colorTransparent,
              foregroundColor: AppColors.colorPrimary,
              child: Icon(Icons.edit, size: 26, color: AppColors.colorWhite),
            ),
          ],
        ),
        child: Frost(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: (item?.productName ?? '').textWidget(
                                fontSize: fontSizeLarge,
                                fontWeight: FontWeight.w500,
                                color: AppColors.colorWhite,
                              ),
                            ),
                            5.toSizedBoxWidth,
                            '${item?.productSkuCode}'.textWidget(
                              color: AppColors.colorWhite,
                              fontSize: fontSizeNormal,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppConstants.fontFamilyRoboto,
                            ),
                          ],
                        ),
                        5.toSizedBoxHeight,
                        qtyRow(
                          title: "Current Quantity",
                          value: item?.currentQuantity.toString(),
                        ),
                        5.toSizedBoxHeight,
                        qtyRow(
                          title: "InComing Quantity",
                          value: item?.incomingQuantity.toString(),
                        ),
                        5.toSizedBoxHeight,
                        qtyRow(
                          title: "On Hold Quantity",
                          value: item?.onHoldQuantity.toString(),
                        ),
                        5.toSizedBoxHeight,
                        qtyRow(
                          title: "Threshold Quantity",
                          value: item?.thresholdQuantity.toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }







  showQtyUpdateDialog(StockList? item) {
    showAlertDialog(
      context: context,
      title: "Update Quantity",
      isTitleCenter: true,
      widget: BulkQuantityDialogWidget(
        thresholdQtyTextEditingController: _stockProvider.thresholdQtyTextEditingController,
        physicalQtyTextEditingController: _stockProvider.physicalQtyTextEditingController,
        positiveCallBack: (val) async{
          //apiCallUpdateQtyAndRefreshList
          await _stockProvider.apiCallUpdateDistributorStock(categoryId: widget.categoryId,distributorProductId: item?.distributorStockId);


        },
      ),
    );
  }

  showBulkQtyUpdateDialog() {
    showDialog(
      builder: (context) {
        return UpdateQuantityDialogWidget(
          hintText: "Enter Bulk Qty",
          qtyTextEditingController: _stockProvider.bulkThresholdQtyTextEditingController,
          positiveCallBack: (val) async{
            //apiCallUpdateQtyAndRefreshList
            await _stockProvider.apiCallUpdateBulkQtyByCategoryId(categoryId: widget.categoryId);


          },
        );
      },
      context: context,
    );
  }

  Widget qtyRow({String? title, String? value}) {
    return '$title: '.richTextView(
      fontFamily: AppConstants.fontFamilyPoppins,
      fontSize: fontSizeNormal,
      color: AppColors.colorLightGrey,
      textSpanList: [
        const WidgetSpan(child: SizedBox(width: 2)),
        TextSpan(
          text: value ?? '0',
          style: TextStyle(
            color: AppColors.colorWhite,
            fontSize: fontSizeSmall,
            fontFamily: AppConstants.fontFamilyPoppins,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Widget _listItemForCategory({
  //   required int index,
  //   required ListItem? item,
  // }) {
  //   return InkWell(
  //     borderRadius: BorderRadius.circular(24),
  //     onTap: () {
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder:
  //       //         (context) => ProductDetailScreen(productId: item?.productId,isFromOrder: widget.isFromOrder ?? false,),
  //       //   ),
  //       // );
  //     },
  //     child: Stack(
  //       children: [
  //         Container(
  //           // height: 500,
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  //           decoration: BoxDecoration(
  //             color: AppColors.colorPrimary,
  //             borderRadius: BorderRadius.circular(24),
  //             border: Border.all(color: Colors.white.withOpacity(0.08)),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: AppColors.colorSecondary.withOpacity(0.25),
  //                 offset: const Offset(0, 1.5),
  //               ),
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.6),
  //                 blurRadius: 30,
  //                 offset: const Offset(0, 12),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             // mainAxisSize: MainAxisSize.max, // Allow dynamic height
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 12),
  //               Expanded(
  //                 child: Align(
  //                     alignment: Alignment.center,
  //                     child: CachedNetworkImage(imageUrl: item?.imagePath ?? "",
  //                       fit: BoxFit.cover,
  //                       placeholder: (context, url) {
  //                         return const CircularProgressIndicator(
  //                           valueColor: AlwaysStoppedAnimation<Color>(
  //                               AppColors.colorSecondary),
  //                           strokeWidth: 2,
  //                         );
  //                       },
  //                       fadeInDuration: Duration.zero,
  //                       memCacheHeight: 400,)
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               (item?.productName ?? 'N/A').textWidget(
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: AppConstants.fontFamilyPoppins,
  //                 fontSize: 14,
  //                 color: AppColors.colorLightGrey,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ],
  //           ),
  //         ),
  //         Positioned(
  //           top: 0,
  //           right: 0,
  //           child: SizedBox(
  //             width: 145,
  //             height: 145,
  //             child: CustomPaint(painter: GlowingArcPainter()),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}



