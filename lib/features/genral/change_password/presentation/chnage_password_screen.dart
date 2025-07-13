import 'package:flutter/material.dart';
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
import 'package:sales_app_redesign/core/utils/image_strings.dart';
import 'package:sales_app_redesign/features/auth/provider/auth_provider.dart';
import 'package:sales_app_redesign/features/genral/change_password/model/change_password_model.dart';

class CommonChangePasswordScreen extends StatefulWidget {
  const CommonChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CommonChangePasswordScreen> createState() =>
      _CommonChangePasswordScreenState();
}

class _CommonChangePasswordScreenState
    extends State<CommonChangePasswordScreen> {
  late AuthProvider _authProvider;

  TextEditingController newPassController = TextEditingController();
  TextEditingController conNewPassController = TextEditingController();

  ChangePasswordModel? changePasswordModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  callChangePasswordApi() {
    FocusScope.of(context).unfocus();
    _authProvider.apiCallChangePassword(
      newPassword: newPassController.text,
      onSuccess: () {
        Navigator.pop(context);
        AppUtils.showSnackBarWithColor(
          context: context,
          message: changePasswordModel?.message ?? '',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AppScaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, appBarSize),
              child: AppBarWidget(
                centerTitle: true,
                title: "Change Password",
                isCartVisible: false,
                isBackVisible: true,
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: AppUtils.edgeInsetsOnly(left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppUtils.commonSizedBox(height: 30),
                        Column(
                          children: [
                            AppUtils.commonSizedBox(
                              height: 175,
                              child: Image.asset(ic_change_pass),
                            ),
                            AppUtils.commonSizedBox(height: 10),
                            AppUtils.commonTextWidget(
                              text: "Let's get you a new password",
                              textColor: AppColors.colorPrimary,
                            ),
                          ],
                        ),

                        AppUtils.commonSizedBox(height: 30),
                        CustomTextFormField(
                          controller: newPassController,
                          hintText: "New Password",
                          hintColor: AppColors.colorWhite,
                          textColor: AppColors.colorWhite,
                        ),
                        20.toSizedBoxHeight,
                        CustomTextFormField(
                          controller: conNewPassController,
                          hintText: "Confirm New Password",
                          hintColor: AppColors.colorWhite,
                          textColor: AppColors.colorWhite,

                        ),
                        20.toSizedBoxHeight,
                        CommonButtonWidget(

                          buttonText: "Submit",
                          onPressed: () {
                            checkValidation(authProvider);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                authProvider.isLoading
                    ? CircleLoadingIndicatorWidget()
                    : AppUtils.commonSizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  checkValidation(AuthProvider postMdl) {
    if (newPassController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter New Password",
          giveColor: AppColors.colorSecondary

      );
    } else if (conNewPassController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "Enter Confirm New Password",
          giveColor: AppColors.colorSecondary

      );
    } else if (newPassController.text != conNewPassController.text) {
      AppUtils.showSnackBarWithColor(
        context: context,
        message: "New Password and Confirm New Password is not matching",
        giveColor: AppColors.colorSecondary
      );
    } else {
      callChangePasswordApi();
    }
  }
}
