import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productid.dart' as details_res;

class ProductPreviewScreen extends StatefulWidget {
  ProductPreviewScreen({
    super.key,
    this.images,
    this.image,
    this.description,
    this.product,
    this.selectedVariant
  });

  final List<String>? images;
  String? image;
  final String? description;
  Product? product;
  Map<String, VariantOption>? selectedVariant;



  @override
  State<ProductPreviewScreen> createState() => _ProductPreviewScreenState();
}

class _ProductPreviewScreenState extends State<ProductPreviewScreen> {
  bool showMenu = true;
  bool showBottomSheet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showBottomSheet = false;
          showMenu = false;
        });
      },
      child: AppScaffold(

          body: AppUtils.commonContainer(
              child: Stack(
        children: [
          _imageCarouselSliderView(context),
          _closeIconView(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              _descriptionView(),
            ],
          ),
        ],
      ))),
    );
  }

  Widget _closeIconView() {
    // print("-----------Data${widget.color}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.toSizedBoxHeight,
        Padding(
          padding: AppUtils.edgeInsetsOnly(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppUtils.fourDotWidget(onTap: () {
                setState(() {
                  showMenu = !showMenu;
                });
              }),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.colorLightGrey,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        AppUtils.commonSizedBox(height: 30),
        Visibility(
          visible: showMenu,
          child: Padding(
            padding: AppUtils.edgeInsetsOnly(left: 20, right: 20),
            child: Column(
              children: widget.selectedVariant!.entries.map((entry) {
                final key = entry.key;
                final value = entry.value;
                return _commonViewSideOption(title: key, value: value.name ?? "");
              },).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _commonViewSideOption(
      {required String title, required String value, Color? boxColor}) {
    return Container(
      width: 85,
      height: 110,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: boxColor ?? AppColors.colorLightGrey,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title.textWidget(
              textAlign: TextAlign.center,
              color: AppColors.colorMainBlack,
              fontWeight: FontWeight.bold),
          value.textWidget(
              color: AppColors.colorMainBlack, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _imageCarouselSliderView(BuildContext context) {
    print("details${widget.images}");

    return (widget.images ?? []).isEmpty
        ? "${widget.images}".toNetWorkImage(
            height: MediaQuery.sizeOf(context).height / 1.4,
            width: double.infinity,
          )
        : FlutterCarousel(
            options: FlutterCarouselOptions(

              height: MediaQuery.sizeOf(context).height / 1.2,
              showIndicator: true,
              floatingIndicator: false,
              viewportFraction: 1,
              slideIndicator: CircularSlideIndicator(
                  slideIndicatorOptions: SlideIndicatorOptions(
                      currentIndicatorColor: AppColors.colorWhite,
                      indicatorBackgroundColor: AppColors.colorLightGrey.withOpacity(0.5))),
            ),
            items: (widget.images ?? []).map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return i.toNetWorkImage(
                    height: MediaQuery.sizeOf(context).height / 3,
                    width: MediaQuery.sizeOf(context).width / 1.8,
                  );
                  // return ''.toNetWorkImage(
                  //   height: MediaQuery.sizeOf(context).height / 1.4,
                  //   width: double.infinity,
                  // );
                },
              );
            }).toList(),
          );
  }

  Widget _descriptionView() {
    String description = (widget.description ?? '').isNotEmpty
            ? (widget.description ?? '')
            : 'N/A';

    return GestureDetector(
      onTap: () {
        setState(() {
          showBottomSheet = true;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: showBottomSheet ? 230 : 55,
        decoration: AppUtils.commonBoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppUtils.commonSizedBox(height: 10),
              InkWell(
                  onTap: () {
                    setState(() {
                      showBottomSheet = !showBottomSheet;
                    });
                  },
                  child: Icon(
                    !showBottomSheet
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 40,
                  )),
              AppUtils.commonSizedBox(height: 10),
              Visibility(
                visible: showBottomSheet,
                child: Padding(
                  padding: AppUtils.edgeInsetsOnly(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppUtils.commonTextWidget(
                              text: "Description",
                              textColor: AppColors.colorMainBlack,
                              letterSpacing: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ],
                      ),
                      AppUtils.commonSizedBox(height: 10),
                      (description.isNotEmpty ? description : 'N/A')
                          .textWidget(

                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: AppColors.colorDarkGrey,
                      ),
                      // AppUtils.commonTextWidget(
                      //     text: description,
                      //     textColor: AppColors.colorDarkGrey,
                      //     letterSpacing: 1,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500),
                      AppUtils.commonSizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
