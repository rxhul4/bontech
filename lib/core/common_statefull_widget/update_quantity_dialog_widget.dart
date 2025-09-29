import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common/common_button_widget.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';

class UpdateQuantityDialogWidget extends StatelessWidget {
  const UpdateQuantityDialogWidget({
    super.key,
    required this.qtyTextEditingController,
    required this.positiveCallBack,
    this.hintText
  });

  final TextEditingController qtyTextEditingController;
  final Function(String val) positiveCallBack;
  final String? hintText;

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
          width: MediaQuery.sizeOf(context).width * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              AppUtils.commonTextWidget(
                  text: "Update Quantity",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                  textColor: AppColors.colorBg),
              10.toSizedBoxHeight,
              CustomTextFormField(
                controller: qtyTextEditingController,
                hintText: hintText ?? "Qty",
                autofocus: true,
                inputFormatterRegex: '[0-9]',
                inputType: TextInputType.number,
                hintColor: AppColors.colorWhite,
                fillColor: AppColors.colorTransparent,
                textColor: AppColors.colorWhite,
                borderColor: AppColors.colorSecondary,
                isShowBorder: true,
                maxLines: 1,
                maxLength: 4,
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
                          buttonText: 'Update',
                          onPressed: () {
                            if (int.parse(qtyTextEditingController.text
                                    .trim()
                                    .toString()) ==
                                0) {
                              // showToastMsg('Quantity should not be zero');
                            } else {
                              positiveCallBack(qtyTextEditingController.text);
                              Navigator.pop(context);
                            }
                          })),
                ],
              ),
              10.toSizedBoxHeight,
            ],
          )),
    );
  }
}
