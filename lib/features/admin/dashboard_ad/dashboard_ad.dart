import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/features/admin/category_ad/category_screen_ad.dart';
import 'package:sales_app_redesign/features/admin/home/presentation/home_screen_ad.dart';
import 'package:sales_app_redesign/features/admin/order/presentation/pages/order_screen_Ad.dart';
import 'package:sales_app_redesign/features/admin/profile/presentation/profile_screen_ad.dart';
import 'package:sales_app_redesign/features/admin/user/presentation/salesman_screen_ad.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_listing_page.dart';
import 'package:sales_app_redesign/features/sales/category/presentation/category_screen.dart';

import '../../../core/common_statefull_widget/app_scaffold.dart';
import '../order/presentation/order_screen_ad.dart';

class DashboardScreenAD extends StatefulWidget {
  const DashboardScreenAD({super.key});

  @override
  State<DashboardScreenAD> createState() => _DashboardScreenADState();
}

class _DashboardScreenADState extends State<DashboardScreenAD> {
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );
  final PageController _pageController = PageController(initialPage: 0);

  final _pages = [
    const HomeScreenAd(),
    const CategoryScreenAd(),
    const OrderScreenAd(),
    const StockScreenAd(),
  ];

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print("didPop$didPop");
        print("result$result");
      },
      child: AppScaffold(
        bgColor: AppColors.colorPrimary,
        bottomNavigationBar: _buildNavBar(),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _pages,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return AnimatedNotchBottomBar(
      showShadow: true,
      textOverflow: TextOverflow.visible,
      showTopRadius: true,

      // bottomBarHeight: 100,
      circleMargin: 10,
      kBottomRadius: 10,
      // durationInMilliSeconds: 1000,
      notchBottomBarController: _controller,
      color: AppColors.colorWhite,
      showLabel: true,
      blurOpacity: 0.5,

      showBlurBottomBar: false,
      itemLabelStyle: TextStyle(
        fontFamily: AppConstants.fontFamilyPoppins,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        color: AppColors.colorPrimary,
      ),

      notchGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.gradient1, AppColors.gradient2],
      ),
      // notchColor: AppColors.colorPrimary,
      textAlign: TextAlign.center,
      kIconSize: 20,
      // Improved icon size for better visibility
      bottomBarItems: [
        BottomBarItem(
          itemLabel: "Home",
          inActiveItem: Icon(
            Icons.home_outlined,
            color: AppColors.colorPrimary,
          ),
          activeItem: Icon(Icons.home_rounded, color: AppColors.colorWhite),
        ),
        BottomBarItem(
          itemLabel: "Products",
          inActiveItem: Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.colorPrimary,
          ),
          activeItem: Icon(Icons.shopping_bag, color: AppColors.colorWhite),
        ),
        BottomBarItem(
          itemLabel: "Order",
          inActiveItem: Icon(
            Icons.note_outlined,
            color: AppColors.colorPrimary,
          ),
          activeItem: Icon(Icons.note, color: AppColors.colorWhite),
        ),
        BottomBarItem(
          itemLabel: "Stock",
          inActiveItem: Icon(
            Icons.category_outlined,
            color: AppColors.colorPrimary,
          ),
          activeItem: Icon(Icons.category, color: AppColors.colorWhite),
        ),
        // BottomBarItem(
        //   itemLabel: "User",
        //   inActiveItem: Icon(
        //     Icons.supervised_user_circle,
        //     color: AppColors.colorPrimary,
        //   ),
        //   activeItem: Icon(Icons.supervised_user_circle, color: AppColors.colorWhite),
        // ),
        // BottomBarItem(
        //   itemLabel: "Profile",
        //   inActiveItem: Icon(
        //     Icons.person_outline,
        //     color: AppColors.colorPrimary,
        //   ),
        //   activeItem: Icon(Icons.person, color: AppColors.colorWhite),
        // ),
      ],
      onTap: (index) {
        _pageController.jumpToPage(index);
        setState(() => pageIndex = index);
      },
    );
  }
}
