import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/glow_arch_class.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_category.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_viewtype.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/produst_detail_screen.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/genral/search/presentation/search_delegate.dart';

class ProductListingScreen extends StatefulWidget {
  String? categoryName;
  String? categoryId;
  String? totViewTypeId;
  bool? isAdmin;
  bool? isFromCategory;
  bool? isFromOrder;
  bool isBackButtonAvailable;

  ProductListingScreen({
    super.key,
    this.categoryName,
    this.categoryId,
    this.totViewTypeId,
    this.isAdmin,
    this.isFromCategory,
    this.isFromOrder,
    required this.isBackButtonAvailable
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late ProductProvider _productProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.resetProductData();
    widget.isFromCategory == true
        ? _productProvider.fetchProductListForCategory(widget.categoryId)
        : _productProvider.fetchProductListUsingTotId(widget.totViewTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return AppScaffold(
          bgColor: AppColors.colorPrimary,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(
              onBackPressed: (){
                widget.isFromOrder == true ?  Navigator.pop(context,true) :  Navigator.pop(context,false);
              },
              onPressedSearch: () {
                widget.isFromCategory == true
                    ? showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(
                        categoryId: widget.categoryId,
                      ),
                    )
                    : showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(),
                    );
              },
              isSearchVisible: true,
              isCartVisible: true,
              isBackVisible: widget.isBackButtonAvailable,
              title: widget.categoryName,
            ),
          ),
          body: Column(
            children: [
              10.toSizedBoxHeight,
              widget.isFromCategory == true
                  ? Expanded(
                    child:
                        NotificationListener(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !productProvider.isLoading) {
                             productProvider.fetchProductListForCategory(widget.categoryId);
                            }
                            return false;
                          },
                          child: productProvider.isLoading
                              ? CircleLoadingIndicatorWidget()
                              : productProvider.categoryProduct == [] || productProvider.categoryProduct.isEmpty
                              ? AppUtils.noDataWidget()
                              : GridView.builder(
                            cacheExtent: 1000,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                itemCount: productProvider.categoryProduct.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      mainAxisExtent: 270,
                                    ),
                                itemBuilder: (context, index) {

                                  return _listItemForCategory(
                                    index: index,
                                    item: productProvider.categoryProduct[index],
                                  );
                                },
                              ),
                        ),
                  )
                  : Expanded(
                    child:
                        NotificationListener(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !productProvider.isLoading) {
                              productProvider.fetchProductListForCategory(widget.totViewTypeId);
                            }
                            return false;
                          },
                          child: productProvider.isFetching
                              ? CircleLoadingIndicatorWidget()
                              : productProvider.totProduct.isEmpty || productProvider.totProduct == []
                              ? AppUtils.noDataWidget()
                              : GridView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                itemCount: productProvider.totProduct.length,
                                shrinkWrap: false,
                                addAutomaticKeepAlives: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      mainAxisExtent: 270,
                                    ),
                                itemBuilder: (context, index) {
                                  return _listItemForViewType(
                                    index: index,
                                    item: productProvider.totProduct[index],
                                  );
                                },
                              ),
                        ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _listItemForCategory({
    required int index,
    required ListItem? item,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailScreen(productId: item?.productId),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            // height: 500,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorSecondary.withOpacity(0.25),
                  offset: const Offset(0, 1.5),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.max, // Allow dynamic height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child:  CachedNetworkImage(imageUrl: item?.imagePath ?? "", fit: BoxFit.cover,placeholder: (context, url) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorSecondary),
                        strokeWidth: 2,
                      );
                    },fadeInDuration: Duration.zero,memCacheHeight: 400,)
                  ),
                ),
                const SizedBox(height: 12),
                (item?.productName ?? 'N/A').textWidget(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamilyPoppins,
                  fontSize: 14,
                  color: AppColors.colorLightGrey,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 145,
              height: 145,
              child: CustomPaint(painter: GlowingArcPainter()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItemForViewType({
    required int index,
    required ProductList? item,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailScreen(productId: item?.productId),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            // height: 500,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorSecondary.withOpacity(0.25),
                  offset: const Offset(0, 1.5),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.max, // Allow dynamic height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: (item?.imagePath ?? '').toNetWorkImage(
                      height: 170,
                      width: 170,
                      fit: BoxFit.cover,
                      borderRadius: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                (item?.productName ?? 'N/A').textWidget(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamilyPoppins,
                  fontSize: 14,
                  color: AppColors.colorLightGrey,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 145,
              height: 145,
              child: CustomPaint(painter: GlowingArcPainter()),
            ),
          ),
        ],
      ),
    );
  }
}
