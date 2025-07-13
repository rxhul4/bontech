import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart';



String convertJsonToString(dynamic jsonValue) {
  return jsonEncode(jsonValue);
}

void showAlertDialog({
  required BuildContext context,
  required String title,
  required Widget widget,
  bool isTitleVisible = true,
  bool isTitleCenter = false,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        backgroundColor: AppColors.colorPrimary,
        title: isTitleVisible
            ? Row(
          mainAxisAlignment: isTitleCenter
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            title.textWidget(
              color: AppColors.colorWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )
          ],
        )
            : const SizedBox(),
        content: widget,
      );
    },
  );
}

Future<List<ProductInfo>> getCartProductListFromPreference({required String cartString}) async {
  List<ProductInfo> list = [];
  String? cartListPref = PreferenceHelper.getString(cartString);
  if(cartListPref != '' && cartListPref != null){
    var decoded = jsonDecode(cartListPref);
    list = decoded.map((e) => ProductInfo.fromJson(e)).toList();
  }
  return list;


}

Future<void> saveProductInCartListPreference(
    {List<ProductInfo?>? prefProductInfoList, String? cartString}) async {
  String stringList = convertJsonToString(prefProductInfoList);
   PreferenceHelper.setString(cartString ?? PreferenceHelper.CART_MODEL_LIST_AD, stringList);
}