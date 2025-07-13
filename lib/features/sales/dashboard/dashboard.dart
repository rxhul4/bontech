import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/home/presentation/home_screen_ad.dart';
import 'package:sales_app_redesign/features/admin/user/presentation/salesman_screen_ad.dart';
import 'package:sales_app_redesign/features/sales/category/presentation/category_screen.dart';
import 'package:sales_app_redesign/features/sales/home/presentation/home_screen.dart';
import 'package:sales_app_redesign/features/sales/profile/presentation/profile_screen.dart';

import '../../../core/common_statefull_widget/app_scaffold.dart';

int cartItemCount = 0;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );
  final PageController _pageController = PageController(initialPage: 0);

  final _pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const ProfileScreen(),
  ];

  // final _pageName = [
  //   'HOME',
  //   'ORDERS',
  //   'FAVORITES',
  //   'PROFILE',
  // ];

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
      // bottomBarHeight: 80,
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
        fontSize: 11,
        color: AppColors.colorPrimary,
        overflow: TextOverflow.visible
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

          itemLabel: "Category",
          inActiveItem: Icon(
            Icons.category_outlined,
            color: AppColors.colorPrimary,
          ),
          activeItem: Icon(Icons.category, color: AppColors.colorWhite),
        ),
        BottomBarItem(
          itemLabel: "Profile",
          inActiveItem: Icon(
            Icons.person_outline,
            color: AppColors.colorPrimary,
          ),
          activeItem: Icon(Icons.person, color: AppColors.colorWhite),
        ),
      ],
      onTap: (index) {
        _pageController.jumpToPage(index);
        setState(() => pageIndex = index);
      },
    );
  }

}
