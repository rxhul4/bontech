import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app_redesign/core/common/circle_loading_indicator_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/glass_sheet_widget.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_constant.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/core/utils/app_utils.dart';
import 'package:sales_app_redesign/core/utils/glow_arch_class.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_category.dart';
import 'package:sales_app_redesign/features/genral/product/model/product_by_viewtype.dart';
import 'package:sales_app_redesign/features/genral/product/presentation/produst_detail_screen.dart';
import 'package:sales_app_redesign/features/genral/product/provider/product_provider.dart';
import 'package:sales_app_redesign/features/genral/search/presentation/search_delegate.dart';

enum SortBy { nameAZ, nameZA, codeAZ, codeZA }

class ProductListingScreen extends StatefulWidget {
  final String? categoryName;
  final String? categoryId;
  final String? totViewTypeId;
  final bool? isAdmin;
  final bool? isFromCategory;
  final bool? isFromOrder;
  final bool isBackButtonAvailable;

  const ProductListingScreen({
    super.key,
    this.categoryName,
    this.categoryId,
    this.totViewTypeId,
    this.isAdmin,
    this.isFromCategory,
    this.isFromOrder,
    required this.isBackButtonAvailable,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late ProductProvider _productProvider;
  SortBy _sort = SortBy.nameAZ;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.resetProductData();

    widget.isFromCategory == true
        ? _productProvider.fetchProductListForCategory(widget.categoryId)
        : _productProvider.fetchProductListUsingTotId(widget.totViewTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final list =
            widget.isFromCategory == true
                ? productProvider.categoryProduct
                : productProvider.totProduct;

        _applySort(list);

        return AppScaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, appBarSize),
            child: AppBarWidget(
              onBackPressed:
                  () => Navigator.pop(context, widget.isFromOrder == true),
              onPressedSearch:
                  () => showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(
                      categoryId:
                          widget.isFromCategory == true
                              ? widget.categoryId
                              : null,
                    ),
                  ),
              isSearchVisible: true,
              isCartVisible: true,
              isBackVisible: widget.isBackButtonAvailable,
              title: widget.categoryName,
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  10.toSizedBoxHeight,
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scroll) {
                        if (scroll.metrics.pixels ==
                                scroll.metrics.maxScrollExtent &&
                            !productProvider.isLoading) {
                          widget.isFromCategory == true
                              ? productProvider.fetchProductListForCategory(
                                widget.categoryId,
                              )
                              : productProvider.fetchProductListUsingTotId(
                                widget.totViewTypeId,
                              );
                        }
                        return false;
                      },
                      child:
                          productProvider.isLoading ||
                                  productProvider.isFetching
                              ? const CircleLoadingIndicatorWidget()
                              : list.isEmpty
                              ? AppUtils.noDataWidget()
                              : _ProductGrid(
                                isFromCategory: widget.isFromCategory ?? false,
                                list: list,
                              ),
                    ),
                  ),
                ],
              ),
              // ---- Sticky bottom SORT bar ----
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Frost(
                      blur: 22,
                      opacity: .18,
                      radius: 18,
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        children: [
                          Expanded(
                            child: _BottomAction(
                              icon: Icons.sort_rounded,
                              label: 'SORT',
                              onTap: _openSort,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applySort(List list) {
    switch (_sort) {
      case SortBy.nameAZ:
        list.sort(
          (a, b) => (a.productName ?? '').compareTo(b.productName ?? ''),
        );
        break;
      case SortBy.nameZA:
        list.sort(
          (a, b) => (b.productName ?? '').compareTo(a.productName ?? ''),
        );
        break;
      case SortBy.codeAZ:
        list.sort(
          (a, b) => (a.productCode ?? '').compareTo(b.productCode ?? ''),
        );
        break;
      case SortBy.codeZA:
        list.sort(
          (a, b) => (b.productCode ?? '').compareTo(a.productCode ?? ''),
        );
        break;
      case SortBy.nameAZ:
      default:
        break;
    }
  }

  void _openSort() async {
    final result = await showModalBottomSheet<SortBy>(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => GlassSheet(
            title: 'Sort by',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SortTile(
                  title: 'Name A → Z',
                  selected: _sort == SortBy.nameAZ,
                  onTap: () => Navigator.pop(ctx, SortBy.nameAZ),
                ),
                _SortTile(
                  title: 'Name Z → A',
                  selected: _sort == SortBy.nameZA,
                  onTap: () => Navigator.pop(ctx, SortBy.nameZA),
                ),
                _SortTile(
                  title: 'Code A → Z',
                  selected: _sort == SortBy.codeAZ,
                  onTap: () => Navigator.pop(ctx, SortBy.codeAZ),
                ),
                _SortTile(
                  title: 'Code Z → A',
                  selected: _sort == SortBy.codeZA,
                  onTap: () => Navigator.pop(ctx, SortBy.codeZA),
                ),
              ],
            ),
          ),
    );
    if (result != null) setState(() => _sort = result);
  }
}

class _ProductGrid extends StatelessWidget {
  final List list;
  final bool isFromCategory;

  const _ProductGrid({required this.list, required this.isFromCategory});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing:  20,
        mainAxisSpacing:  20,
        mainAxisExtent:  250,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return _ProductCard(item: item, isFromCategory: isFromCategory);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic item;
  final bool isFromCategory;

  const _ProductCard({required this.item, required this.isFromCategory});

  @override
  Widget build(BuildContext context) {
    print("ProductCode${item?.productCode}");
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: item?.productId),
            ),
          ),
      child: Stack(
        children: [
          Frost(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      isFromCategory
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 1.07,
                              child: Image.network(
                                item?.imagePath ?? "",
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 1.07,
                              child: Image.network(
                                item?.imagePath ?? "",
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 10),
                ("${item?.productName}").textWidget(
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.colorWhite,
                ),

                ("${item?.productCode}").textWidget(
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.colorWhite,
                ),

              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 145,
              height: 145,
              child: CustomPaint(painter: GlowingArcPainter()),
            ),
          ),
        ],
      ),
    );
  }
}
// class _ProductCard extends StatelessWidget {
//   final dynamic item;
//   final bool isFromCategory;
//
//   const _ProductCard({required this.item, required this.isFromCategory});
//
//   @override
//   Widget build(BuildContext context) {
//     print("ProductCode${item?.productCode}");
//     return InkWell(
//       borderRadius: BorderRadius.circular(24),
//       onTap:
//           () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ProductDetailScreen(productId: item?.productId),
//             ),
//           ),
//       child: Stack(
//         children: [
//           Frost(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child:
//                       isFromCategory
//                           ? ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: AspectRatio(
//                               aspectRatio: 1.07,
//                               child: Image.network(
//                                 item?.imagePath ?? "",
//                                 fit: BoxFit.cover,
//                                 errorBuilder:
//                                     (_, __, ___) => const Icon(
//                                       Icons.broken_image,
//                                       color: Colors.white,
//                                     ),
//                               ),
//                             ),
//                           )
//                           : ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: AspectRatio(
//                               aspectRatio: 1.07,
//                               child: Image.network(
//                                 item?.imagePath ?? "",
//                                 fit: BoxFit.cover,
//                                 errorBuilder:
//                                     (_, __, ___) => const Icon(
//                                       Icons.broken_image,
//                                       color: Colors.white,
//                                     ),
//                               ),
//                             ),
//                           ),
//                 ),
//                 const SizedBox(height: 10),
//                 ("${item?.productName}").textWidget(
//                   maxLine: 1,
//                   overflow: TextOverflow.ellipsis,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                   color: AppColors.colorWhite,
//                 ),
//
//                 ("${item?.productCode}").textWidget(
//                   maxLine: 1,
//                   overflow: TextOverflow.ellipsis,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 12,
//                   color: AppColors.colorWhite,
//                 ),
//
//               ],
//             ),
//           ),
//           Positioned(
//             top: 0,
//             right: 0,
//             child: SizedBox(
//               width: 145,
//               height: 145,
//               child: CustomPaint(painter: GlowingArcPainter()),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.colorWhite),
            const SizedBox(width: 8),
            label.textWidget(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppColors.colorWhite,
            ),
          ],
        ),
      ),
    );
  }
}

class _SortTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SortTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? AppColors.colorSecondary : AppColors.colorWhite,
      ),
      title: title.textWidget(
        color: selected ? AppColors.colorSecondary : AppColors.colorWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
