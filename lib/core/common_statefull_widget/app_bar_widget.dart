import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';

import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/profile/presentation/profile_screen_ad.dart';
import 'package:sales_app_redesign/features/genral/cart/presentation/cart_screen.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/genral/search/presentation/search_delegate.dart';

import '../../features/admin/dashboard_ad/dashboard_ad.dart';
import '../../features/sales/dashboard/dashboard.dart';
import '../../main.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    super.key,
    this.title,
    this.onBackPressed,
    this.onPressedSearch,
    this.onPressedCart,
    this.onPressedFav,
    this.onBulkUpdate,
    this.isFavColor,
    this.isBackVisible = false,
    this.isSearchVisible = false,
    this.isCartVisible = true,
    this.isFavVisible = false,
    this.isBulUpdateQty = false,
    this.textAlign,
    this.centerTitle = true,
    this.isAdmin,
  });

  final String? title;
  final bool? isAdmin;
  final Function? onBackPressed;
  final Function? onPressedSearch;
  final Function? onBulkUpdate;
  final Function? onPressedCart;
  final Function? onPressedFav;
  final bool isBackVisible;
  final bool isSearchVisible;
  final bool isCartVisible;
  final bool isFavVisible;
  final bool isBulUpdateQty;
  final Color? isFavColor;
  final TextAlign? textAlign;
  final bool centerTitle;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Frost(
          blur: 18,
          opacity: .20,
          radius: 16,
          frame: Frost.outlineBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Row(
                children: [
                  const SizedBox(width: 12),
                  (widget.title ?? "Bonetech").textWidget(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorWhite,
                  ),
                ],
              ),
              const Spacer(),
              widget.isSearchVisible ? _searchIcon(context) : SizedBox(),
              10.toSizedBoxWidth,

              widget.isCartVisible ? _cartIcon(context) : SizedBox(),
              widget.isAdmin == true ? 10.toSizedBoxWidth : 5.toSizedBoxWidth,
              widget.isAdmin == true
                  ? _RoundIcon(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreenAd(),
                        ),
                      );
                    },
                    icon: Icons.account_circle_outlined,
                  )
                  : SizedBox(),
              widget.isBulUpdateQty == true ? _bulkUpdate(context) : SizedBox(),
              widget.isBulUpdateQty == true
                  ? 10.toSizedBoxWidth
                  : 0.toSizedBoxWidth,
              widget.isAdmin == true ? 5.toSizedBoxWidth : 0.toSizedBoxWidth,
            ],
          ),
        ),
      ),
    );
    // return AppBar(
    //
    //   backgroundColor: AppColors.colorTransparent,
    //   surfaceTintColor: AppColors.colorTransparent,
    //   shadowColor: AppColors.colorTransparent,
    //   automaticallyImplyLeading: false,
    //   elevation: 10,
    //   titleSpacing: widget.isBackVisible == false ? 16 : 0,
    //   leadingWidth: 70,
    //   leading: widget.isBackVisible ? _backArrow(context) : null,
    //   centerTitle: widget.centerTitle ? true : false,
    //   title: (widget.title ?? ''.toUpperCase()).textWidget(
    //     color: AppColors.colorWhite,
    //     fontWeight: FontWeight.w500,
    //     fontFamily: AppConstants.fontFamilyPoppins,
    //     latterSpacing: 0.3,
    //     fontSize: 20,
    //   ),
    //   actions: [
    //     // searchIcon(),
    //     widget.isSearchVisible ? _searchIcon(context) : SizedBox(),
    //     10.toSizedBoxWidth,
    //
    //     widget.isCartVisible ? _cartIcon(context) : SizedBox(),
    //     widget.isAdmin == true ? 10.toSizedBoxWidth : 5.toSizedBoxWidth,
    //     widget.isAdmin == true ?  _profileCircle(context) : SizedBox(),
    //     widget.isBulUpdateQty == true ? _bulkUpdate(context): SizedBox(),
    //     widget.isBulUpdateQty == true ? 10.toSizedBoxWidth : 0.toSizedBoxWidth,
    //     widget.isAdmin == true ? 5.toSizedBoxWidth : 0.toSizedBoxWidth,
    //
    //
    //   ],
    // );
  }

  _bulkUpdate(BuildContext context) {
    return Visibility(
      visible: widget.isBulUpdateQty,
      child: InkWell(
        onTap: () {
          if (widget.onBulkUpdate != null) {
            widget.onBulkUpdate!();
          }
        },
        child: SizedBox(
          height: 40,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 3.0, top: 5),
                child: const Icon(
                  Icons.add_box,
                  color: AppColors.colorWhite,
                  size: 30,
                ),
              ),
              // Positioned(right: 0, top: 0, child: _countView()),
            ],
          ),
        ),
      ),
    );
  }

  _profileCircle(BuildContext context) {
    String? imgUrl = PreferenceHelper.getString(PreferenceHelper.USER_IMAGE);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreenAd()),
        );
      },
      child: AppUtils.commonContainer(
        margin: AppUtils.edgeInsetsOnly(right: 10),
        height: 40,
        width: 40,
        decoration: AppUtils.commonBoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.colorPrimary),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            height: 100,
            width: 100,
            imageUrl: imgUrl ?? "",
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
                (context, url) => CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.colorSecondary,
                  ),
                  strokeWidth: 2,
                ),
            errorWidget:
                (context, url, error) =>
                    Icon(Icons.person, size: 40, color: AppColors.colorWhite),
          ),
        ),
      ),
    );
  }

  Widget _backArrow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onBackPressed != null) {
          widget.onBackPressed!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: AppUtils.commonGradientBoxDecoration(),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _cartIcon(BuildContext context) {
    return Visibility(
      visible: widget.isCartVisible,
      child: InkWell(
        onTap: () {
          if (widget.onPressedCart != null) {
            widget.onPressedCart!();
          } else {
            String? userType = PreferenceHelper.getString(
              PreferenceHelper.USER_TYPE_ID,
            );
            if (userType == AppConstants.userTypeDistributor) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(isAdmin: true),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(isAdmin: false),
                ),
              );
            }
          }
        },
        child: SizedBox(
          height: 40,
          child: Stack(
            children: [
              _RoundIcon(icon: Icons.shopping_bag_outlined),
              Positioned(right: 0, top: 0, child: _countView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchIcon(BuildContext context) {
    return Visibility(
      visible: widget.isSearchVisible,
      child: _RoundIcon(
        onTap: () {
          if (widget.onPressedSearch != null) {
            widget.onPressedSearch!();
          }
        },
        icon: Icons.search,
      ),
    );
  }

  Widget _countView() {
    return Visibility(
      visible: (cartItemCount > 0),
      child: Container(
        height: 17,
        width: 17,
        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: Center(
          child: '$cartItemCount'.textWidget(
            color: AppColors.colorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundIcon({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Frost(
      blur: 14,
      opacity: .18,
      radius: 12,
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Icon(icon, size: 20, color: AppColors.colorWhite),
      ),
    );
  }
}
