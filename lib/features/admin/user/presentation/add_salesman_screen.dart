import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:sales_app_redesign/features/admin/user/provider/user_provider.dart';

class AddUserScreen extends StatefulWidget {
  bool? isEdit;
  String? userId;

  AddUserScreen({super.key, this.isEdit, this.userId});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late UserProvider? _userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.isEdit == true) {
      _userProvider?.apiCallGetUserById(widget.userId ?? "");
    } else {
      _userProvider?.clearAllVariable();
    }

    // _userProvider?.apiCallGetAllCountry();

    // api call get by id
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              isBackVisible: true,
              title: widget.isEdit == true ? "Edit Salesman" : "Add Salesman",
              centerTitle: true,
              isCartVisible: false,
            ),
          ),
          body: Stack(
            children: [
              userProvider.isFetching
                  ? CircleLoadingIndicatorWidget()
                  : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shrinkWrap: true,
                    children: [
                      10.toSizedBoxHeight,
                      imageWidget(userProvider),
                      30.toSizedBoxHeight,
                      textField(
                        controller: userProvider.userNameController,
                        hintText: "Enter Full name",
                      ),
                      textField(
                        controller: userProvider.emailController,
                        hintText: "Enter Email Address",
                      ),
                      textField(
                        controller: userProvider.phoneNumberController,
                        hintText: "Enter Phone No",
                      ),
                      widget.isEdit == false
                          ? textField(
                            controller: userProvider.passwordController,
                            hintText: "Enter Password",
                          )
                          : SizedBox(),
                      textField(
                        controller: userProvider.pinCodeController,
                        hintText: "Enter Pincode",
                      ),
                      textField(
                        controller: userProvider.addressController,
                        hintText: "Enter Address",
                        maxLine: 3,
                      ),
                      10.toSizedBoxHeight,
                      countryDropDown(userProvider),
                      20.toSizedBoxHeight,
                      stateDropDown(userProvider),
                      20.toSizedBoxHeight,
                      cityDropDown(userProvider),
                      20.toSizedBoxHeight,
                      widget.isEdit == false
                          ? CommonButtonWidget(
                            buttonText: "Add Salesman",
                            onPressed: () {
                              userProvider.checkValidationAddUser(context, () {
                                Navigator.pop(context, true);
                              });
                            },
                          )
                          : CommonButtonWidget(
                            buttonText: "Update Salesman",
                            onPressed: () {
                              userProvider.checkValidationEditUser(
                                context,
                                widget.userId,
                                () {
                                  Navigator.pop(context, true);
                                },
                              );
                            },
                          ),
                    ],
                  ),
              userProvider.isLoading || userProvider.isAdding
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
          inputType: TextInputType.emailAddress,
          hintColor: AppColors.colorLightGrey,
          textColor: AppColors.colorWhite,
          inputAction: TextInputAction.next,
        ),
        10.toSizedBoxHeight,
      ],
    );
  }

  Widget countryDropDown(UserProvider userProvider) {
    return AppUtils.commonContainer(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),

      decoration: AppUtils.commonBoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorSecondary, width: 1),
      ),
      // child:
      child: DropdownButton<CountryData>(
        hint: AppUtils.commonTextWidget(
          text: userProvider.selectedCountry?.countryName ?? "Select Country",
          letterSpacing: 0.5,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
          textColor: AppColors.colorWhite,
        ),
        value: userProvider.selectedCountry,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.colorPrimary,

        // This removes the underline
        onChanged: (CountryData? value) async {
          userProvider.changeCountry(value);
        },
        items:
            userProvider.getAllCountryModel?.data?.map((CountryData item) {
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

  Widget stateDropDown(UserProvider userProvider) {
    return AppUtils.commonContainer(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),

      decoration: AppUtils.commonBoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorSecondary, width: 1),
      ),
      // child:
      child: DropdownButton<StateData>(
        hint: AppUtils.commonTextWidget(
          text: userProvider.selectedState?.stateName ?? "Select State",
          letterSpacing: 0.5,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
          textColor: AppColors.colorWhite,
        ),
        value: userProvider.selectedState,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.colorPrimary,

        // This removes the underline
        onChanged: (StateData? value) async {
          userProvider.changeState(value);
        },
        items:
            userProvider.getAllStateModel?.data?.map((StateData item) {
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

  Widget cityDropDown(UserProvider userProvider) {
    return AppUtils.commonContainer(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),

      decoration: AppUtils.commonBoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorSecondary, width: 1),
      ),
      // child:
      child: DropdownButton<CityData>(
        hint: AppUtils.commonTextWidget(
          text: userProvider.selectedCity?.cityName ?? "Select City",
          letterSpacing: 0.5,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
          textColor: AppColors.colorWhite,
        ),
        value: userProvider.selectedCity,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.colorPrimary,

        // This removes the underline
        onChanged: (CityData? value) async {
          userProvider.changeCity(value);
        },
        items:
            userProvider.getAllCityModel?.data?.map((CityData item) {
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

  Widget imageWidget(UserProvider? userProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            AppUtils.commonContainer(
              height: 120,
              width: 120,
              padding: EdgeInsets.all(5),
              decoration: AppUtils.commonBoxDecoration(
                border: Border.all(color: AppColors.colorWhite, width: 1),
                borderRadius: AppUtils.borderRadiusAll(raduis: 12),
                color: AppColors.colorWhite,
              ),
              child:
                  userProvider?.image == null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          height: 120,
                          width: 120,
                          imageUrl: userProvider?.imageUrl ?? '',
                          imageBuilder:
                              (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          placeholder:
                              (context, url) =>
                                  Center(child: CircleLoadingIndicatorWidget()),
                          errorWidget: (context, url, error) {
                            return Icon(
                              Icons.image,
                              size: 50,
                              color: AppColors.colorPrimary,
                            );
                          },
                        ),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(userProvider?.image?.path ?? ''),
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
            ),
            5.toSizedBoxHeight,
            userProvider?.image != null
                ? TextButton(
                  onPressed: () {
                    userProvider?.deleteImage();
                  },
                  child: AppUtils.commonTextWidget(
                    text: "Delete Image",
                    letterSpacing: 0.5,
                    textColor: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.colorPrimary,
                  ),
                  onPressed: () {
                    userProvider?.getImage();
                  },
                  child: AppUtils.commonTextWidget(
                    text: (widget.isEdit ?? false) ? "Edit Image" : "Add Image",
                    letterSpacing: 0.5,
                    textColor: AppColors.colorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
