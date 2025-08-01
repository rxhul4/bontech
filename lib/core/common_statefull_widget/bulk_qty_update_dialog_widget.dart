import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common/common_button_widget.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';

class BulkQuantityDialogWidget extends StatelessWidget {
  const BulkQuantityDialogWidget({
    super.key,
    required this.thresholdQtyTextEditingController,
    required this.physicalQtyTextEditingController,
    required this.positiveCallBack,
  });

  final TextEditingController thresholdQtyTextEditingController;
  final TextEditingController physicalQtyTextEditingController;
  final Function(String val) positiveCallBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.75,
        child: ListView(
          shrinkWrap: true,

          children: [
            10.toSizedBoxHeight,
            "ThresholdQty".textWidget(
              fontSize: 12,
              fontWeight: FontWeight.w300,

            ),
            5.toSizedBoxHeight,
            CustomTextFormField(
              controller: thresholdQtyTextEditingController,
              hintText: "Qty",
              autofocus: true,
              inputFormatterRegex: '[0-9]',
              inputType: TextInputType.number,
              hintColor: AppColors.colorWhite,
              fillColor: AppColors.colorPrimary,
              textColor: AppColors.colorWhite,
              borderColor: AppColors.colorWhite,
              isShowBorder: true,
              maxLines: 1,
              maxLength: 4,
              onChanged: (value) {},
            ),
            10.toSizedBoxHeight,
            "CurrentQty".textWidget(
              fontSize: 12,
              fontWeight: FontWeight.w300,

            ),
            5.toSizedBoxHeight,
            CustomTextFormField(
              controller: physicalQtyTextEditingController,
              hintText: "Qty",
              autofocus: true,
              inputFormatterRegex: '[0-9]',
              inputType: TextInputType.number,
              hintColor: AppColors.colorWhite,
              fillColor: AppColors.colorPrimary,
              textColor: AppColors.colorWhite,
              borderColor: AppColors.colorWhite,
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
                      buttonTextColor: AppColors.colorPrimary,
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
                          if (int.parse(thresholdQtyTextEditingController.text
                              .trim()
                              .toString()) ==
                              0) {
                            // showToastMsg('Quantity should not be zero');
                          } else {
                            positiveCallBack(thresholdQtyTextEditingController.text);
                            Navigator.pop(context);
                          }
                        })),
              ],
            ),
            10.toSizedBoxHeight,
          ],
        ));
  }
}
