import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/product_card.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/home/provider/home_providerAD.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_listing_page.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/produst_detail_screen.dart';
import 'package:sales_app_redesign/features/genral/search/presentation/search_delegate.dart';

import '../model/get_home_model.dart';

class HomeScreenAd extends StatefulWidget {
  const HomeScreenAd({super.key});

  @override
  State<HomeScreenAd> createState() => _HomeScreenAdState();
}

class _HomeScreenAdState extends State<HomeScreenAd> {
  late HomeProviderAd _homeProviderAd;

  final _bannerCtrl = PageController(viewportFraction: 0.90);
  ValueNotifier<int> _bannerIndex = ValueNotifier(0);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeProviderAd = Provider.of<HomeProviderAd>(context, listen: false);
    _homeProviderAd.apiCallGetHomeView(context);
    _bannerCtrl.addListener(() {
      final page = _bannerCtrl.page ?? 0;
      final i = page.round();
      if (i != _bannerIndex.value) setState(() => _bannerIndex.value = i);
    });
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Frost(

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
                  ],
                ),
              ),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProviderAd>(
      builder: (context, homeProvider, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              isAdmin: true,
              centerTitle: false,
              title: "HOME",
              isBackVisible: false,
              isCartVisible: true,
              isSearchVisible: true,
              onPressedSearch: () {
                showSearch(context: context, delegate: ProductSearchDelegate());
              },
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    children: [
                      _BannerCarousel(
                        items: homeProvider.bannerList ?? [],
                        index: _bannerIndex.value,
                        controller: _bannerCtrl,
                        onTap: (p0) {},
                      ),
                      const SizedBox(height: 20,),
                      // _imageCarousal(homeProvider),
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

  Widget _headerSectionWidget(String? title, Function()? onSee){
    return Row(
      children: [
        Expanded(
          child: AppUtils.commonTextWidget(
            text: title?.toUpperCase() ?? "N/A",
            fontSize: 16,
            letterSpacing: 0.5,
            textColor: AppColors.colorLightGrey,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.left,
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if(onSee != null){
              onSee();
            }

          },
          child: Frost(
            blur: 14,
            opacity: .18,
            radius: 8,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                "See all".textWidget(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorWhite
                ),

                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, size: 16,color: AppColors.colorWhite),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryListWidget(HomeProviderAd homeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        AppUtils.commonTextWidget(
          text: ("Categories").toUpperCase() ?? "N/A",
          fontSize: 16,
          letterSpacing: 0.5,
          textColor: AppColors.colorLightGrey,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.left,
        ),

        SizedBox(
          height: 66,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            scrollDirection: Axis.horizontal,
            itemCount: _homeProviderAd.categoryItemList.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => _CategoryChip(
              item: _homeProviderAd.categoryItemList[i],
              onTap: (){},
            ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }

  Widget _trendingProductList(HomeProviderAd homeProvider) {
    return (homeProvider.trending.length ?? 0) <= 0
        ? AppUtils.commonSizedBox()
        : Column(
          children: [
            _headerSectionWidget("TRENDING PRODUCTS", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductListingScreen(
                    isBackButtonAvailable: true,
                    totViewTypeId: AppConstants.viewTypeTrending,

                    categoryName: "Trending",
                    isFromCategory: false,
                  ),
                ),
              );
            },),
            const SizedBox(height: 10,),
            SizedBox(
              height: 230,
              child: ListView.separated(
                // shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.trending.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => ProductCard(

                  item: homeProvider.trending[i],
                  onTap:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProductDetailScreen(
                          productId:
                          homeProvider
                              .trending[i].id,
                        ),
                      ),
                    );
                  },),
              ),
            ),
            const SizedBox(height: 15,),
          ],
        );
  }

  Widget _bestsellerProductList(HomeProviderAd homeProvider) {
    return (homeProvider.bestSeller.length ?? 0) <= 0
        ? AppUtils.commonSizedBox()
        : Column(
          children: [
            _headerSectionWidget("BESTSELLER PRODUCTS", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductListingScreen(
                    isBackButtonAvailable: true,
                    totViewTypeId: AppConstants.viewTypeBestSeller,

                    categoryName: "Best seller",
                    isFromCategory: false,
                  ),
                ),
              );
            },),

            const SizedBox(height: 10,),
            SizedBox(
              height: 230,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.bestSeller.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => ProductCard(
                  item: homeProvider.bestSeller[i],
                  onTap:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProductDetailScreen(
                          productId:
                          homeProvider
                              .bestSeller[i].id,
                        ),
                      ),
                    );
                  },),
              ),
            ),
          ],
        );
  }

  Widget _newArrivalProductList(HomeProviderAd homeProvider) {
    return (homeProvider.newArrival.length ?? 0) <= 0
        ? AppUtils.commonSizedBox()
        : Column(
          children: [
            _headerSectionWidget("NEW ARRIVAL PRODUCTS", () {
              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProductListingScreen(
                                  isBackButtonAvailable: true,
                                  totViewTypeId: AppConstants.viewTypeNewArrival,
                                  categoryName: "New Arrival",
                                  isFromCategory: false,
                                ),
                          ),
                        );
            },),
            const SizedBox(height: 10,),
            SizedBox(
              height: 230,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.newArrival.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => ProductCard(
                  item: homeProvider.newArrival[i],
                  onTap:  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductDetailScreen(
                                          productId:
                                              homeProvider
                                                  .newArrival[i].id,
                                        ),
                                  ),
                                );
                  },),
              ),
            ),

          ],
        );
  }
}

class _BannerCarousel extends StatelessWidget {
  final PageController controller;
  final List<Banners> items;
  final int index;
  final void Function(Banners) onTap;

  const _BannerCarousel({
    required this.controller,
    required this.items,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            itemBuilder: (context, i) {
              final b = items[i];
              return GestureDetector(
                onTap: () => onTap(b),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(b.bannerImage ?? "", fit: BoxFit.cover),
                        // vignette
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.45),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // label plate (glass)
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: AppUtils.commonGlassmorphicContainer(
                            blur: 18,

                            // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),

                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (b.bannerTitle ?? "").textWidget(
                                    maxLine: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.start,
                                    fontSize: 16,
                                  ),
                                  if (b.bannerDescription != null) ...[
                                    const SizedBox(height: 2),
                                    (b.bannerDescription ?? "").textWidget(
                                      maxLine: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      textAlign: TextAlign.start,
                                      color: AppColors.colorWhite.withOpacity(
                                        0.50,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _Dots(count: items.length, index: index),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: active ? 16 : 6,
          decoration: BoxDecoration(
            color: active ? AppColors.colorSecondary : Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final Categories item;
  final VoidCallback onTap;
  const _CategoryChip({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Frost(
      blur: 14,
      opacity: .22,
      radius: 999,
      frame: Frost.outlineBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(item.categoryImage ?? ""),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                item.categoryName?.toUpperCase() ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: .6,
                  fontWeight: FontWeight.w800,
                  color: AppColors.colorWhite
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



