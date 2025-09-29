import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/common_two_btn_dialog.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/sales/hospital/presentation/add_hospital_screen.dart';
import 'package:sales_app_redesign/features/sales/hospital/provider/hospital_provider.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  late HospitalProvider _hospitalProvider;

  //Variables

  // //DefineModel
  // GetAllHospitalModel? getAllHospitalModel;
  // CommonResponseModel? commonResponseModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
    _hospitalProvider.apiCallGetAllHospital();
  }

  //ApiCallFunctions-

  //DeleteHospitalApiFunction
  // callDeleteHospital(ProfileProvider profileProvider, String? hospitalId) {
  //   profileProvider
  //       .apiCallDeleteHospital(hospitalId: hospitalId)
  //       .then((value) async {
  //     commonResponseModel = value;
  //     if (commonResponseModel?.isError == false &&
  //         commonResponseModel?.isValidationFailed == false) {
  //       await callGetAllHospital(profileProvider);
  //     } else {
  //       AppUtils.showCustomDialog(
  //           ctx: context, dialogMessage: getAllHospitalModel?.message);
  //     }
  //   });
  // }

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
              preferredSize: const Size.fromHeight(appBarSize),
              child: AppBarWidget(
                title: "Hospital",
                isBackVisible: true,
                isCartVisible: false,
              ),
            ),
            body: body(hospitalProvider),
          ),
        );
      },
    );
  }

  Widget body(HospitalProvider hospitalProvider) {
    return Column(
      children: [
        20.toSizedBoxHeight,
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditHospitalScreen(isEdit: false,),
                )).then((value) {
                  if(value == true){
                    hospitalProvider.apiCallGetAllHospital();
                  }

            });
          },
          child: AppUtils.commonContainer(
            width: double.infinity,
            padding: AppUtils.edgeInsetsOnly(top: 15, bottom: 15, left: 12),
            decoration: AppUtils.commonBoxDecoration(color: Colors.white),
            child: Row(
              children: [
                const Icon(Icons.add, color: AppColors.colorPrimary, size: 24),
                AppUtils.commonSizedBox(width: 5),
                AppUtils.commonTextWidget(
                  text: "Add Hospital",
                  textColor: AppColors.colorPrimary,
                  fontSize: 14,
                  letterSpacing: 0.5,
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
                  : hospitalProvider.getAllHospitalModel?.data == null ||
                      (hospitalProvider.getAllHospitalModel?.data?.length ??
                              0) ==
                          0
                  ? Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: AppUtils.noDataWidget(),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        hospitalProvider.getAllHospitalModel?.data?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: AppUtils.edgeInsetsOnly(
                          top: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEditHospitalScreen(
                                        isEdit: true,
                                        hospitalId: hospitalProvider
                                            .getAllHospitalModel
                                            ?.data?[index]
                                            .hospitalId,
                                      ),
                                )).then((value) {
                                  if(value == true){
                                    hospitalProvider.apiCallGetAllHospital();
                                  }
                            });
                          },
                          child: Slidable(
                            key: UniqueKey(),
                            endActionPane: ActionPane(
                              extentRatio: 0.20,
                              dragDismissible: false,
                              // openThreshold: 0.1,
                              // closeThreshold: 0.1,
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(
                                dismissalDuration: const Duration(
                                  milliseconds: 1000,
                                ),
                                dismissThreshold: 0.1,
                                onDismissed: () {},
                              ),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) async {
                                    showDialog(context: context, builder:(context) {
                                      return CommonTwoBtnDialog(
                                        dialogTitle: "Remove",
                                        dialogMessage: "Are you sure do you want to Remove this Hospital!",
                                        dialogBtnTextRight: "Delete",

                                        dialogBtnRightFnc: () {
                                          hospitalProvider.apiCallDeleteHospital(
                                            hospitalId:
                                            hospitalProvider
                                                .getAllHospitalModel
                                                ?.data?[index]
                                                .hospitalId,
                                          );
                                        },
                                      );
                                    });

                                  },
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  backgroundColor: AppColors.colorTransparent,
                                  foregroundColor: AppColors.colorLightGrey,
                                  child: Icon(
                                    Icons.delete,
                                    size: 26,
                                    color: AppColors.colorWhite,
                                  ),
                                  // label: 'Delete',
                                ),
                              ],
                            ),
                            child: Frost(
                              width: double.infinity,
                              // decoration: BoxDecoration(
                              //   color: AppColors.colorPrimary,
                              //   borderRadius: BorderRadius.circular(12),
                              //   border: Border.all(
                              //     color: Colors.white.withOpacity(0.08),
                              //   ),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: AppColors.colorPrimary.withOpacity(
                              //         0.25,
                              //       ),
                              //       blurRadius: 0,
                              //       spreadRadius: 0.0,
                              //       offset: const Offset(0, 1.5),
                              //     ),
                              //     BoxShadow(
                              //       color: Colors.black.withOpacity(0.6),
                              //       blurRadius: 30,
                              //       offset: const Offset(0, 12),
                              //     ),
                              //   ],
                              // ),
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
                                          "${hospitalProvider.getAllHospitalModel?.data?[index].hospitalName ?? "Hospital Name"}"
                                              .textWidget(
                                                color: AppColors.colorWhite,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          AppUtils.commonSizedBox(height: 5),
                                          "${hospitalProvider.getAllHospitalModel?.data?[index].hospitalAddress ?? "Hospital Name"}"
                                              .textWidget(
                                                color: AppColors.colorWhite,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          AppUtils.commonSizedBox(height: 5),
                                          "+ 91${hospitalProvider.getAllHospitalModel?.data?[index].hospitalPhoneNo ?? "Hospital Name"}"
                                              .textWidget(
                                                color: AppColors.colorWhite,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
