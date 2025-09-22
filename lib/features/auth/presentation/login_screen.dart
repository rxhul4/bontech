import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/capitlize_string.dart';
import 'package:sales_app_redesign/core/common/common_button_widget.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/image_strings.dart';
import 'package:sales_app_redesign/features/admin/dashboard_ad/dashboard_ad.dart';
import 'package:sales_app_redesign/features/auth/model/login_model.dart';
import 'package:sales_app_redesign/features/auth/provider/auth_provider.dart';
import 'package:sales_app_redesign/features/sales/dashboard/dashboard.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  ValueNotifier<bool> isObscure = ValueNotifier(false);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginModel? loginModel;

  callLogInApi(AuthProvider postMdl) {
    FocusScope.of(context).unfocus();

    print("yess");
    postMdl
        .apiCallLogin(
        email: emailController.text, password: passwordController.text)
        .then((value) {
      loginModel = value;
      if (loginModel?.isError == false &&
          loginModel?.isValidationFailed == false) {
        saveDataToPrefAndRedirect(loginModel);
      } else {
        AppUtils.showCustomDialog(
            ctx: context, dialogMessage: loginModel?.message);
      }
    });
  }

  saveDataToPrefAndRedirect(LoginModel? loginModel)  {
    saveDataToPref().then((value) async {
      if (loginModel?.data?.totUserTypeId == AppConstants.userTypeDistributor) {
       await  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreenAD(),
            ),
                (route) => false);
      }
      if (loginModel?.data?.totUserTypeId == AppConstants.userTypeSalesMen) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ),
                (route) => false);
      }
    });
  }

  Future<bool> saveDataToPref() async {
    print("set userId ${loginModel?.data?.userId}");
    print("set userTypeId ${loginModel?.data?.totUserTypeId}");
    print("orgId ${loginModel?.data?.organization?.orgId ?? ""}");
    PreferenceHelper.setBool(PreferenceHelper.IS_LOGIN, true);
    PreferenceHelper.setString(PreferenceHelper.USER_IMAGE, loginModel?.data?.userProfilePic ?? "");
    PreferenceHelper.setString(PreferenceHelper.USER_ID, loginModel?.data?.userId ?? "");
    PreferenceHelper.setString(PreferenceHelper.USER_EMAIL, loginModel?.data?.userEmail ?? "");
    PreferenceHelper.setString(PreferenceHelper.PARENT_ID, loginModel?.data?.parentId ?? "");
    PreferenceHelper.setString(PreferenceHelper.USER_NAME, loginModel?.data?.userName ?? "");
    PreferenceHelper.setString(PreferenceHelper.ORG_ID, loginModel?.data?.organization?.orgId ?? "");
    PreferenceHelper.setString(PreferenceHelper.ORG_NAME, loginModel?.data?.organization?.orgName ?? "");
    PreferenceHelper.setString(PreferenceHelper.ORG_TYPE_ID, loginModel?.data?.organization?.totOrgTypeId ?? "");
    PreferenceHelper.setString(PreferenceHelper.JWT_TOKEN, loginModel?.data?.token ?? "");
    PreferenceHelper.setString(PreferenceHelper.USER_TYPE_ID, loginModel?.data?.totUserTypeId ?? "");
    print("data : ${PreferenceHelper.getBool(PreferenceHelper.IS_LOGIN)}");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final postMdl = Provider.of<AuthProvider>(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: AppScaffold(
          // bgColor: AppColors.colorPrimary,
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: AppUtils.edgeInsetsOnly(left: 20, right: 20, top: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppUtils.imageWidget(
                            image: icAppMainLogo,
                            ctx: context,
                            fit: BoxFit.cover,
                            color: AppColors.colorWhite,
                            height: 120),

                        AppUtils.commonSizedBox(height: AppConstants.fifty),
                        AppUtils.commonTextWidget(
                            text: "Login",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            textColor: AppColors.colorWhite,
                            fontFamily: AppConstants.fontFamilyPoppins),
                        AppUtils.commonSizedBox(height: AppConstants.thirty),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "Email",
                          inputType: TextInputType.emailAddress,
                          hintColor: AppColors.colorLightGrey,
                          textColor: AppColors.colorWhite,
                          inputAction: TextInputAction.next,
                        ),
                        // CommonTextField(
                        //   hintText: "Email",
                        //   controller: emailController,
                        //   hintTextColor: AppColors.colorText,
                        //   inputTextColor: AppColors.colorWhite,
                        //   enabledBorderColor: AppColors.colorWhite,
                        //   textInputType: TextInputType.emailAddress,
                        //   textInputAction: TextInputAction.next,
                        //   prefixIcon: Icon(Icons.email),
                        // ),
                        AppUtils.commonSizedBox(height: AppConstants.twenty),

                        CustomTextFormField(
                          controller: passwordController,
                          // _authenticationCubit.passwordEditController,
                          hintText: "Password",
                          isShowSuffixIcon: true,
                          isPassword: true,
                          hintColor: AppColors.colorLightGrey,
                          textColor: AppColors.colorWhite,
                          inputAction: TextInputAction.go,
                        ),
                        // ValueListenableBuilder<bool>(
                        //     valueListenable: isObscure,
                        //     builder: (context, value, child) {
                        //       return CommonTextField(
                        //         hintText: "Password",
                        //         controller: passwordController,
                        //         maxLines: 1,
                        //         textInputType: TextInputType.visiblePassword,
                        //         hintTextColor: AppColors.colorText,
                        //         inputTextColor: AppColors.colorSecondary,
                        //         prefixIcon: Icon(Icons.lock),
                        //         contentPadding: AppUtils.edgeInsetsOnly(
                        //             top: 13, left: 10, right: 10),
                        //         obscureText: !isObscure.value,
                        //         suffixIcon: IconButton(
                        //             icon: !isObscure.value
                        //                 ? Icon(Icons.visibility_off,
                        //                     color: AppColors.colorText,
                        //                     size: 22)
                        //                 : Icon(Icons.visibility,
                        //                     color: AppColors.colorText,
                        //                     size: 22),
                        //             onPressed: () {
                        //               isObscure.value = !isObscure.value;
                        //             }),
                        //       );
                        //     }),
                        AppUtils.commonSizedBox(height: AppConstants.fifty),
                        CommonButtonWidget(
                            isLoading: postMdl.isLoading,
                            buttonText: "Log In",
                            onPressed: () {
                              checkValidation(postMdl);
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              // Center(
              //     child: postMdl.isLoading
              //         ? AppUtils.loaderWidget()
              //         : AppUtils.commonSizedBox()),
            ],
          ),
        ));
  }

  checkValidation(AuthProvider postMdl) {
    if (emailController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context, message: "Enter Email", giveColor: Colors.red);
    } else if (!StringCasingExtension.validateEmail(emailController.text)) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter Valid Email Address",
          giveColor: Colors.red);
    } else if (passwordController.text.isEmpty) {
      AppUtils.showSnackBarWithColor(
          context: context, message: "Enter Password", giveColor: Colors.red);
    } else if (passwordController.text.length < 8) {
      AppUtils.showSnackBarWithColor(
          context: context,
          message: "Enter atleast 8 Password",
          giveColor: Colors.red);
    } else {
      callLogInApi(postMdl);
    }
  }
}
