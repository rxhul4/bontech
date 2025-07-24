
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_listing_page.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/produst_detail_screen.dart';
import 'package:sales_app_redesign/features/sales/home/provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider _homeProviderAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeProviderAd = Provider.of<HomeProvider>(context, listen: false);
    _homeProviderAd.apiCallGetHomeView(context);
  }

  late List<Widget>? imageSliders =
      _homeProviderAd.bannerList
          ?.map(
            (item) => AppUtils.commonContainer(
              margin: AppUtils.edgeInsetsOnly(
                top: 5,
                bottom: 5,
                left: 10,
                right: 10,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Stack(
                  children: <Widget>[
                    // Image.network(
                    //   item.bannerImage ?? '',
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    // ),
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      // height: 65,
                      // width: 65,
                      imageUrl: item.bannerImage ?? '',
                      imageBuilder:
                          (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      placeholder:
                          (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.colorSecondary,
                              strokeWidth: 1.5,
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Center(
                            child: Icon(
                              Icons.image_rounded,
                              size: 40,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      color: AppColors.colorMainBlack.withOpacity(0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppUtils.commonTextWidget(
                                  text: item.bannerTitle ?? '',
                                  textColor: AppColors.colorWhite,
                                  textAlign: TextAlign.left,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                                AppUtils.commonTextWidget(
                                  text: item.bannerDescription ?? '',
                                  textColor: AppColors.colorWhite,
                                  textAlign: TextAlign.left,
                                  fontSize: 12,
                                  fontFamily: AppConstants.fontFamilyPoppins,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    // final homeProvider = Provider.of<HomeProviderAd>(context, listen: false);
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              isAdmin: false,
              centerTitle: false,
              title: "HOME",
              isBackVisible: false,
              isCartVisible: true,
            ),
          ),
          bgColor: AppColors.colorPrimary,
          body:
              homeProvider.isFetching
                  ? Center(child: CircleLoadingIndicatorWidget())
                  : homeProvider.getHomeModel == null
                  ? AppUtils.noDataWidget()
                  : ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    children: [
                      _imageCarousal(homeProvider),
                      _categoryListWidget(homeProvider),
                      _trendingProductList(homeProvider),
                      _bestsellerProductList(homeProvider),
                      _newArrivalProductList(homeProvider),
                    ],
                  ),
        );
      },
    );
  }

  Widget _imageCarousal(HomeProvider homeProvider) {
    return FlutterCarousel(
      items: imageSliders,
      options: FlutterCarouselOptions(
        showIndicator: false,
        slideIndicator: CircularSlideIndicator(
          slideIndicatorOptions: SlideIndicatorOptions(
            enableAnimation: true,

            currentIndicatorColor: AppColors.colorSecondary,
            indicatorRadius: 6,
            alignment: Alignment.bottomCenter,

            // haloPadding: EdgeInsets.zero
            // padding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
        autoPlay: false,
        indicatorMargin: 0,
        initialPage: _homeProviderAd.currentIndex,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,

        viewportFraction: 1,
        onPageChanged: (index, reason) {
          _homeProviderAd.changeIndex(index);
        },
      ),
    );
  }

  Widget _categoryListWidget(HomeProvider homeProvider) {
    return AppUtils.commonContainer(
      height: 100,
      // color: AppColors.colorWhite,
      margin: AppUtils.edgeInsetsOnly(left: 10, top: 10),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _homeProviderAd.categoryItemList?.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: AppUtils.edgeInsetsOnly(right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppUtils.commonInkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductListingScreen(
                                    isBackButtonAvailable: true,
                                    isFromCategory: true,

                                    categoryId:
                                        homeProvider
                                            .getHomeModel
                                            ?.data
                                            ?.categories?[index]
                                            .categoryId,
                                    categoryName:
                                        homeProvider
                                            .getHomeModel
                                            ?.data
                                            ?.categories?[index]
                                            .categoryName ??
                                        '',
                                  ),
                            ),
                          );
                        },
                        child: AppUtils.commonContainer(
                          height: 60,
                          width: 60,
                          // padding: AppUtils.edgeInsetsAll(allPadding: 20),
                          decoration: AppUtils.commonBoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.colorWhite,
                              width: 0.5,
                            ),
                            color: AppColors.colorWhite,
                          ),
                          child: Stack(
                            children: [
                              AppUtils.commonContainer(
                                decoration: AppUtils.commonBoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.colorWhite,
                                ),
                              ),
                              AppUtils.commonContainer(
                                padding: AppUtils.edgeInsetsAll(allPadding: 3),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        _homeProviderAd
                                            .categoryItemList?[index]
                                            .categoryImage ??
                                        '',
                                    imageBuilder:
                                        (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.colorPrimary,
                                            strokeWidth: 1.5,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => const Center(
                                          child: Icon(
                                            Icons.image_rounded,
                                            size: 34,
                                            color: AppColors.colorPrimary,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppUtils.commonContainer(
                        child: AppUtils.commonTextWidget(
                          margin: AppUtils.edgeInsetsOnly(top: 5),
                          text:
                              _homeProviderAd
                                  .categoryItemList?[index]
                                  .categoryName ??
                              '',
                          textColor: AppColors.colorWhite,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _trendingProductList(HomeProvider homeProvider) {
    return (homeProvider.trendingProductList?.length ?? 0) <= 0
        ? AppUtils.commonSizedBox()
        : Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppUtils.commonTextWidget(
              text: "TRENDING PRODUCTS",
              fontSize: 16,
              letterSpacing: 0.5,
              textColor: AppColors.colorLightGrey,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.left,
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.colorLightGrey,
              ),
              child: Row(
                children: [
                  AppUtils.commonTextWidget(
                    margin: AppUtils.edgeInsetsOnly(right: 5),
                    text: "See all",
                    fontSize: 12,
                    letterSpacing: 0.5,
                    textColor: AppColors.colorLightGrey,
                    fontWeight: FontWeight.w400,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.colorLightGrey,
                    size: 10,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProductListingScreen(
                          isBackButtonAvailable: true,
                          isFromCategory: false,

                          totViewTypeId:
                              _homeProviderAd
                                  .getHomeModel
                                  ?.data
                                  ?.products
                                  ?.trandingId,

                          categoryName: "Trending",
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        AppUtils.commonContainer(
              height: 200,
              // color: AppColors.colorWhite,
              margin: AppUtils.edgeInsetsOnly(left: 10, top: 10),
              width: double.infinity,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: homeProvider.trendingProductList?.length,
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: AppUtils.edgeInsetsOnly(right: 20),
                    child: SizedBox(
                      // color: Colors.red,
                      height: 140,
                      width: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppUtils.commonInkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductDetailScreen(
                                        isFromOrder: false,
                                        productId:
                                            _homeProviderAd
                                                .trendingProductList?[index]
                                                .productId
                                                .toString(),
                                      ),
                                ),
                              );
                            },
                            child: AppUtils.commonGlassmorphicContainer(
                              height: 140,
                              width: 140,

                              // padding: AppUtils.edgeInsetsAll(allPadding: 20),
                              // decoration:
                              // AppUtils.commonBoxDecoration(
                              //     shape: BoxShape.rectangle,
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: AppColors
                              //             .colorSecondary
                              //             .withOpacity(0.1),
                              //         spreadRadius: 1,
                              //         blurRadius: 5,
                              //         offset: Offset(0,
                              //             4), // This is the bottom shadow offset
                              //       ),
                              //     ],
                              //     // border: Border.all(
                              //     //     color: AppColors.colorSecondary, width: 0.5),
                              //     borderRadius:
                              //     AppUtils.borderRadiusAll(
                              //         raduis: 12),
                              //     color: AppColors.colorWhite),
                              child: ClipRRect(
                                borderRadius: AppUtils.borderRadiusAll(
                                  raduis: 12,
                                ),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          homeProvider
                                              .trendingProductList?[index]
                                              .imagePath ??
                                          '',
                                      imageBuilder:
                                          (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                      placeholder:
                                          (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.colorPrimary,
                                              strokeWidth: 1.5,
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => const Center(
                                            child: Icon(
                                              Icons.image_rounded,
                                              size: 40,
                                              color: AppColors.colorPrimary,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AppUtils.commonContainer(
                            margin: AppUtils.edgeInsetsOnly(left: 5, right: 5),
                            child: AppUtils.commonTextWidget(
                              margin: AppUtils.edgeInsetsOnly(top: 10),
                              textAlign: TextAlign.left,
                              text:
                                  homeProvider
                                      .trendingProductList?[index]
                                      .productName ??
                                  '',
                              textColor: AppColors.colorText,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }

  Widget _bestsellerProductList(HomeProvider homeProvider) {
    return (homeProvider.bestSellerProductList?.length ?? 0) <= 0
        ? AppUtils.commonSizedBox()
        :  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppUtils.commonTextWidget(
              text: "BESTSELLER PRODUCTS",
              fontSize: 16,
              letterSpacing: 0.5,
              textColor: AppColors.colorLightGrey,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.left,
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.colorLightGrey,
              ),
              child: Row(
                children: [
                  AppUtils.commonTextWidget(
                    margin: AppUtils.edgeInsetsOnly(right: 5),
                    text: "See all",
                    fontSize: 12,
                    letterSpacing: 0.5,
                    textColor: AppColors.colorLightGrey,
                    fontWeight: FontWeight.w400,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.colorLightGrey,
                    size: 10,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProductListingScreen(
                          isBackButtonAvailable: true,
                          isFromCategory: false,

                          totViewTypeId:
                              _homeProviderAd
                                  .getHomeModel
                                  ?.data
                                  ?.products
                                  ?.bestSellerId,
                          categoryName: "Bestseller",
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        AppUtils.commonContainer(
              height: 200,
              // color: AppColors.colorWhite,
              margin: AppUtils.edgeInsetsOnly(left: 10, top: 10),
              width: double.infinity,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: homeProvider.bestSellerProductList?.length,
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: AppUtils.edgeInsetsOnly(right: 20),
                    child: SizedBox(
                      // color: Colors.red,
                      height: 140,
                      width: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppUtils.commonInkWell(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             ProductDetailScreen(
                              //               productId:
                              //               trendingProductList?[
                              //               index]
                              //                   .productId
                              //                   .toString(),
                              //               // imageUrl:
                              //               //     featuredProductList?[index].imagePath,imageName: featuredProductList?[index].productName,
                              //             )));
                            },
                            child: AppUtils.commonGlassmorphicContainer(
                              height: 140,
                              width: 140,

                              // padding: AppUtils.edgeInsetsAll(allPadding: 20),
                              // decoration:
                              // AppUtils.commonBoxDecoration(
                              //     shape: BoxShape.rectangle,
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: AppColors
                              //             .colorSecondary
                              //             .withOpacity(0.1),
                              //         spreadRadius: 1,
                              //         blurRadius: 5,
                              //         offset: Offset(0,
                              //             4), // This is the bottom shadow offset
                              //       ),
                              //     ],
                              //     // border: Border.all(
                              //     //     color: AppColors.colorSecondary, width: 0.5),
                              //     borderRadius:
                              //     AppUtils.borderRadiusAll(
                              //         raduis: 12),
                              //     color: AppColors.colorWhite),
                              child: ClipRRect(
                                borderRadius: AppUtils.borderRadiusAll(
                                  raduis: 12,
                                ),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          homeProvider
                                              .bestSellerProductList?[index]
                                              .imagePath ??
                                          '',
                                      imageBuilder:
                                          (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                      placeholder:
                                          (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.colorPrimary,
                                              strokeWidth: 1.5,
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => const Center(
                                            child: Icon(
                                              Icons.image_rounded,
                                              size: 40,
                                              color: AppColors.colorPrimary,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AppUtils.commonContainer(
                            margin: AppUtils.edgeInsetsOnly(left: 5, right: 5),
                            child: AppUtils.commonTextWidget(
                              margin: AppUtils.edgeInsetsOnly(top: 10),
                              textAlign: TextAlign.left,
                              text:
                                  homeProvider
                                      .bestSellerProductList?[index]
                                      .productName ??
                                  '',
                              textColor: AppColors.colorText,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }

  Widget _newArrivalProductList(HomeProvider homeProvider) {
    return (homeProvider.newArrivalProductList?.length ?? 0) <= 0
        ? AppUtils.commonSizedBox()
        : Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppUtils.commonTextWidget(
              text: "NEW ARRIVAL PRODUCTS",
              fontSize: 16,
              letterSpacing: 0.5,
              textColor: AppColors.colorLightGrey,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.left,
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.colorLightGrey,
              ),
              child: Row(
                children: [
                  AppUtils.commonTextWidget(
                    margin: AppUtils.edgeInsetsOnly(right: 5),
                    text: "See all",
                    fontSize: 12,
                    letterSpacing: 0.5,
                    textColor: AppColors.colorLightGrey,
                    fontWeight: FontWeight.w400,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.colorLightGrey,
                    size: 10,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProductListingScreen(
                          isBackButtonAvailable: true,
                          isFromCategory: false,
                          totViewTypeId:
                              _homeProviderAd
                                  .getHomeModel
                                  ?.data
                                  ?.products
                                  ?.newArrivalId,
                          categoryName: "New Arrival",
                        ),
                  ),
                );
              },
            ),
          ],
        ), GridView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: homeProvider.newArrivalProductList?.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                mainAxisExtent: 230,

                // childAspectRatio: 0.75
              ),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppUtils.commonInkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     // MaterialPageRoute(
                        //     //     builder: (context) =>
                        //     //         ProductDetailScreen(
                        //     //           productId:
                        //     //           newArrivalProductList?[
                        //     //           index]
                        //     //               .productId
                        //     //               .toString(),
                        //     //           // imageUrl:
                        //     //           //     newArrivalProductList?[index].imagePath,
                        //     //         )));
                      },
                      child: AppUtils.commonContainer(
                        constraints: BoxConstraints(
                          maxHeight: 180,
                          minHeight: 150,
                        ),
                        decoration: AppUtils.commonBoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.colorSecondary.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(
                                0,
                                4,
                              ), // This is the bottom shadow offset
                            ),
                          ],
                          // border: Border.all(
                          //     color: AppColors.colorDarkGrey, width: 0.5),
                          borderRadius: AppUtils.borderRadiusAll(raduis: 12),
                          color: AppColors.colorWhite,
                        ),
                        child: ClipRRect(
                          borderRadius: AppUtils.borderRadiusAll(raduis: 12),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    homeProvider
                                        .newArrivalProductList?[index]
                                        .imagePath ??
                                    '',
                                imageBuilder:
                                    (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.colorPrimary,
                                        strokeWidth: 1.5,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => const Center(
                                      child: Icon(
                                        Icons.image_rounded,
                                        size: 40,
                                        color: AppColors.colorPrimary,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AppUtils.commonTextWidget(
                      margin: AppUtils.edgeInsetsOnly(
                        right: 5,
                        left: 5,
                        top: 10,
                      ),
                      text:
                          homeProvider
                              .newArrivalProductList?[index]
                              .productName ??
                          '',
                      fontSize: 12,
                      letterSpacing: 0.5,
                      textColor: AppColors.colorText,
                      fontWeight: FontWeight.w700,
                    ),
                    // Padding(
                    //   padding: AppUtils.edgeInsetsOnly(right: 5, left: 5, top: 2),
                    //   child: RatingBarIndicator(
                    //       rating: 2.5,
                    //       itemCount: 5,
                    //       itemSize: 12,
                    //       unratedColor: AppColors.colorLightGrey,
                    //       itemBuilder: (context, _) => const Icon(
                    //             Icons.star,
                    //             color: AppColors.colorPrimary,
                    //           )),
                    // ),
                  ],
                );
              },
            ),
      ],
    );
  }
}
