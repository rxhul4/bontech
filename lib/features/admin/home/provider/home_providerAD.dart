import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sales_app_redesign/core/constants/api_constants.dart';
import 'package:sales_app_redesign/core/network/network_repository.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/home/model/get_home_model.dart';

class HomeProviderAd extends ChangeNotifier {
  bool _isFetching = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isAdding = false;

  bool get isFetching => _isFetching;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  bool get isAdding => _isAdding;

  GetHomeModel? getHomeModel;

  //variable List
  List<Categories>? categoryItemList = [];
  // List<BestSellers>? bestSellerProductList = [];
  // List<TrendingProducts>? trendingProductList = [];
  // List<NewArrivals>? newArrivalProductList = [];
  List<Banners>? bannerList = [];

  int currentIndex = 0;

  changeIndex(int index){
    currentIndex = index;
    notifyListeners();
  }

  void apiCallGetHomeView(BuildContext context) async {
    String? userId = PreferenceHelper.getString(PreferenceHelper.USER_ID);
    _isFetching = true;
    // notifyListeners();
    try {
      Map<String, dynamic> body = {"user_id": userId};
      String endPoint = ApiConstants.getHomeView;
      var response = await callPostMethod(endPoint, body);
      getHomeModel = GetHomeModel.fromJson(json.decode(response));
      if (getHomeModel?.isError == false &&
          getHomeModel?.isValidationFailed == false) {
        // newArrivalProductList =
        //     getHomeModel?.data?.products?.newArrivalProducts?.toList();
        // bestSellerProductList =
        //     getHomeModel?.data?.products?.bestSellerProducts?.toList();
        // trendingProductList =
        //     getHomeModel?.data?.products?.trandingProducts?.toList();
        categoryItemList = getHomeModel?.data?.categories?.toList();
        bannerList = getHomeModel?.data?.banners?.toList();
      }
      print('yooooooooooo $response');
    } catch (e) {
      AppUtils.showCustomDialog(
        ctx: context,
        dialogMessage: getHomeModel?.message,
      );
    }
    _isFetching = false;
    notifyListeners();
  }
}
