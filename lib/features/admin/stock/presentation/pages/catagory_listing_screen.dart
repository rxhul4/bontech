import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
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

class CategoryListingScreen extends StatefulWidget {
  const CategoryListingScreen({super.key});

  @override
  State<CategoryListingScreen> createState() => _CategoryListingScreenState();
}

class _CategoryListingScreenState extends State<CategoryListingScreen> {
  AllCategoryModel? allCategoryModel;
  late CategoryProvider _categoryProvider;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryProvider = Provider.of<CategoryProvider>(context,listen: false);
    _categoryProvider.apiCallGetAllCategory();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(title: "Category", centerTitle: true,isAdmin: false,isBackVisible: true,isCartVisible: false,),
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

  Widget body(CategoryProvider postMdl) {
    return postMdl.isFetching == true ? CircleLoadingIndicatorWidget() : (postMdl.allCategoryModel?.data?.length == 0) || postMdl.allCategoryModel?.data ==null ? AppUtils.noDataWidget() : ListView(
      shrinkWrap: true,
      children: [
        AppUtils.commonSizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemCount: postMdl.allCategoryModel?.data?.length,
          itemBuilder: (context, index) {
            return AppUtils.commonContainer(
                decoration: BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.colorPrimary
                          .withOpacity(0.25),
                      blurRadius: 0,
                      spreadRadius: 0.0,
                      offset: const Offset(0, 1.5),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.6,
                      ),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                margin:
                AppUtils.edgeInsetsOnly(left: 10, right: 10, bottom: 10),
                child: AppUtils.commonInkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListingScreen(
                              isBackButtonAvailable: true,
                              isFromCategory: true,
                              isAdmin: false,
                              categoryId: postMdl
                                  .allCategoryModel?.data?[index].categoryId,
                              categoryName: postMdl.allCategoryModel
                                  ?.data?[index].categoryName),
                        ));
                  },
                  child: AppUtils.commonContainer(
                    child: Padding(
                      padding: AppUtils.edgeInsetsOnly(left: 20, right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (postMdl.allCategoryModel?.data?[index]
                                  .categoryName ??
                                  '').textWidget(
                                color: AppColors.colorWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              )
                              // AppUtils.commonTextWidget(
                              //     text:
                              //         "${postMdl.allCategoryModel?.data?[index]..toString()} Products",
                              //     fontSize: 11,
                              //     fontFamily: AppConstants.fontFamilyPoppins,
                              //     textColor: AppColors.colorPrimary,
                              //     fontWeight: FontWeight.w600,
                              //     letterSpacing: 0.5),
                            ],
                          ),
                          AppUtils.commonContainer(
                            padding: AppUtils.edgeInsetsOnly(
                                left: 20, top: 25, bottom: 25,right: 0),
                            height: 80,
                            width: 180,
                            // child: AppUtils.imageWidget(
                            //     fit: BoxFit.fill,
                            //     image: imageArray[index],
                            //     height: 80,
                            //     ctx: context),
                            child: CachedNetworkImage(
                              // height: 80,
                              // width: 100,
                              imageUrl: postMdl.allCategoryModel?.data?[index]
                                  .categoryImage ??
                                  '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.scaleDown),
                                    ),
                                  ),
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.colorPrimary,
                                    strokeWidth: 1.5,
                                  )),
                              errorWidget: (context, url, error) => Icon(
                                  Icons.image_rounded,
                                  size: 40,
                                  color: AppColors.colorPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ],
    );
  }

}
