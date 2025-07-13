import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/update_quantity_dialog_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_preview_screen.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  String? productId;
  bool isFromOrder;


  ProductDetailScreen({super.key, this.productId,required this.isFromOrder});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductProvider _productProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.apiCallGetProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        String description =
            productProvider
                .getProductByProductId
                ?.data
                ?.productInfo
                ?.first
                .productDescription ??
            'N/A';

        return Stack(
          children: [
            AppScaffold(
              bgColor: AppColors.colorPrimary,
              appBar: PreferredSize(
                preferredSize: Size(double.infinity, appBarSize),
                child: AppBarWidget(
                  onBackPressed: (){
                    widget.isFromOrder == true ?  Navigator.pop(context,true) :  Navigator.pop(context);
                  },
                  isBackVisible: true,
                  title: "Product Detail",
                  isCartVisible: true,
                  isFavVisible: false,
                ),
              ),
              body: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      12.toSizedBoxHeight,
                      _imageCarouselSliderView(context),
                    ],
                  ),
                ],
              ),
              bottomSheet: BottomSheet(
                enableDrag: false,
                showDragHandle: false,
                onClosing: () {},
                backgroundColor: AppColors.colorPrimary.withOpacity(0.9),
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.toSizedBoxHeight,
                                _productNameView(),
                                12.toSizedBoxHeight,
                                _readMoreDescription(
                                  context,
                                  description.isNotEmpty ? description : 'N/A',
                                ),
                                20.toSizedBoxHeight,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _productProvider.sideVariantList.isNotEmpty? Expanded(child: _sideListView()) : SizedBox(),
                                    // Expanded(child: _colorListView()),
                                    _productProvider.sideVariantList.isNotEmpty ?  10.toSizedBoxWidth :  0.toSizedBoxWidth,
                                    _productProvider.materialVariantList.isNotEmpty ? Expanded(child: _materialTypeListView()) : SizedBox(),
                                  ],
                                ),
                                20.toSizedBoxHeight,

                                _productProvider.stepVariantList.isNotEmpty ? _sizeListView() : SizedBox(),
                                80.toSizedBoxHeight,
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: AppUtils.commonGlassmorphicContainer(
                              padding: EdgeInsets.only(left: 30),
                              child: _addToCartButtonView(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _productProvider.isFetching || _productProvider.isLoading
                ? CircleLoadingIndicatorWidget()
                : SizedBox(),
          ],
        );
      },
    );
  }

  Widget _productNameView() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (_productProvider.productInfoResponse?.productName ?? 'N/A')
                    .textWidget(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeLarge,
                      color: AppColors.colorWhite,
                    ),
                5.toSizedBoxHeight,
                (_productProvider
                            .getProductByProductId
                            ?.data
                            ?.productInfo
                            ?.first
                            .productCategoryName ??
                        'N/A')
                    .textWidget(
                      color: AppColors.colorLightGrey,
                      fontSize: fontSizeSmall,
                      fontWeight: FontWeight.w600,
                    ),
              ],
            ),
          ),
          _productItemCountView(),
        ],
      ),
    );
  }

  Widget _readMoreDescription(BuildContext context, String? text) {
    return ReadMoreText(
      _parseHtmlString("$text"),
      trimLines: 5,
      trimMode: TrimMode.Line,
      trimCollapsedText: '...Read More',
      trimExpandedText: "...Show Less",
      isExpandable: true,
      moreStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: AppConstants.fontFamilyPoppins,
        fontSize: 14,
        color: AppColors.colorPrimary,
      ),
      lessStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: AppConstants.fontFamilyPoppins,
        fontSize: 14,
        color: AppColors.colorPrimary,
      ),
      colorClickableText: AppColors.colorPrimary,
      style: TextStyle(
        fontFamily: AppConstants.fontFamilyPoppins,
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w500,
        color: AppColors.colorLightGrey,
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = HtmlParser.parseHTML(htmlString);
    return document.text ?? '';
  }

  Widget _productItemCountView() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                if ((_productProvider.productInfoResponse?.qty ?? 1) > 1) {
                  _productProvider.updateProductQty(
                    (_productProvider.productInfoResponse?.qty ?? 1) - 1,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1.3, color: AppColors.colorWhite),
                ),
                child: const Icon(
                  Icons.remove,
                  size: 16,
                  color: AppColors.colorWhite,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _productProvider.qtyEditController.text =
                    '${_productProvider.productInfoResponse?.qty ?? 1}';
                showAlertDialog(
                  context: context,
                  title: "Update Quantity",
                  isTitleCenter: true,
                  widget: UpdateQuantityDialogWidget(
                    qtyTextEditingController:
                        _productProvider.qtyEditController,
                    positiveCallBack: (val) {
                      _productProvider.updateProductQty(int.parse(val));
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: ('${_productProvider.productInfoResponse?.qty ?? 1}')
                    .textWidget(
                      fontSize: fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      color: AppColors.colorWhite,
                    ),
              ),
            ),
            InkWell(
              onTap: () {
                _productProvider.updateProductQty(
                  (_productProvider.productInfoResponse?.qty ?? 1) + 1,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: AppUtils.commonGradientBoxDecoration(
                  borderRadius: 8,
                ),
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: AppColors.colorWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _sideListView() {
    return Visibility(
      visible: _productProvider.sideVariantList.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelView("Side"),
          SizedBox(height: 8),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ListView.builder(
              itemCount: _productProvider.sideVariantList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      _productProvider.refreshScreenOnSideChange(
                        widget.productId,
                        _productProvider.sideVariantList[index],
                        index,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: AppUtils.commonGradientBoxDecoration(
                        borderRadius: 14,
                        gradient1:
                        (_productProvider.selectedSideVariant?.id ==
                            _productProvider
                                .sideVariantList[index]
                                .id)
                            ? AppColors.gradient1
                            : AppColors.colorTransparent,
                        gradient2:
                        (_productProvider.selectedSideVariant?.id ==
                            _productProvider
                                .sideVariantList[index]
                                .id)
                            ? AppColors.gradient2
                            : AppColors.colorTransparent,
                        border:
                        (_productProvider.selectedSideVariant?.id ==
                            _productProvider
                                .sideVariantList[index]
                                .id)
                            ? AppColors.colorTransparent
                            : AppColors.colorLightGrey,
                      ),
                      child: (_productProvider
                          .sideVariantList[index]
                          .name ??
                          '')
                          .textWidget(
                        fontSize: fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorWhite,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _sizeListView() {
    return Visibility(
      visible: _productProvider.stepVariantList.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelView("Size"),
          SizedBox(height: 8),
          SizedBox(
            height: 45,
            child: ListView.builder(
              itemCount: _productProvider.stepVariantList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      _productProvider.refreshScreenOnSizeChange(
                        widget.productId,
                        _productProvider.stepVariantList[index],
                        index,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: AppUtils.commonGradientBoxDecoration(
                        borderRadius: 14,
                        gradient1:
                            (_productProvider.selectedSizeVariant?.id ==
                                    _productProvider.stepVariantList[index].id)
                                ? AppColors.gradient1
                                : AppColors.colorTransparent,
                        gradient2:
                            (_productProvider.selectedSizeVariant?.id ==
                                    _productProvider.stepVariantList[index].id)
                                ? AppColors.gradient2
                                : AppColors.colorTransparent,
                        border:
                            (_productProvider.selectedSizeVariant?.id ==
                                    _productProvider.stepVariantList[index].id)
                                ? AppColors.colorTransparent
                                : AppColors.colorLightGrey,
                      ),
                      child: '${_productProvider.stepVariantList[index].name}'
                          .textWidget(
                            color: AppColors.colorWhite,
                            fontSize: fontSizeSmall,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _materialTypeListView() {
    return Visibility(
      visible: _productProvider.materialVariantList.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelView("Material"),
          SizedBox(height: 8),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ListView.builder(
              itemCount: _productProvider.materialVariantList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      _productProvider.refreshScreenOnMaterialChange(
                        widget.productId,
                        _productProvider.materialVariantList[index],
                        index,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: AppUtils.commonGradientBoxDecoration(
                        borderRadius: 14,
                        gradient1:
                            (_productProvider.selectedMaterialVariant?.id ==
                                    _productProvider
                                        .materialVariantList[index]
                                        .id)
                                ? AppColors.gradient1
                                : AppColors.colorTransparent,
                        gradient2:
                            (_productProvider.selectedMaterialVariant?.id ==
                                    _productProvider
                                        .materialVariantList[index]
                                        .id)
                                ? AppColors.gradient2
                                : AppColors.colorTransparent,
                        border:
                            (_productProvider.selectedMaterialVariant?.id ==
                                    _productProvider
                                        .materialVariantList[index]
                                        .id)
                                ? AppColors.colorTransparent
                                : AppColors.colorLightGrey,
                      ),
                      child: (_productProvider
                                  .materialVariantList[index]
                                  .name ??
                              '')
                          .textWidget(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhite,
                        fontSize: fontSizeSmall
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _addToCartButtonView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              '${AppConstants.currencySymbol}${_productProvider.productInfoResponse?.price ?? 0.0}'
                  .textWidget(
                    color: AppColors.colorWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    latterSpacing: 1,
                  ),
              SizedBox(width: 14),
              'Inclusive of all taxes'.textWidget(
                color: AppColors.colorLightGrey,
                fontWeight: FontWeight.normal,
                fontSize: 12,
                latterSpacing: 0,
              ),
            ],
          ),
        ),
        16.toSizedBoxWidth,
        GestureDetector(
          onTap: () {

            String? userType = PreferenceHelper.getString(
              PreferenceHelper.USER_TYPE_ID,
            );
            if (userType == AppConstants.userTypeDistributor) {
              if(widget.isFromOrder == true){
                _productProvider.addProductToOrder(product: _productProvider.productInfoResponse,context: context);

              }else{
                _productProvider.addToCartData(
                  cartKey: PreferenceHelper.CART_MODEL_LIST_AD,
                  context: context,
                );
              }


            } else {
              _productProvider.addToCartData(
                cartKey: PreferenceHelper.CART_MODEL_LIST,
                context: context,
              );
            }
          },
          child: Container(
            decoration: AppUtils.commonGradientBoxDecoration(borderRadius: 20),
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 30),
            child: Center(
              child: Icon(
                Icons.shopping_cart_checkout_rounded,
                color: AppColors.colorWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _labelView(String? label) {
    return "$label".textWidget(
      color: AppColors.colorWhite,
      fontSize: fontSizeSmall,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _imageCarouselSliderView(BuildContext context) {
    return (_productProvider
                    .getProductByProductId
                    ?.data
                    ?.productInfo
                    ?.first
                    .allVariants ??
                [])
            .isEmpty
        ? InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder:
            //         (context) => ProductPreviewScreen(
            //           images:
            //               _productProvider.productInfoResponse?.productImages,
            //           image: _productProvider.productInfoResponse?.image,
            //           color: _productProvider.productInfoResponse?.productVariant?.color?.name,
            //           size: _productProvider.selectedSizeVariant?.name,
            //
            //           description: _productProvider.productInfoResponse?.productDescription,
            //           material: _productProvider.selectedMaterialVariant?.name,
            //
            //         ),
            //   ),
            // );
            // AutoRouter.of(context).push(ProductPreviewRoute(
            //     productInfo: _productCubit.productDetailsResponseProductInfo));
          },
          child: AppUtils.commonGlassmorphicContainer(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: MediaQuery.of(context).size.height * 0.35,
            child: (_productProvider.productInfoResponse?.image ?? '')
                .toNetWorkImage(fit: BoxFit.cover),
          ),
        )
        : AppUtils.commonGlassmorphicContainer(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: MediaQuery.of(context).size.height * 0.35,
          blur: 100,
          child: FlutterCarousel(
            options: FlutterCarouselOptions(
              height: MediaQuery.of(context).size.height * 0.36,
              controller: _productProvider.carouselController,
              showIndicator: true,
              floatingIndicator: false,
              viewportFraction: 1,
              slideIndicator: CircularSlideIndicator(
                slideIndicatorOptions: SlideIndicatorOptions(
                  indicatorRadius: 4,
                  itemSpacing: 14,

                  enableAnimation: true,

                  // enableHalo: true,
                  padding: EdgeInsets.all(10),
                  currentIndicatorColor: AppColors.colorSecondary,
                  indicatorBackgroundColor: AppColors.colorLightGrey
                      .withOpacity(0.5),
                ),
              ),
            ),
            items:
                (_productProvider.productInfoResponse?.productImages ?? []).map((
                  i,
                ) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductPreviewScreen(
                                    images:
                                    _productProvider.productInfoResponse?.productImages,
                                    image: _productProvider.productInfoResponse?.image,
                                    color:
                                    _productProvider.selectedColorVariant?.name,
                                    size:
                                    _productProvider.selectedSizeVariant?.name,
                                    description:
                                    _productProvider
                                        .productInfoResponse
                                        ?.productDescription,
                                    material:
                                    _productProvider.selectedSizeVariant?.name,
                                  ),
                            ),
                          );
                          // AutoRouter.of(context).push(ProductPreviewRoute(
                          //   productInfo:
                          //   _productCubit.productDetailsResponseProductInfo,
                          // ));
                        },
                        child: Container(
                          height: 300,
                          // color: Colors.red,
                          width: double.infinity,
                          child: i.toNetWorkImage(
                            height: 250,
                            width: 200,
                            fit: BoxFit.cover,
                            // height: 170,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
        );
  }
}
