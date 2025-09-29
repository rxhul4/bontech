import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/image_strings.dart';
import 'package:sales_app_redesign/features/admin/user/presentation/add_salesman_screen.dart';
import 'package:sales_app_redesign/features/admin/user/provider/user_provider.dart';

import '../../../../core/common_statefull_widget/app_bar_widget.dart';

class SalesManScreenAd extends StatefulWidget {
  SalesManScreenAd({super.key});

  @override
  State<SalesManScreenAd> createState() => _SalesManScreenAdState();
}

class _SalesManScreenAdState extends State<SalesManScreenAd> {
  late UserProvider? _userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider?.apiCallGetSalesManList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return AppScaffold(
          floatingActionButton: floatingActionButton(userProvider),
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, appBarSize),
            child: AppBarWidget(
              centerTitle: true,
              title: "Salesman",
              isBackVisible: true,
              isCartVisible: false,
              isAdmin: false,
            ),
          ),
          body:
              userProvider.isFetching
                  ? CircleLoadingIndicatorWidget()
                  : (userProvider.getSalesManListModel?.data == []) ||
                      (userProvider.getSalesManListModel?.data?.length == 0)
                  ? AppUtils.noDataWidget()
                  : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userProvider.getSalesManListModel?.data?.length,
                    itemBuilder: (context, index) {
                      final user =
                          userProvider.getSalesManListModel?.data?[index];
                      return Padding(
                        padding: AppUtils.edgeInsetsOnly(left: 10, right: 10),
                        child: Column(
                          children: [
                            AppUtils.commonSizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddUserScreen(
                                              isEdit: true,
                                              userId:user?.userId),
                                    )).then((value) {
                                      if(value == true){
                                        userProvider.apiCallGetSalesManList();
                                      }

                                  // apiCallCallbackFnc(postMdl);
                                });
                              },
                              child: Frost(
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(12),
                                //   color: AppColors.colorLightGrey,
                                // ),
                                child: Slidable(
                                  key: UniqueKey(),
                                  endActionPane: ActionPane(
                                    extentRatio: 0.20,
                                    dragDismissible: false,
                                    // openThreshold: 0.1,
                                    // closeThreshold: 0.1,
                                    motion: ScrollMotion(),
                                    dismissible: DismissiblePane(
                                      dismissalDuration: Duration(
                                        milliseconds: 1000,
                                      ),
                                      dismissThreshold: 0.1,
                                      // confirmDismiss: () async {
                                      //   print("innnnnn");
                                      //   setState(() {
                                      //     postMdl.getSalesManListModel?.data?.removeAt(index);
                                      //   });
                                      //   return true;
                                      // },
                                      onDismissed: () {},
                                    ),
                                    children: [
                                      CustomSlidableAction(
                                        // An action can be bigger than the others.
                                        // flex: 2,
                                        onPressed: (context) {
                                          AppUtils.showCustomTwoBtnDialog(
                                            ctx: context,
                                            dialogBtnTextRight: "Yes",
                                            dialogBtnTextLeft: "No",
                                            dialogMessage:
                                                "Are you sure you want to delete the user?",
                                            dialogTitle: "Alert",
                                            dialogBtnRightFnc: () {
                                              if (user?.userId != null &&
                                                  user?.userId != "") {
                                                userProvider.apiCallDeleteUser(
                                                  user?.userId ?? "",
                                                );
                                              }
                                            },
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        backgroundColor: AppColors.colorTransparent,
                                        foregroundColor: AppColors.colorPrimary,
                                        child: Icon(
                                          Icons.delete,
                                          size: 26,
                                          color: AppColors.colorWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: Frost(
                                    width: double.infinity,

                                    child: Padding(
                                      padding: AppUtils.edgeInsetsAll(
                                        allPadding: 8,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment
                                        // .center,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: AppColors.colorLightGrey
                                                  .withOpacity(
                                                    0.15,
                                                  ), // Base layer
                                            ),
                                            child: (user?.userProfilePic ?? '')
                                                .toNetWorkImage(
                                                  height: 100,
                                                  width: 90,
                                                  borderRadius: 12,
                                                  // height: 90,
                                                  // width: 75,
                                                  fit: BoxFit.cover,
                                                ),
                                          ),
                                          AppUtils.commonSizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: (user?.userName ??
                                                              '')
                                                          .textWidget(
                                                            fontSize:
                                                                fontSizeMedium,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                AppColors
                                                                    .colorWhite,
                                                          ),
                                                    ),

                                                    // 5.toSizedBoxWidth,
                                                  ],
                                                ),
                                                5.toSizedBoxHeight,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    'Email : '.richTextView(
                                                      fontFamily:
                                                          AppConstants
                                                              .fontFamilyPoppins,
                                                      fontSize: fontSizeSmall,
                                                      color:
                                                          AppColors
                                                              .colorLightGrey,
                                                      textSpanList: [
                                                        const WidgetSpan(
                                                          child: SizedBox(
                                                            width: 2,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              user?.userEmail ??
                                                              'N/A',
                                                          style: TextStyle(
                                                            color:
                                                                AppColors
                                                                    .colorWhite,
                                                            fontSize:
                                                                fontSizeSmall,
                                                            fontFamily:
                                                                AppConstants
                                                                    .fontFamilyPoppins,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    2.toSizedBoxHeight,
                                                    // 'Color : '.richTextView(
                                                    //     color: AppColors.colorLightGrey,
                                                    //     textSpanList: [
                                                    //       const WidgetSpan(
                                                    //           child: SizedBox(width: 4)),
                                                    //       TextSpan(
                                                    //           text: item?.,
                                                    //           style: const TextStyle(
                                                    //             color: AppColors.colorWhite,
                                                    //             fontWeight: FontWeight.bold,
                                                    //           ))
                                                    //     ]),
                                                    // 2.toSizedBoxHeight,
                                                    // (item?.selectedMaterial?.name ?? 'N/A')
                                                    //     .textWidget(
                                                    //         color: AppColors.colorPrimary,
                                                    //         fontWeight: FontWeight.bold),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    'Phone no : '.richTextView(
                                                      fontFamily:
                                                          AppConstants
                                                              .fontFamilyPoppins,
                                                      fontSize: fontSizeSmall,
                                                      color:
                                                          AppColors
                                                              .colorLightGrey,
                                                      textSpanList: [
                                                        const WidgetSpan(
                                                          child: SizedBox(
                                                            width: 2,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '+91 ${user?.phoneNo}',
                                                          style: TextStyle(
                                                            color:
                                                                AppColors
                                                                    .colorWhite,
                                                            fontSize:
                                                                fontSizeSmall,
                                                            fontFamily:
                                                                AppConstants
                                                                    .fontFamilyPoppins,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    2.toSizedBoxHeight,
                                                    // 'Color : '.richTextView(
                                                    //     color: AppColors.colorLightGrey,
                                                    //     textSpanList: [
                                                    //       const WidgetSpan(
                                                    //           child: SizedBox(width: 4)),
                                                    //       TextSpan(
                                                    //           text: item?.,
                                                    //           style: const TextStyle(
                                                    //             color: AppColors.colorWhite,
                                                    //             fontWeight: FontWeight.bold,
                                                    //           ))
                                                    //     ]),
                                                    // 2.toSizedBoxHeight,
                                                    // (item?.selectedMaterial?.name ?? 'N/A')
                                                    //     .textWidget(
                                                    //         color: AppColors.colorPrimary,
                                                    //         fontWeight: FontWeight.bold),
                                                  ],
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
                            ),
                            AppUtils.commonSizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }

  Widget floatingActionButton(UserProvider userProvider) {
    return AppUtils.commonInkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(
                isEdit: false,
              ),
            )).then((value) {
              print("value$value");
              if(value == true){
                userProvider.apiCallGetSalesManList();
              }
          // apiCallCallbackFnc(postMdl);
        });
      },
      borderRadius: BorderRadius.circular(360),
      child: AppUtils.commonContainer(
        padding: EdgeInsets.all(18),
        decoration: AppUtils.commonGradientBoxDecoration(borderRadius: 360),
        child: Image.asset(
          icAddUser,
          color: AppColors.colorWhite,
          height: 25,
          width: 25,
        ),
      ),
    );
  }
}
