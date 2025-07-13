import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common/common_button_widget.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_city_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_country_model.dart';
import 'package:sales_app_redesign/features/admin/user/model/get_all_state_model.dart';
import 'package:sales_app_redesign/features/sales/hospital/model/add_hospital_model.dart';
import 'package:sales_app_redesign/features/sales/hospital/model/get_hospital_by_id_model.dart';
import 'package:sales_app_redesign/features/sales/hospital/provider/hospital_provider.dart';

class AddEditHospitalScreen extends StatefulWidget {
  bool? isEdit;
  String? hospitalId;

  AddEditHospitalScreen({super.key, this.isEdit, this.hospitalId});

  @override
  State<AddEditHospitalScreen> createState() => _AddEditHospitalScreenState();
}

class _AddEditHospitalScreenState extends State<AddEditHospitalScreen> {
  late HospitalProvider _hospitalProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
    widget.isEdit == true ?  _hospitalProvider.apiCallGetHospitalByHospitalId(hospitalId: widget.hospitalId) : _hospitalProvider.clearAllVariable();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              isBackVisible: true,
              title: widget.isEdit == true ? "Update Hospital" : "Add Hospital",
              centerTitle: true,
              isCartVisible: false,
            ),
          ),
          body: Stack(
            children: [
              hospitalProvider.isFetching
                  ? CircleLoadingIndicatorWidget()
                  : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shrinkWrap: true,
                    children: [
                      textField(
                        controller: hospitalProvider.hospitalNameController,
                        hintText: "Enter Hospital name",
                      ),
                      textField(
                        controller: hospitalProvider.hospitalEmailController,
                        hintText: "Enter Hospital Email Address",
                      ),
                      textField(
                        controller: hospitalProvider.hospitalPhoneNoController,
                        hintText: "Enter Hospital Phone No",
                      ),
                      textField(
                        controller: hospitalProvider.hospitalAddressController,
                        hintText: "Enter Hospital Address",
                        maxLine: 3,
                      ),
                      10.toSizedBoxHeight,
                      countryDropDown(hospitalProvider),
                      20.toSizedBoxHeight,
                      Row(
                        children: [
                          Expanded(child: stateDropDown(hospitalProvider)),
                          10.toSizedBoxWidth,
                          Expanded(child: cityDropDown(hospitalProvider)),
                        ],
                      ),
                      20.toSizedBoxHeight,
                      widget.isEdit == false
                          ? CommonButtonWidget(
                            buttonText: "Add Hospital",
                            onPressed: () {
                              hospitalProvider.checkValidationForAddUser(
                                context,
                                () {
                                  Navigator.pop(context, true);
                                },
                              );
                            },
                          )
                          : CommonButtonWidget(
                            buttonText: "Update Hospital",
                            onPressed: () {
                              hospitalProvider.checkValidationForEditUser(
                                context,
                                    () {
                                  Navigator.pop(context, true);
                                },
                                widget.hospitalId,
                              );
                            },
                          ),
                    ],
                  ),
              hospitalProvider.isLoading || hospitalProvider.isAdding
                  ? CircleLoadingIndicatorWidget()
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  Widget textField({
    required TextEditingController controller,
    String? hintText,
    int? maxLine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // '$titleText'.textWidget(
        //   color: AppColors.colorWhite,
        //   fontSize: fontSizeNormal, fontWeight: FontWeight.w500,
        //
        // ),
        10.toSizedBoxHeight,
        CustomTextFormField(
          controller: controller,
          hintText: hintText ?? "",
          maxLines: maxLine ?? 1,
          inputType: TextInputType.text,
          hintColor: AppColors.colorLightGrey,
          textColor: AppColors.colorWhite,
          inputAction: TextInputAction.next,
        ),
        10.toSizedBoxHeight,
      ],
    );
  }

  Widget countryDropDown(HospitalProvider hospitalProvider) {
    return AppUtils.commonContainer(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),

      decoration: AppUtils.commonBoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorSecondary, width: 1),
      ),
      // child:
      child: DropdownButton<CountryData>(
        hint: AppUtils.commonTextWidget(
          text:
              hospitalProvider.selectedCountry?.countryName ?? "Select Country",
          letterSpacing: 0.5,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
          textColor: AppColors.colorWhite,
        ),
        value: hospitalProvider.selectedCountry,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.colorPrimary,

        // This removes the underline
        onChanged: (CountryData? value) async {
          hospitalProvider.changeCountry(value);
        },
        items:
            hospitalProvider.getAllCountryModel?.data?.map((CountryData item) {
              return DropdownMenuItem<CountryData>(
                value: item,
                child: AppUtils.commonTextWidget(
                  text: item.countryName ?? "",
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.colorWhite,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget stateDropDown(HospitalProvider hospitalProvider) {
    return AppUtils.commonContainer(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),

      decoration: AppUtils.commonBoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorSecondary, width: 1),
      ),
      // child:
      child: DropdownButton<StateData>(
        hint: AppUtils.commonTextWidget(
          text: hospitalProvider.selectedState?.stateName ?? "Select State",
          letterSpacing: 0.5,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
          textColor: AppColors.colorWhite,
        ),
        value: hospitalProvider.selectedState,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.colorPrimary,

        // This removes the underline
        onChanged: (StateData? value) async {
          hospitalProvider.changeState(value);
        },
        items:
            hospitalProvider.getAllStateModel?.data?.map((StateData item) {
              return DropdownMenuItem<StateData>(
                value: item,
                child: AppUtils.commonTextWidget(
                  text: item.stateName ?? "",
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.colorWhite,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget cityDropDown(HospitalProvider hospitalProvider) {
    return AppUtils.commonContainer(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),

      decoration: AppUtils.commonBoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorSecondary, width: 1),
      ),
      // child:
      child: DropdownButton<CityData>(
        hint: AppUtils.commonTextWidget(
          text: hospitalProvider.selectedCity?.cityName ?? "Select City",
          letterSpacing: 0.5,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
          textColor: AppColors.colorWhite,
        ),
        value: hospitalProvider.selectedCity,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.colorPrimary,

        // This removes the underline
        onChanged: (CityData? value) async {
          hospitalProvider.changeCity(value);
        },
        items:
            hospitalProvider.getAllCityModel?.data?.map((CityData item) {
              return DropdownMenuItem<CityData>(
                value: item,
                child: AppUtils.commonTextWidget(
                  text: item.cityName ?? "",
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.colorWhite,
                ),
              );
            }).toList(),
      ),
    );
  }

  // checkValidation(ProfileProvider profileProvider) {
  //   if (hospitalNameController.text.isEmpty) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Enter Hospital Name",
  //         giveColor: Colors.red);
  //   } else if (hospitalEmailController.text.isEmpty) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Enter Hospital Email",
  //         giveColor: Colors.red);
  //   } else if (!StringCasingExtension.validateEmail(
  //       hospitalEmailController.text)) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Enter Valid Email Address",
  //         giveColor: Colors.red);
  //   } else if (hospitalPhoneNoController.text.isEmpty) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Enter Hospital Phone Number",
  //         giveColor: Colors.red);
  //   } else if (hospitalAddressController.text.isEmpty) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Enter Hospital Address",
  //         giveColor: Colors.red);
  //   } else if (selectedCountryData == null || selectedCountryData == {}) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Select Hospital Country",
  //         giveColor: Colors.red);
  //   } else if (selectedStateData == null || selectedStateData == {}) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Select Hospital State",
  //         giveColor: Colors.red);
  //   } else if (selectedCityData == null || selectedCityData == {}) {
  //     AppUtils.showSnackBarWithColor(
  //         context: context,
  //         message: "Select Hospital City",
  //         giveColor: Colors.red);
  //   } else {
  //
  //     widget.isEdit == true ? callUpdateHospitalApi(profileProvider) : callAddHospitalApi(profileProvider);
  //   }
  // }
}
