import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:sales_app_redesign/features/admin/order/model/local_model/order_product_model.dart';
import 'package:sales_app_redesign/features/admin/pending_order/model/pending_order_model.dart';
import 'package:sales_app_redesign/features/admin/pending_order/provider/pending_order_provider.dart';

class PendingOrderSummaryScreen extends StatefulWidget {
  const PendingOrderSummaryScreen({super.key});

  @override
  State<PendingOrderSummaryScreen> createState() =>
      _PendingOrderSummaryScreenState();
}

class _PendingOrderSummaryScreenState extends State<PendingOrderSummaryScreen> {
  late PendingOrderProvider _pendingOrderProvider;

  @override
  void initState() {
    super.initState();
    _pendingOrderProvider =
        Provider.of<PendingOrderProvider>(context, listen: false);
    _pendingOrderProvider.apiCallGetMyPendingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PendingOrderProvider>(
      builder: (context, provider, child) {
        return AppScaffold(
          appBar: const PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(
              centerTitle: true,
              title: "Pending Order",
              isBackVisible: true,
              isCartVisible: true,
              isAdmin: false,
            ),
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(PendingOrderProvider provider) {
    if (provider.isFetching) {
      return const Center(child: CircleLoadingIndicatorWidget());
    }

    final items = provider.pendingOrderResponse?.pendingProductData ?? [];

    if (items.isEmpty) {
      return Center(child: AppUtils.noDataWidget());
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _listItem(index, item, provider);
      },
    );
  }

  Widget _listItem(
      int index,
      ProductData1 item,
      PendingOrderProvider provider,
      ) {
    if (item == null) return const SizedBox();

    return Frost(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // decoration: BoxDecoration(
      //   color: AppColors.colorPrimary,
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: Colors.white.withOpacity(0.08)),
      //   boxShadow: [
      //     BoxShadow(
      //       color: AppColors.colorPrimary.withOpacity(0.25),
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            (item.imagePath ?? '').toNetWorkImage(
              height: 90,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (item.productName ?? '').textWidget(
                    fontSize: fontSizeNormal,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorWhite,
                  ),
                  const SizedBox(height: 5),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.productVariant != null && item.productVariant!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: item.productVariant!.entries.map((entry) {
                            return '${entry.key} : '
                                .richTextView(
                              fontFamily: AppConstants.fontFamilyPoppins,
                              fontSize: fontSizeNormal,
                              color: AppColors.colorLightGrey,
                              textSpanList: [
                                TextSpan(
                                  text: entry.value.name ?? 'N/A',
                                  style: TextStyle(
                                    color: AppColors.colorWhite,
                                    fontSize: fontSizeSmall,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppConstants.fontFamilyPoppins,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),


                      _productItemCountView(item, provider),
                    ],
                  ),

                  // Variants

                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      //addToCart
                      _pendingOrderProvider.addToCartData(context: context,productData: item);
                    },
                    child: AppUtils.commonContainer(width: double.infinity,
                      decoration: AppUtils.commonGradientBoxDecoration(borderRadius: 6),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: "Add to cart".textWidget(fontWeight: FontWeight.w500,textAlign: TextAlign.center,fontSize: 12)
                    ),
                  )


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productItemCountView(ProductData1 item, PendingOrderProvider provider) {
    final qty = item.pendingQuantity ?? 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrease
        InkWell(
          onTap: () {
            if (qty > 1) {
              provider.updateProductListQty(qty - 1, item);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1.3, color: AppColors.colorWhite),
            ),
            child: const Icon(Icons.remove, size: 16, color: AppColors.colorWhite),
          ),
        ),

        // Quantity edit
        InkWell(
          onTap: () {
            provider.qtyEditController.text = '$qty';

            showDialog(context: context, builder: (context) {
              return UpdateQuantityDialogWidget(
                qtyTextEditingController: provider.qtyEditController,
                positiveCallBack: (val) {
                  provider.updateProductListQty(int.parse(val), item);
                },
              );
            },);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ('$qty').textWidget(
              fontSize: fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.colorWhite,
            ),
          ),
        ),

        // Increase
        InkWell(
          onTap: () => provider.updateProductListQty(qty + 1, item),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: AppUtils.commonGradientBoxDecoration(borderRadius: 8),
            child: const Icon(Icons.add, size: 16, color: AppColors.colorWhite),
          ),
        ),
      ],
    );
  }
}
