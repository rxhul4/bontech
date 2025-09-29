import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common/common_button_widget.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';

class DeliveryNotesDialogWidget extends StatelessWidget {
  const DeliveryNotesDialogWidget({
    super.key,
    required this.notesController,
    required this.positiveCallBack,
  });

  final TextEditingController notesController;
  final Function(String val) positiveCallBack;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppUtils.commonSizedBox(height: 10),
            AppUtils.commonTextWidget(
                text: "Delivery Note",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
                textColor: AppColors.colorBg),
            20.toSizedBoxHeight,
            CustomTextFormField(
              controller: notesController,
              hintText: "Would you like to add any note?",
              autofocus: true,
              // inputFormatterRegex: '[0-9]',
              inputType: TextInputType.text,
              hintColor: AppColors.colorWhite,
              fillColor: AppColors.colorTransparent,
              textColor: AppColors.colorWhite,
              borderColor: AppColors.colorSecondary,
              isShowBorder: true,
              maxLines: 4,
              onChanged: (value) {},
            ),
            24.toSizedBoxHeight,
            Row(
              children: [
                Expanded(
                    child: CommonButtonWidget(
                      borderRadius: 10,
                      buttonText: "Cancel",
                      buttonTextColor: AppColors.colorWhite,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      verticalPadding: 10,
                      buttonBgColor: AppColors.colorBg,
                    )),
                12.toSizedBoxWidth,
                Expanded(
                    child: CommonButtonWidget(
                        borderRadius: 10,
                        verticalPadding: 10,
                        buttonText: 'Confirm',
                        onPressed: () {
                          positiveCallBack(notesController.text);
                          Navigator.pop(context);
                          // if (notesController.text.isEmpty) {
                          //   // showToastMsg('Quantity should not be zero');
                          //   AppUtils.showSnackBarWithColor(context: context, message: "Please Enter Delivery notes");
                          //
                          // } else {
                          //
                          // }
                        })),
              ],
            ),
            10.toSizedBoxHeight,
          ],
        ),
      ),
    );
  }
}
