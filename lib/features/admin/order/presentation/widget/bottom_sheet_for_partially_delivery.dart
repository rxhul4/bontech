import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common/common_button_widget.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/features/admin/order/model/get_sales_man_order_by_id_model.dart';
import 'package:sales_app_redesign/features/admin/order/model/req_model/partially_delivery_req_model.dart';

class BottomSheetForPartiallyDelivery extends StatefulWidget {
  final List<SalesOrderProductList> salesOrderProductList;
  final Function(List<PartiallyDeliverReqModel> item) positiveCallBack;
  const BottomSheetForPartiallyDelivery({
    super.key,
    required this.salesOrderProductList,
    required this.positiveCallBack,
  });

  @override
  State<BottomSheetForPartiallyDelivery> createState() => _BottomSheetForPartiallyDeliveryState();
}

class _BottomSheetForPartiallyDeliveryState extends State<BottomSheetForPartiallyDelivery> {
  late List<TextEditingController> _controllers;
  late List<String?> _errorMessages;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.salesOrderProductList.length,
          (index) => TextEditingController(),
    );
    _errorMessages = List.generate(widget.salesOrderProductList.length, (index) => null);
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
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: ListView(
        // physics: const sv(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: [
          12.toSizedBoxHeight,
          "Deliver Quantity".textWidget(
            fontSize: 18,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
          12.toSizedBoxHeight,
          ListView.builder(
            itemCount: widget.salesOrderProductList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final product = widget.salesOrderProductList[index];
              final remainingQty = (product.quantity ?? 0) - (product.deliveredQuantity ?? 0);

              return remainingQty != 0 ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "${product.productName ?? 'Product'} (Remaining: $remainingQty)"
                      .textWidget(fontSize: 12, fontWeight: FontWeight.w300),
                  10.toSizedBoxHeight,
                  CustomTextFormField(
                    controller: _controllers[index],
                    hintText: "Qty",
                    autofocus: false,
                    inputFormatterRegex: '[0-9]',
                    inputType: TextInputType.number,
                    hintColor: AppColors.colorWhite,
                    fillColor: AppColors.colorPrimary,
                    textColor: AppColors.colorWhite,
                    borderColor: AppColors.colorWhite,
                    isShowBorder: true,
                    maxLines: 1,
                    maxLength: 4,
                    onChanged: (value) {
                      final entered = int.tryParse(value);
                      setState(() {
                        if (entered != null && entered > remainingQty) {
                          _errorMessages[index] = "You can only deliver up to $remainingQty";
                        } else {
                          _errorMessages[index] = null;
                        }
                      });
                    },
                  ),
                  if (_errorMessages[index] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _errorMessages[index]!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  10.toSizedBoxHeight,
                ],
              ) : SizedBox();
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
                  buttonText: "Submit",
                  onPressed: () {
                    bool hasError = false;
                    List<PartiallyDeliverReqModel> items = [];

                    for (int i = 0; i < widget.salesOrderProductList.length; i++) {
                      final product = widget.salesOrderProductList[i];
                      final remaining = (product.quantity ?? 0) - (product.deliveredQuantity ?? 0);

                      if (remaining == 0) {
                        // Always add with 0 qty
                        items.add(
                          PartiallyDeliverReqModel(
                            productId: product.productId,
                            productSkuId: product.productSKUID,
                            deliveredQuantity: 0,
                          ),
                        );
                        continue; // skip further validation
                      }

                      final entered = int.tryParse(_controllers[i].text);

                      if (entered == null || entered > remaining) {
                        setState(() {
                          _errorMessages[i] = "You can only deliver up to $remaining";
                        });
                        hasError = true;
                      } else {
                        setState(() {
                          _errorMessages[i] = null;
                        });

                        items.add(
                          PartiallyDeliverReqModel(
                            productId: product.productId,
                            productSkuId: product.productSKUID,
                            deliveredQuantity: entered,
                          ),
                        );
                      }
                    }

                    if (!hasError) {
                      widget.positiveCallBack(items);
                      Navigator.pop(context);
                    }
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
}
