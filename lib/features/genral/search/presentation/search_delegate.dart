import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/product_card.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/produst_detail_screen.dart';
import 'package:sales_app_redesign/features/genral/search/provider/search_provider.dart';

class ProductSearchDelegate extends StatefulWidget {

  String? categoryId;
  ProductSearchDelegate({super.key,this.categoryId});

  @override
  State<ProductSearchDelegate> createState() => _ProductSearchDelegateState();
}

class _ProductSearchDelegateState extends State<ProductSearchDelegate> {

  late SearchProvider _searchProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchProvider = Provider.of<SearchProvider>(context, listen: false);
      _searchProvider.clearListAndSearchModel();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, search, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 80),
            child: SafeArea(
              child: Frost(
                blur: 18,
                opacity: .20,
                radius: 16,
                frame: Frost.outlineBorder(),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: Platform.isAndroid ? 10 : 0),
                child: Row(
                  children: [
                    _backArrow(context),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onSubmitted: (value) {
                          print("API Call");
                          if (search.searchController.text != "") {
                            search.apiCallSearch(categoryId: widget.categoryId ?? null);
                          } else {
                            AppUtils.showSnackBarWithColor(
                              context: context,
                              message:
                                  "Please Enter Product name or Product code to find product",
                            );
                          }
                        },

                        // textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: search.searchController,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppConstants.fontFamilyPoppins,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search Products',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontFamily: AppConstants.fontFamilyPoppins,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              search
                                  .clearListAndSearchModel(); // Or: search.searchController.clear();
                            },
                            child: Icon(Icons.close, color: Colors.white70),
                          ),
                        ),
                        cursorColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child:
                search.isLoading == true
                    ? CircleLoadingIndicatorWidget()
                    : search.filteredProducts.isEmpty
                    ? Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(
                          color: Colors.white54,
                          fontFamily: AppConstants.fontFamilyPoppins,
                        ),
                      ),
                    )
                    : GridView.builder(
                      itemCount: search.filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final product = search.filteredProducts[index];
                        return ProductCard(
                          item: product,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: product.id,),));
                          },
                        ); // Replace with your actual card
                      },
                    ),
          ),
        );
      },
    );
  }

  Widget _backArrow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Frost(
        radius: 12,
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.colorWhite,
          size: 20,
        ),
      ),
    );
  }
}
