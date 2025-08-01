import 'package:flutter/cupertino.dart' show EdgeInsets;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/glow_arch_class.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/produst_detail_screen.dart';
import 'package:sales_app_redesign/features/genral/search/provider/search_provider.dart';

import '../model/search_model.dart';

class ProductSearchDelegate extends SearchDelegate {
  String? categoryId;

  ProductSearchDelegate({this.categoryId});

  bool _hasSearched = false;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        backgroundColor: AppColors.colorPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white60),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: AppConstants.fontFamilyPoppins,
        ),
      ),
    );
  }

  @override
  void showResults(BuildContext context) {
    final productProvider = Provider.of<SearchProvider>(context, listen: false);
    _hasSearched = true;
    if(categoryId == null){
      productProvider.apiCallSearch(search: query, categoryId:  null);
    }
    else{
      productProvider.apiCallSearch(search: query, categoryId:  categoryId);
    }
    super.showResults(context);
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: AppUtils.commonGradientBoxDecoration(),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _hasSearched = false;
          Provider.of<SearchProvider>(context, listen: false).clearSearchResults();
        },
      )
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: AppColors.colorPrimary,
      child: Center(
        child: Text(
          'Search for products',
          style: TextStyle(color: Colors.white60),
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productProvider = Provider.of<SearchProvider>(context);

    if (!_hasSearched) {
      return Container(color: AppColors.colorPrimary,child: Center(child: AppUtils.noDataWidget()));
    }

    if (productProvider.isLoading) {
      return Container(color: AppColors.colorPrimary,child: const CircleLoadingIndicatorWidget());
    }

    final items = productProvider.searchModel?.data?.products;

    if (items == null || items.isEmpty) {
      return Container(color: AppColors.colorPrimary,child: Center(child: AppUtils.noDataWidget()));
    }

    return _buildResultsList(context, items);
  }

  Widget _buildResultsList(BuildContext context, List<Products> items) {
    return Container(
       color: AppColors.colorPrimary,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 270,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(productId: item.productId),
                ),
              );
            },
            child: _buildProductCard(item),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Products item) {
    return Stack(
      children: [
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: (item.imagePath ?? '').toNetWorkImage(
                  height: 170,
                  width: 170,
                  fit: BoxFit.cover,
                  borderRadius: 10,
                ),
              ),
              const SizedBox(height: 12),
              (item.productName ?? 'N/A').textWidget(
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
    );
  }
}
