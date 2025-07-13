import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/image_strings.dart';
import 'package:sales_app_redesign/features/admin/dashboard_ad/dashboard_ad.dart';
import 'package:sales_app_redesign/features/auth/presentation/login_screen.dart';
import 'package:sales_app_redesign/features/sales/dashboard/dashboard.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool? isLogIn;
  String? userTypeId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
     await  _gotoLogin();
    },);

  }

  @override
  Widget build(BuildContext context) {
    final height = AppUtils.getMediaHeight(context);
    final width = AppUtils.getMediaWidth(context);

    return AppScaffold(
        body: Center(
          child: icAppMainLogo.imageAssetWidget(
            iconColor: AppColors.colorWhite,
            height: 350,
            width: MediaQuery.sizeOf(context).width * 0.7,
          ),
        ));
  }

  _gotoLogin() async {
    isLogIn = PreferenceHelper.getBool(PreferenceHelper.IS_LOGIN);
    userTypeId = PreferenceHelper.getString(PreferenceHelper.USER_TYPE_ID);
    print("is login $isLogIn");
    print("userTypeId $userTypeId");
    Timer(const Duration(milliseconds: 3000), () async{
      if (isLogIn ?? false) {
        if (userTypeId == AppConstants.userTypeDistributor) {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardScreenAD()),
                  (route) => true);
        }
        if (userTypeId == AppConstants.userTypeSalesMen) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  (route) => false);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LogInScreen()),
                (route) => false);
      }
    });
  }
}
