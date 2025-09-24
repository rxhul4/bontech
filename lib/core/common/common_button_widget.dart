import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';

class CommonButtonWidget extends StatelessWidget {
  const CommonButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonBgColor,
    this.buttonTextColor = Colors.white,
    this.fontSize,
    this.borderRadius,
    this.verticalPadding,
    this.fontWeight,
    this.isLoading = false,
    this.horizontalMargin,
    this.verticalMargin,
    this.horizontalPadding,
  });

  final bool isLoading;
  final String buttonText;
  final double? fontSize;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? verticalMargin;
  final double? horizontalMargin;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final Color? buttonBgColor;
  final Color buttonTextColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return _buttonIcon();
  }

  Widget _buttonIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      onTap: () {
        onPressed();
      },
      child: isLoading
          ? const CircleLoadingIndicatorWidget(isDimBg: false)
          : Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 0,vertical: verticalMargin ?? 0),
              decoration: AppUtils.commonGradientBoxDecoration(
                borderRadius: borderRadius ?? 12,
                // border: Border.all(color: Colors.transparent, width: 1.5)
              ),

              // decoration: BoxDecoration(
              //   color: buttonBgColor,
              //   gradient: buttonBgColor  == null ? LinearGradient(
              //     colors: [
              //       AppColors.gradient1,
              //       AppColors.gradient2,
              //     ],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //   ) : null,
              //   borderRadius: BorderRadius.circular(borderRadius ?? 12),
              //   border: Border.all(color: Colors.transparent, width: 1.5),
              // ),
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding ?? 16, horizontal: horizontalPadding ?? 12),
              child: Center(
                child: buttonText.textWidget(
                  color: buttonTextColor,
                  fontSize: fontSize ?? 14,
                  fontWeight: fontWeight ?? FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
