
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/image_strings.dart';

import '../constants/app_size_constants.dart';

extension AppExtension on String{

  Widget textWidget({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    TextOverflow? overflow,
    int? maxLine,
    TextAlign? textAlign,
    Color color = AppColors.colorWhite,
    String? fontFamily,
    FontStyle? fonStyle,
    double? height,
    double? latterSpacing,
  }) =>
      Text(
        this,
        overflow: overflow,
        maxLines: maxLine,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: fontSize ?? 14,
            color: color,
            fontWeight: fontWeight,
            fontStyle: fonStyle,
            height: height ?? 1.3,
            letterSpacing: latterSpacing ?? 0,
            fontFamily: fontFamily ?? AppConstants.fontFamilyPoppins),
      );

  //
  // Widget richTextView({
  //   double fontSize = fontSizeNormal,
  //   FontWeight fontWeight = FontWeight.normal,
  //   TextOverflow? overflow,
  //   int? maxLine,
  //   TextAlign? textAlign,
  //   Color color = AppColors.colorWhite,
  //   String? fontFamily,
  //   double? height,
  //   List<InlineSpan>? textSpanList,
  // }) =>
  //     RichText(
  //         text: TextSpan(
  //           text: this,
  //           style: TextStyle(
  //               fontSize: fontSize,
  //               color: color,
  //               fontWeight: fontWeight,
  //               height: height ?? 1.4,
  //               fontFamily: fontFamily ?? AppConstants.fontFamilyPoppins),
  //           children: textSpanList ?? [],
  //         ));

  //asset image
  Widget imageAssetWidget({
    double? height,
    double? width,
    double? padding,
    BoxFit? boxFit,
    Color? iconColor,
  }) =>
      Container(
        padding: EdgeInsets.all(padding ?? 0),
        child: Image.asset(
          this,
          height: height ?? 24,
          width: width ?? 24,
          fit: boxFit ?? BoxFit.contain,
          color: iconColor,
        ),
      );


  Widget toNetWorkImage({
    double height = 50,
    double width = 50,
    num borderRadius = 20,
    bool isAllRounded = true,
    double topLeftBorder = 10.0,
    double topRightBorder = 10.0,
    double bottomLeftBorder = 10.0,
    double bottomRightBorder = 10.0,
    BoxFit fit = BoxFit.cover,
    String? placeHolderAssets,
    VoidCallback? onTap,
    double? errorPaddingAll,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: this,
            height: height,
            width: width,
            fit: fit,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: isAllRounded
                    ? BorderRadius.circular(borderRadius.toDouble())
                    : BorderRadius.only(
                  bottomLeft: Radius.circular(bottomLeftBorder),
                  bottomRight: Radius.circular(bottomRightBorder),
                  topLeft: Radius.circular(topLeftBorder),
                  topRight: Radius.circular(topRightBorder),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  borderRadius: isAllRounded
                      ? BorderRadius.circular(borderRadius.toDouble())
                      : BorderRadius.only(
                    bottomLeft: Radius.circular(bottomLeftBorder),
                    bottomRight: Radius.circular(bottomRightBorder),
                    topLeft: Radius.circular(topLeftBorder),
                    topRight: Radius.circular(topRightBorder),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(errorPaddingAll ?? 5.0),
                  child:
                  (placeHolderAssets ?? icPlaceholder).imageAssetWidget(),
                )),
            progressIndicatorBuilder: (_, __, ___) =>
            const CircleLoadingIndicatorWidget(),
          ),
        ],
      );


  Widget richTextView({
    double fontSize = fontSizeNormal,
    FontWeight fontWeight = FontWeight.normal,
    TextOverflow? overflow,
    int? maxLine,
    TextAlign? textAlign,
    Color color = AppColors.colorWhite,
    String? fontFamily,
    double? height,
    List<InlineSpan>? textSpanList,
  }) =>
      RichText(
          text: TextSpan(
            text: this,
            style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight,
                height: height ?? 1.4,
                fontFamily: fontFamily ?? AppConstants.fontFamilyPoppins),
            children: textSpanList ?? [],
          ));

}

extension AppWidgetExtension on Widget {
  Widget toVisibility(bool value) => Visibility(
    visible: value,
    child: this,
  );
}

extension AppIntExtension on num {
  SizedBox get toSizedBox => SizedBox(height: toDouble(), width: toDouble());

  SizedBox get toSizedBoxHeight => SizedBox(height: toDouble());

  SizedBox get toSizedBoxWidth => SizedBox(width: toDouble());

  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
}


extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}