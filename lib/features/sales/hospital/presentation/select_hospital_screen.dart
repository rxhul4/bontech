import 'package:action_slider/action_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/genral/cart/model/cart_model.dart';
import 'package:sales_app_redesign/features/genral/cart/provider/cart_provider.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/sales/hospital/model/get_all_hospital.dart';
import 'package:sales_app_redesign/features/sales/hospital/presentation/add_hospital_screen.dart';
import 'package:sales_app_redesign/features/sales/hospital/provider/hospital_provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SelectHospitalScreen extends StatefulWidget {
  CartModel? cartModel;

  SelectHospitalScreen({super.key, this.cartModel});

  @override
  State<SelectHospitalScreen> createState() => _SelectHospitalScreenState();
}

class _SelectHospitalScreenState extends State<SelectHospitalScreen> {
  late HospitalProvider _hospitalProvider;
  late CartProvider _cartProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _hospitalProvider.apiCallGetAllHospital();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AppScaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, appBarSize),
              child: AppBarWidget(
                isBackVisible: true,
                isCartVisible: false,
                title: "Select Hospital",
              ),
            ),
            // appBar: appBarRow(),
            body: Column(
              children: [
                20.toSizedBoxHeight,
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AddEditHospitalScreen(isEdit: false),
                      ),
                    ).then((value) {
                      if (value == true) {
                        hospitalProvider.apiCallGetAllHospital();
                      }
                    });
                  },
                  child: AppUtils.commonContainer(
                    width: double.infinity,
                    padding: AppUtils.edgeInsetsOnly(
                      top: 15,
                      bottom: 15,
                      left: 12,
                    ),
                    decoration: AppUtils.commonBoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: AppColors.colorPrimary,
                          size: 24,
                        ),
                        AppUtils.commonSizedBox(width: 5),
                        "Add Hospital".textWidget(
                          color: AppColors.colorPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ),
                20.toSizedBoxHeight,
                Expanded(
                  child:
                      hospitalProvider.isFetching
                          ? CircleLoadingIndicatorWidget()
                          : hospitalProvider.getAllHospitalModel?.data ==
                                  null ||
                              hospitalProvider
                                      .getAllHospitalModel
                                      ?.data
                                      ?.length ==
                                  0 ||
                              hospitalProvider.getAllHospitalModel?.data == []
                          ? AppUtils.noDataWidget()
                          : Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    hospitalProvider
                                        .getAllHospitalModel
                                        ?.data
                                        ?.length,
                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return RadioListTile<GetAllHospitalData>(
                                    contentPadding: AppUtils.edgeInsetsAll(
                                      allPadding: 0,
                                    ),
                                    title: AppUtils.commonContainer(
                                      margin: EdgeInsets.only(right: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.colorPrimary,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.08),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.colorPrimary
                                                .withOpacity(0.25),
                                            blurRadius: 0,
                                            spreadRadius: 0.0,
                                            offset: const Offset(0, 1.5),
                                          ),
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                            blurRadius: 30,
                                            offset: const Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: AppUtils.edgeInsetsAll(
                                          allPadding: 10,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              // Wraps the entire Column to allow flexible space
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppUtils.commonTextWidget(
                                                    text:
                                                        hospitalProvider
                                                            .getAllHospitalModel
                                                            ?.data?[index]
                                                            .hospitalName ??
                                                        "Hospital Name",
                                                    letterSpacing: 0.5,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    textColor:
                                                        AppColors.colorWhite,
                                                  ),
                                                  AppUtils.commonSizedBox(
                                                    height: 5,
                                                  ),
                                                  AppUtils.commonTextWidget(
                                                    text:
                                                        hospitalProvider
                                                            .getAllHospitalModel
                                                            ?.data?[index]
                                                            .hospitalAddress ??
                                                        "Hospital Address",
                                                    letterSpacing: 0.0,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    textColor:
                                                        AppColors.colorText,
                                                    // maxLines: 2,
                                                    // Optional: Limit lines
                                                    // overflow: TextOverflow
                                                    //     .ellipsis // Optional: Handle overflow
                                                  ),
                                                  AppUtils.commonSizedBox(
                                                    height: 5,
                                                  ),
                                                  AppUtils.commonTextWidget(
                                                    text:
                                                        hospitalProvider
                                                            .getAllHospitalModel
                                                            ?.data?[index]
                                                            .hospitalPhoneNo ??
                                                        "9106793588",
                                                    letterSpacing: 0.0,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    textColor:
                                                        AppColors.colorText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    activeColor: AppColors.colorWhite,

                                    value:
                                        hospitalProvider
                                            .getAllHospitalModel
                                            ?.data?[index] ??
                                        GetAllHospitalData(),
                                    groupValue:
                                        hospitalProvider.selectedHospital,
                                    onChanged: (value) {
                                      if (value != null) {
                                        hospitalProvider.onChangeHospital(
                                          value,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: ActionSlider.standard(
                    action: (controller) {
                      if (hospitalProvider.selectedHospital != null) {
                        AppUtils.showCustomTwoBtnDialog(
                          ctx: context,
                          dialogTitle: "Place Order",
                          dialogBtnTextLeft: "Cancel",
                          dialogBtnTextRight: "Confirm",
                          dialogMessage: "Are you sure you want to place order?",
                          rightPop: true,
                          dialogBtnRightFnc: () {
                            _cartProvider.apiCallAddOrder(
                              productList: widget.cartModel?.productInfo,
                              hospitalId:
                              hospitalProvider.selectedHospital?.hospitalId,
                              callback: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        AppUtils.showSnackBarWithColor(
                          context: context,
                          message: "Select Hospital",
                        );
                      }

                    },
                    sliderBehavior: SliderBehavior.move,
                    rolling: false,
                    backgroundColor: AppColors.colorLightGrey,
                    customForegroundBuilder: (p0, p1, p2) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.gradient1, AppColors.gradient2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.done,
                          color: AppColors.colorWhite,
                          size: 30,
                        ),
                      );
                    },

                    child: Shimmer(
                      child: "Place Order".textWidget(
                        color: AppColors.colorDarkGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget radioWidget(
    List<GetAllHospitalData>? hospitalData,
    HospitalProvider hospitalProvider,
  ) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: hospitalData?.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          contentPadding: AppUtils.edgeInsetsAll(allPadding: 0),
          title: AppUtils.commonContainer(
            width: double.infinity,
            decoration: AppUtils.commonBoxDecoration(
              color: AppColors.colorWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorSecondary.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
              borderRadius: AppUtils.borderRadiusAll(raduis: 12),
            ),
            child: Padding(
              padding: AppUtils.edgeInsetsAll(allPadding: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // Wraps the entire Column to allow flexible space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppUtils.commonTextWidget(
                          text:
                              hospitalData?[index].hospitalName ??
                              "Hospital Name",
                          letterSpacing: 0.5,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          textColor: AppColors.colorPrimary,
                        ),
                        AppUtils.commonSizedBox(height: 5),
                        AppUtils.commonTextWidget(
                          text:
                              hospitalData?[index].hospitalAddress ??
                              "Hospital Address",
                          letterSpacing: 0.0,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          textColor: AppColors.colorText,
                          // maxLines: 2,
                          // Optional: Limit lines
                          // overflow: TextOverflow
                          //     .ellipsis // Optional: Handle overflow
                        ),
                        AppUtils.commonSizedBox(height: 5),
                        AppUtils.commonTextWidget(
                          text:
                              hospitalData?[index].hospitalPhoneNo ??
                              "9106793588",
                          letterSpacing: 0.0,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          textColor: AppColors.colorText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          activeColor: AppColors.colorPrimary,
          value: hospitalData?[index],
          groupValue: hospitalProvider.selectedHospital,
          onChanged: (value) {
            // hospitalProvider.onChangeHospital(value);
          },
        );
      },
    );
  }
}
