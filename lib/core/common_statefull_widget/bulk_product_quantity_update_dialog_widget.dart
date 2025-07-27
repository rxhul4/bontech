import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';

import '../common/common_button_widget.dart';
import '../constants/app_size_constants.dart';

class BulkProductQtyUpdateDialogWidget extends StatefulWidget {
  const BulkProductQtyUpdateDialogWidget({
    super.key,
    this.productList,
    required this.positiveCallBack,
  });

  final List<SalesOrderProductList>? productList;
  final Function() positiveCallBack;

  @override
  State<BulkProductQtyUpdateDialogWidget> createState() =>
      _BulkProductQtyUpdateDialogWidgetState();
}

class _BulkProductQtyUpdateDialogWidgetState
    extends State<BulkProductQtyUpdateDialogWidget> {
  late List<TextEditingController> _controllers;
  late List<String?> _errorMessages;
  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.productList?.length ?? 0,
          (index) => TextEditingController(
        text: widget.productList?[index].quantity?.toInt().toString() ?? '',
      ),
    );

    _errorMessages = List.filled(widget.productList?.length ?? 0, null);
  }


  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.95,
      child: ListView(
        shrinkWrap: true,
        children: [
          12.toSizedBoxHeight,
          ListView.builder(
            itemCount: widget.productList?.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _listItem1(widget.productList?[index], _controllers[index],index);
            },
          ),
          16.toSizedBoxHeight,
          Row(
            children: [
              Expanded(
                child: CommonButtonWidget(
                  borderRadius: 10,
                  buttonText: "Cancel",
                  buttonTextColor: AppColors.colorMainBlack,

                  onPressed: () {
                    Navigator.pop(context);
                  },
                  verticalPadding: 10,
                  buttonBgColor: AppColors.colorBg,
                ),
              ),
              12.toSizedBoxWidth,
              Expanded(
                child: CommonButtonWidget(
                  borderRadius: 10,
                  buttonText: "Update",
                  onPressed: () {
                    // Collect updated quantities
                    for (int i = 0; i < _controllers.length; i++) {
                      final newQty = int.tryParse(_controllers[i].text);
                      if (newQty != null) {
                        widget.productList?[i].quantity = newQty;
                      }
                    }

                    widget.positiveCallBack();
                    Navigator.pop(context);
                  },
                  verticalPadding: 10,
                ),
              ),
            ],
          ),
          10.toSizedBoxHeight,
        ],
      ),
    );
  }

  Widget _listItem1(SalesOrderProductList? item, TextEditingController controller, int index) {
    final errorText = _errorMessages[index];
    final hasError = errorText != null;

    final deliveredQty = item?.deliveredQuantity ?? 0;
    final initialQty = item?.quantity ?? 0;
    final remainingQty = initialQty - deliveredQty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Tooltip(
        message: errorText ?? '',
        textStyle: const TextStyle(color: Colors.white),
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(4),
        ),
        showDuration: const Duration(seconds: 2),
        preferBelow: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.colorPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hasError ? Colors.red : Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: AppColors.colorPrimary.withOpacity(0.25),
                blurRadius: 0,
                spreadRadius: 0.0,
                offset: const Offset(0, 1.5),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: '${item?.productName}'.textWidget(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeNormal + 1,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 80,
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final newQty = int.tryParse(value);
                    setState(() {
                      if (newQty != null && newQty > remainingQty) {
                        _errorMessages[index] =
                        'Cannot exceed remaining qty ($remainingQty)';
                      } else {
                        _errorMessages[index] = null;
                      }
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Qty',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: AppConstants.fontFamilyPoppins,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : AppColors.colorDarkGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : AppColors.colorSecondary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : AppColors.colorDarkGrey,
                        width: 1,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: AppConstants.fontFamilyPoppins,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
