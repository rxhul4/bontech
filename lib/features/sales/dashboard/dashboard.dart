import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/user/presentation/salesman_screen_ad.dart';
import 'package:sales_app_redesign/features/genral/home/presentation/home_screen.dart';
import 'package:sales_app_redesign/features/sales/category/presentation/category_screen.dart';
import 'package:sales_app_redesign/features/sales/profile/presentation/profile_screen.dart';

import '../../../core/common_statefull_widget/app_scaffold.dart';


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
     HomeScreen(isAdmin: false,),
     CategoryScreen(),
     ProfileScreen(),
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
        bottomNavigationBar: NavBar(),
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


  static const List<NavigationDestination> _navDestinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2),
      label: 'Products',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      selectedIcon: Icon(Icons.person_2),
      label: 'Profile',
    ),
  ];

  Widget NavBar() {
    return Frost(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 16),
      child: SafeArea(
        top: true,
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          destinations: _navDestinations,
          selectedIndex: pageIndex,
          onDestinationSelected: (index) {
            _pageController.jumpToPage(index);
            setState(() => pageIndex = index);
          },
        ),
      ),
    );
  }

}
