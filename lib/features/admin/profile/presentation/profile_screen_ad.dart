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
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/pending_order/presentation/pending_order_screen.dart';
import 'package:sales_app_redesign/features/admin/stock/presentation/pages/catagory_listing_screen.dart';
import 'package:sales_app_redesign/features/admin/user/presentation/salesman_screen_ad.dart';
import 'package:sales_app_redesign/features/auth/presentation/login_screen.dart';
import 'package:sales_app_redesign/features/genral/change_password/presentation/chnage_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../sales/dashboard/dashboard.dart';

class ProfileScreenAd extends StatefulWidget {
  const ProfileScreenAd({super.key});

  @override
  State<ProfileScreenAd> createState() => _ProfileScreenAdState();
}

class _ProfileScreenAdState extends State<ProfileScreenAd> {
  String? userId;
  String? userName;
  String? userProfile;
  String? userEmail;

  getInfo() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    userName = PreferenceHelper.getString(PreferenceHelper.USER_NAME);
    userProfile = PreferenceHelper.getString(PreferenceHelper.USER_IMAGE);
    userEmail = PreferenceHelper.getString(PreferenceHelper.USER_EMAIL);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(title: "Profile", centerTitle: true,isAdmin: false,isBackVisible: true,),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            children: [
              Column(

                children: [
                  userImageWidget(),
                  20.toSizedBoxHeight,
                  (userName ?? "").textWidget(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  5.toSizedBoxHeight,
                  (userEmail ?? "").textWidget(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  AppUtils.commonSizedBox(height: 20),
                  AppUtils.commonDiver(
                    thickness: 0.5,
                      color: AppColors.colorWhite, endIndent: 10, indent: 10,),
                  AppUtils.commonSizedBox(height: 20),
                  commonRow(
                      preIcon: Icons.lock_outline_rounded,
                      text: "Change Password",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonChangePasswordScreen(),
                            ));
                      }),

                  commonRow(
                      preIcon: Icons.category,
                      text: "Stock Management",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryListingScreen(),
                            ));
                      }),


                  commonRow(
                      preIcon: Icons.pending_actions,
                      text: "Pending Order Summary",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PendingOrderSummaryScreen(),
                            ));
                      }),
                  commonRow(
                      preIcon: Icons.supervised_user_circle,
                      text: "Salesmen",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalesManScreenAd(),
                            ));
                      }),

                  commonRow(
                      preIcon: Icons.logout,
                      text: "Log Out",
                      onTap: () {
                        AppUtils.showCustomTwoBtnDialog(
                          rightPop: false,
                          dialogTitle: "Logout",
                          dialogMessage: "Do you really want to log out?",
                          dialogBtnTextRight: "Logout",
                          dialogBtnTextLeft: "Cancel",
                          dialogBtnRightFnc: () async {
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.clear();
                            PreferenceHelper.setInt(PreferenceHelper.cartItem,0);
                            PreferenceHelper.remove(PreferenceHelper.CART_MODEL_LIST_AD);
                            PreferenceHelper.clear();
                            setState(() {
                              cartItemCount = 0;
                            });
                            // PreferenceHelper.setBool(PreferenceHelper.IS_LOGIN, false);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LogInScreen()),
                                  (Route<dynamic> route) => false,
                            );

                          },
                          ctx: context,
                        );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => CommonChangePasswordScreen(),
                        //     ));
                      }),


                ],
              ),

            ],
          ),
        );
      },
    );
  }

  Widget commonRow(
      {String? text, IconData? preIcon, required VoidCallback onTap}) {
    return Column(
      children: [
        AppUtils.commonInkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Frost(

            child: Padding(
              padding: AppUtils.edgeInsetsOnly(left: 20, right: 20,top: 10,bottom: 10),
              child: Row(
                children: [
                  AppUtils.commonContainer(
                      padding: AppUtils.edgeInsetsAll(allPadding: 8),
                      decoration: AppUtils.commonGradientBoxDecoration(borderRadius: 12),
                      child: Center(
                          child: Icon(preIcon,
                              color: AppColors.colorWhite, size: 22))),
                  AppUtils.commonSizedBox(width: 20),
                  Expanded(
                      child: (text ?? "").textWidget(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,

                      )),
                ],
              ),
            ),
          ),
        ),
        AppUtils.commonSizedBox(height: 20),
      ],
    );
  }

  Widget userImageWidget() {
    return AppUtils.commonContainer(
      padding: AppUtils.edgeInsetsAll(allPadding: 3),
      decoration: AppUtils.commonBoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.colorWhite, width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          height: 100,
          width: 100,
          imageUrl: userProfile ?? "",
          imageBuilder:
              (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          placeholder: (context, url) => CircleLoadingIndicatorWidget(),
          errorWidget:
              (context, url, error) =>
                  Icon(Icons.person, size: 40, color: AppColors.colorWhite),
        ),
      ),
    );
  }
}
