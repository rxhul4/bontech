import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/update_quantity_dialog_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/common_function.dart';
import 'package:sales_app_redesign/features/genral/product/model/get_product_by_productId_model.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/product_preview_screen.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  String? productId;

  ProductDetailScreen({super.key, this.productId});

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
    _productProvider.selectedVariants = {};
    _productProvider.product = Product();
    _productProvider.apiCallGetProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Stack(
          children: [
            AppScaffold(
              bgColor: AppColors.colorPrimary,
              appBar: PreferredSize(
                preferredSize: Size(double.infinity, appBarSize),
                child: AppBarWidget(
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  isBackVisible: true,
                  title: "Product Detail",
                  isCartVisible: true,
                  isFavVisible: false,
                ),
              ),
              body: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  12.toSizedBoxHeight,
                  _imageCarouselSliderView(context, productProvider),
                ],
              ),
              bottomSheet: BottomSheet(
                enableDrag: false,
                showDragHandle: false,
                onClosing: () {},
                shadowColor: AppColors.colorTransparent,
                backgroundColor: Colors.transparent,


                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                ),

                builder: (context) {
                  final mediaQuery = MediaQuery.of(context);
                  final bottomPadding = mediaQuery.viewPadding.bottom +
                      mediaQuery.viewInsets.bottom + 70.0;


                  return Frost(

                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.48,
                    child: Stack(
                      children: [

                        /// Scrollable Content Area
                        SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: bottomPadding,
                              left: 16,
                              right: 16,
                              top: 8),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.toSizedBoxHeight,
                              _productNameView(productProvider),
                              12.toSizedBoxHeight,
                              _readMoreDescription(
                                context,
                                productProvider.product?.productDescription,
                              ),
                              20.toSizedBoxHeight,
                              Visibility(
                                visible: productProvider.productResponse?.data
                                    ?.productInfo?.allVariants?.isNotEmpty ??
                                    false,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: productProvider.productResponse
                                      ?.data?.productInfo?.allVariants
                                      ?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final variantAttribute =
                                    productProvider.productResponse?.data
                                        ?.productInfo?.allVariants?[index];
                                    final key = variantAttribute?.key;
                                    final options = variantAttribute?.value ??
                                        [];

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        _labelView(key),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          height: 45,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            itemCount: options.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index1) {
                                              final option = options[index1];
                                              final isSelected = _productProvider
                                                  .selectedVariants[key]?.id ==
                                                  option.id;
                                              return Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (key != null) {
                                                      _productProvider
                                                          .updateSelectedVariant(
                                                          key, option);
                                                    }
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    margin: const EdgeInsets
                                                        .only(right: 10),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    decoration: AppUtils
                                                        .commonGradientBoxDecoration(
                                                      borderRadius: 14,
                                                      gradient1: isSelected
                                                          ? AppColors.gradient1
                                                          : AppColors
                                                          .colorTransparent,
                                                      gradient2: isSelected
                                                          ? AppColors.gradient2
                                                          : AppColors
                                                          .colorTransparent,
                                                      border: isSelected
                                                          ? AppColors
                                                          .colorTransparent
                                                          : AppColors
                                                          .colorLightGrey,
                                                    ),
                                                    child: (option.name ?? "")
                                                        .textWidget(
                                                      fontSize: fontSizeSmall,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      color: AppColors
                                                          .colorWhite,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Bottom Button (Floating)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Frost(
                            height: 70,
                            blur: 100,

                            margin: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            padding: EdgeInsets.only(left: 30),
                            child: _addToCartButtonView(productProvider),
                          ),
                        ),
                      ],
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

  Widget _productNameView(ProductProvider productProvider) {
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
                (productProvider
                    .productResponse
                    ?.data
                    ?.productInfo
                    ?.productName ??
                    "N/A")
                    .textWidget(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeLarge,
                  color: AppColors.colorWhite,
                ),
                5.toSizedBoxHeight,
                (productProvider
                    .productResponse
                    ?.data
                    ?.productInfo
                    ?.productCategoryName ??
                    "N/A")
                    .textWidget(
                  color: AppColors.colorLightGrey,
                  fontSize: fontSizeSmall,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          _productItemCountView(productProvider),
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

  Widget _productItemCountView(ProductProvider productProvider) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                if ((productProvider.product?.productQty ?? 1) > 1) {
                  productProvider.updateProductQty(
                    (productProvider.product?.productQty ?? 1) - 1,
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
                productProvider.qtyEditController.text =
                '${productProvider.product?.productQty ?? 1}';

                showDialog(context: context, builder: (context) {
                  return UpdateQuantityDialogWidget(
                    qtyTextEditingController:
                    productProvider.qtyEditController,
                    positiveCallBack: (val) {
                      productProvider.updateProductQty(int.parse(val));
                    },
                  );
                },);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: ('${productProvider.product?.productQty ?? 1}')
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
                productProvider.updateProductQty(
                  (productProvider.product?.productQty ?? 1) + 1,
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


  Widget _addToCartButtonView(ProductProvider productProvider) {
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
              '${AppConstants.currencySymbol}${productProvider.product?.price ??
                  0.0}'
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
              _productProvider.addToCartData(
                cartKey: PreferenceHelper.CART_MODEL_LIST_AD,
                context: context,
              );
            } else {
              _productProvider.addToCartData(
                cartKey: PreferenceHelper.CART_MODEL_LIST,
                context: context,
              );
            }
          },
          child: Container(
            decoration: AppUtils.commonGradientBoxDecoration(borderRadius: 16),
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

  Widget _imageCarouselSliderView(BuildContext context,
      ProductProvider productProvider) {
    return (productProvider
        .productResponse
        ?.data
        ?.productInfo
        ?.productImages ??
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
      child: Frost(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery
            .of(context)
            .size
            .height * 0.35,
        child: (productProvider.productResponse?.data?.productInfo?.image ?? '')
            .toNetWorkImage(fit: BoxFit.cover),
      ),
    )
        : Frost(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.35,
      blur: 100,
      child: FlutterCarousel(
        options: FlutterCarouselOptions(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.36,
          controller: _productProvider.carouselController,
          showIndicator: true,
          floatingIndicator: false,
          viewportFraction: 1,
          slideIndicator: CircularSlideIndicator(
            slideIndicatorOptions: SlideIndicatorOptions(
              indicatorRadius: 4,
              itemSpacing: 14,
              enableAnimation: true,
              padding: EdgeInsets.all(10),
              currentIndicatorColor: AppColors.colorSecondary,
              indicatorBackgroundColor: AppColors.colorLightGrey
                  .withOpacity(0.5),
            ),
          ),
        ),
        items:
        (productProvider.productResponse?.data?.productInfo?.productImages ??
            []).map((i,) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                          ProductPreviewScreen(
                            images: productProvider.productResponse?.data
                                ?.productInfo?.productImages,
                            image: productProvider.productResponse?.data
                                ?.productInfo?.image,
                            // product: productProvider.selectedVariants,
                            selectedVariant: productProvider.selectedVariants,
                            description: productProvider.product
                                ?.productDescription,
                          ),
                    ),
                  );
                },
                child: SizedBox(
                  // height: 300,
                  // color: Colors.red,
                  width: double.infinity,
                  child: i.toNetWorkImage(
                    height: 240,
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
