import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/genral/cart/model/cart_model.dart';
import 'package:sales_app_redesign/features/genral/cart/provider/cart_provider.dart';
import 'package:sales_app_redesign/features/genral/instruments/model/intrument_model.dart';
import 'package:sales_app_redesign/features/genral/instruments/pages/widgets/instrument_form.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';

import '../../../../core/utils/common_function.dart' show convertJsonToString;

class AddInstrumentsScreen extends StatefulWidget {
  List<Product>? productInfo;

  AddInstrumentsScreen({super.key, this.productInfo});

  @override
  State<AddInstrumentsScreen> createState() => _AddInstrumentsScreenState();
}

class _AddInstrumentsScreenState extends State<AddInstrumentsScreen> {
  // Now we store keys targeted at the InstrumentFormState
  List<int> formList = [0];
  List<GlobalKey<InstrumentFormState>> formKeys = [
    GlobalKey<InstrumentFormState>(),
  ];

  CartModel? cartModel;
  InstrumentModel? instrumentModel;
  late CartProvider _instrumentProvider;

  /// Add a new instrument form dynamically
  void _addInstrumentForm() {
    setState(() {
      formList.add(formList.length);
      formKeys.add(GlobalKey<InstrumentFormState>());
    });
  }

  void _submitForms() async {
    bool allValid = true;
    List<InstrumentModel> instrumentsToAdd = [];

    for (int i = 0; i < formKeys.length; i++) {
      final formState = formKeys[i].currentState;

      if (formState == null) {
        allValid = false;
        continue;
      }

      // Validate each instrument form
      final isValid = (formState as dynamic).validateForm();

      if (isValid) {
        // Collect form data
        InstrumentModel data = (formState as dynamic).getFormData();

        instrumentsToAdd.add(data);
      } else {
        allValid = false;
      }
    }

    if (allValid) {
      // await addToCartData(instrumentsToAdd);

      //api call
      _instrumentProvider.apiCallAddOrderAD(
        productList: widget.productInfo,
        instrumentList: instrumentsToAdd,
        callback: () {
          Navigator.pop(context, true);
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ All forms valid! Submitting...")),
      );

      debugPrint("📦 Final Instruments Data: $instrumentsToAdd");
      // Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Please fix the errors before submitting."),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _instrumentProvider = Provider.of<CartProvider>(context, listen: false);
    if (kDebugMode) {
      print("Length of ProductData${widget.productInfo?.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, appBarSize),
        child: const AppBarWidget(
          isBackVisible: true,
          title: "INSTRUMENTS",
          isCartVisible: false,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: formList.length + 1,
              itemBuilder: (context, index) {
                if (index == formList.length) {
                  // Add button
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: _addInstrumentForm,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: AppUtils.commonGradientBoxDecoration(),
                        child: "Add Instrument".textWidget(
                          color: AppColors.colorWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                } else {
                  // Each form — pass the GlobalKey<InstrumentFormState> as the widget key
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InstrumentForm(key: formKeys[index]),
                  );
                }
              },
            ),
          ),

          /// Sticky Submit Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: _submitForms,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: AppUtils.commonGradientBoxDecoration(),
                child: "Confirm Order".textWidget(
                  color: AppColors.colorWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
