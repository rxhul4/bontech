import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';

import '../common_statefull_widget/frost_conatiner.dart';
import 'common_button_widget.dart';

class CommonDialog extends StatefulWidget {
  final String? dialogTitle;
  final String? dialogMessage;
  final String? dialogBtnText;
  const CommonDialog({Key? key, this.dialogTitle, this.dialogMessage, this.dialogBtnText}) : super(key: key);

  @override
  State<CommonDialog> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: AppColors.colorTransparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          )),
      content: Frost(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        width: MediaQuery.sizeOf(context).width * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppUtils.commonSizedBox(height: 10),
            AppUtils.commonTextWidget(
                text: widget.dialogTitle?.toUpperCase() ?? "Error",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
                textColor: AppColors.colorBg),
            AppUtils.commonSizedBox(height: 20),
            AppUtils.commonTextWidget(
                textAlign: TextAlign.center,
                text: widget.dialogMessage ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
                textColor: AppColors.colorBg),
            30.toSizedBoxHeight,
            CommonButtonWidget(
              buttonTextColor: AppColors.colorWhite,
              buttonText:  "Okey",
              onPressed: () {
                Navigator.pop(context);
              },
              verticalPadding: 10,
              buttonBgColor: AppColors.colorBg,
            )
          ],
        ),
      ),
    );
  }
}
