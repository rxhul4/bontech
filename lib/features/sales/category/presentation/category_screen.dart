import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/auth/presentation/login_screen.dart';
import 'package:sales_app_redesign/features/genral/change_password/presentation/chnage_password_screen.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_listing_page.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/sales/category/model/all_category_model.dart';
import 'package:sales_app_redesign/features/sales/category/provider/category_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryModel? allCategoryModel;
  late CategoryProvider _categoryProvider;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryProvider = Provider.of<CategoryProvider>(context,listen: false);
    _categoryProvider.resetCategoryList();
    _categoryProvider.apiCallGetAllCategoryForSalesMan();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(title: "Category", centerTitle: false,isAdmin: false,),
          ),
          // body: Column(
          //   children: [
          //
          //   ],
          // ),
          body: body(categoryProvider),
        );
      },
    );
  }

  Widget body(CategoryProvider categoryProviderAd) {
    return categoryProviderAd.isFetching == true
        ? CircleLoadingIndicatorWidget()
        : categoryProviderAd.categoryList.isEmpty ||
        categoryProviderAd.categoryList == [] ||
        categoryProviderAd.categoryList == null
        ? AppUtils.noDataWidget()
        : ListView(
      shrinkWrap: true,
      children: [

        _searchBar(),
        AppUtils.commonSizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categoryProviderAd.categoryList.length,
          itemBuilder: (context, index) {
            return Frost(

              margin: AppUtils.edgeInsetsOnly(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: AppUtils.commonInkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                          ProductListingScreen(
                            isBackButtonAvailable: true,
                            isFromCategory: true,
                            isAdmin: false,
                            categoryId:
                            categoryProviderAd.categoryList[index].id,
                            categoryName:
                            categoryProviderAd.categoryList[index].name,
                          ),
                    ),
                  );

                },
                child: AppUtils.commonContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: categoryProviderAd.categoryList[index].name
                            .textWidget(
                          color: AppColors.colorWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          categoryProviderAd.categoryList[index].imageUrl,
                          height: 44,
                          width: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(10),
                      //
                      //   child: AppUtils.cacheNetworkImage(
                      //     imageUrl:
                      //         categoryProviderAd.categoryList[index].imageUrl,
                      //     height: 70,
                      //     width: 70,
                      //   ),
                      // ),

                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     (categoryProviderAd.categoryModelAd?.data?[index]
                      //         .categoryName ??
                      //         '').textWidget(
                      //       color: AppColors.colorWhite,
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18,
                      //     )
                      //     // AppUtils.commonTextWidget(
                      //     //     text:
                      //     //         "${postMdl.allCategoryModel?.data?[index]..toString()} Products",
                      //     //     fontSize: 11,
                      //     //     fontFamily: AppConstants.fontFamilyPoppins,
                      //     //     textColor: AppColors.colorPrimary,
                      //     //     fontWeight: FontWeight.w600,
                      //     //     letterSpacing: 0.5),
                      //   ],
                      // ),
                      // AppUtils.commonContainer(
                      //   padding: AppUtils.edgeInsetsOnly(
                      //       left: 20, top: 25, bottom: 25,right: 0),
                      //   height: 80,
                      //   width: 180,
                      //   // child: AppUtils.imageWidget(
                      //   //     fit: BoxFit.fill,
                      //   //     image: imageArray[index],
                      //   //     height: 80,
                      //   //     ctx: context),
                      //   child: CachedNetworkImage(
                      //     // height: 80,
                      //     // width: 100,
                      //     imageUrl: categoryProviderAd.categoryModelAd?.data?[index]
                      //         .categoryImage ??
                      //         '',
                      //     imageBuilder: (context, imageProvider) =>
                      //         Container(
                      //           decoration: BoxDecoration(
                      //             image: DecorationImage(
                      //                 image: imageProvider,
                      //                 fit: BoxFit.scaleDown),
                      //           ),
                      //         ),
                      //     placeholder: (context, url) => Center(
                      //         child: CircularProgressIndicator(
                      //           color: AppColors.colorPrimary,
                      //           strokeWidth: 1.5,
                      //         )),
                      //     errorWidget: (context, url, error) => Icon(
                      //         Icons.image_rounded,
                      //         size: 40,
                      //         color: AppColors.colorPrimary),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  //
  // Widget body(CategoryProvider postMdl) {
  //   return postMdl.isFetching == true ? CircleLoadingIndicatorWidget() : (postMdl.allCategoryModel?.data?.length == 0) || postMdl.allCategoryModel?.data ==null ? AppUtils.noDataWidget() : ListView(
  //     shrinkWrap: true,
  //     children: [
  //       AppUtils.commonSizedBox(height: 10),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         padding: EdgeInsets.zero,
  //         physics: NeverScrollableScrollPhysics(),
  //         itemCount: postMdl.allCategoryModel?.data?.length,
  //         itemBuilder: (context, index) {
  //           return AppUtils.commonContainer(
  //               decoration: BoxDecoration(
  //                 color: AppColors.colorPrimary,
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(
  //                   color: Colors.white.withOpacity(0.08),
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: AppColors.colorPrimary
  //                         .withOpacity(0.25),
  //                     blurRadius: 0,
  //                     spreadRadius: 0.0,
  //                     offset: const Offset(0, 1.5),
  //                   ),
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(
  //                       0.6,
  //                     ),
  //                     blurRadius: 30,
  //                     offset: const Offset(0, 12),
  //                   ),
  //                 ],
  //               ),
  //               margin:
  //               AppUtils.edgeInsetsOnly(left: 10, right: 10, bottom: 10),
  //               child: AppUtils.commonInkWell(
  //                 onTap: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => ProductListingScreen(
  //                             isBackButtonAvailable: true,
  //                           isFromCategory: true,
  //                             isAdmin: false,
  //                             categoryId: postMdl
  //                                 .allCategoryModel?.data?[index].categoryId,
  //                             categoryName: postMdl.allCategoryModel
  //                                 ?.data?[index].categoryName),
  //                       ));
  //                 },
  //                 child: AppUtils.commonContainer(
  //                   child: Padding(
  //                     padding: AppUtils.edgeInsetsOnly(left: 20, right: 0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             (postMdl.allCategoryModel?.data?[index]
  //                                 .categoryName ??
  //                                 '').textWidget(
  //                               color: AppColors.colorWhite,
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 18,
  //                             )
  //                             // AppUtils.commonTextWidget(
  //                             //     text:
  //                             //         "${postMdl.allCategoryModel?.data?[index]..toString()} Products",
  //                             //     fontSize: 11,
  //                             //     fontFamily: AppConstants.fontFamilyPoppins,
  //                             //     textColor: AppColors.colorPrimary,
  //                             //     fontWeight: FontWeight.w600,
  //                             //     letterSpacing: 0.5),
  //                           ],
  //                         ),
  //                         AppUtils.commonContainer(
  //                           padding: AppUtils.edgeInsetsOnly(
  //                               left: 20, top: 25, bottom: 25,right: 0),
  //                           height: 80,
  //                           width: 180,
  //                           // child: AppUtils.imageWidget(
  //                           //     fit: BoxFit.fill,
  //                           //     image: imageArray[index],
  //                           //     height: 80,
  //                           //     ctx: context),
  //                           child: CachedNetworkImage(
  //                             // height: 80,
  //                             // width: 100,
  //                             imageUrl: postMdl.allCategoryModel?.data?[index]
  //                                 .categoryImage ??
  //                                 '',
  //                             imageBuilder: (context, imageProvider) =>
  //                                 Container(
  //                                   decoration: BoxDecoration(
  //                                     image: DecorationImage(
  //                                         image: imageProvider,
  //                                         fit: BoxFit.scaleDown),
  //                                   ),
  //                                 ),
  //                             placeholder: (context, url) => Center(
  //                                 child: CircularProgressIndicator(
  //                                   color: AppColors.colorPrimary,
  //                                   strokeWidth: 1.5,
  //                                 )),
  //                             errorWidget: (context, url, error) => Icon(
  //                                 Icons.image_rounded,
  //                                 size: 40,
  //                                 color: AppColors.colorPrimary),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ));
  //         },
  //       ),
  //     ],
  //   );
  // }


  _searchBar() {
    return Frost(
        margin: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
        radius: 14,
        blur: 16,
        opacity: .10,

        // padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 14),
        child: TextField(
          enableIMEPersonalizedLearning: true,
          textAlignVertical: TextAlignVertical.center,

          onSubmitted: (value) {
            print("Value$value");

            _categoryProvider.onSearch(value);
          },
          controller: _categoryProvider.searchCtrl,
          textAlign: TextAlign.start,
          style:  TextStyle(

              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily : AppConstants.fontFamilyPoppins
          ),
          cursorColor: Colors.white70,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            isDense: true, // makes content tighter

            // contentPadding: const EdgeInsets.symmetric(vertical: 13), // balance vertical alignment

            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white70,
              size: 20,
            ),



            hintText: 'Search categories',
            hintStyle: TextStyle(color: Colors.white60, fontSize: 14,fontFamily: AppConstants.fontFamilyPoppins),
            border: InputBorder.none,
          ),
        )

    );
  }

}
