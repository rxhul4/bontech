import 'dart:io';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/category_ad/presentation/category_screen_ad.dart';
import 'package:sales_app_redesign/features/genral/home/presentation/home_screen.dart';
import 'package:sales_app_redesign/main.dart';

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
     HomeScreen(isAdmin: true,),
    CategoryScreenAd(),
     OrderScreenAd(),
    // const StockScreenAd(),
  ];

  int pageIndex = 0;

  @override
  void initState() {
    cartItemCount = PreferenceHelper.getInt(PreferenceHelper.cartItem) ?? 0;

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
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Orders',
    ),
  ];

  Widget NavBar() {
    if(Platform.isIOS){
      return Frost(

        padding: EdgeInsets.zero,
        radius: 0,
        margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
        child: NavigationBar(
          // height: ,
          backgroundColor: Colors.transparent,
          destinations: _navDestinations,
          selectedIndex: pageIndex,
          onDestinationSelected: (index) {
            _pageController.jumpToPage(index);
            setState(() => pageIndex = index);
          },
        ),
      );
    }else{
      return Frost(

        // padding: EdgeInsets.zero,zero
        margin: EdgeInsets.only(left: 10  , right: 10, bottom: 20),
        child: SafeArea(
          top: true,
          child: NavigationBar(
            // height: ,
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
}
