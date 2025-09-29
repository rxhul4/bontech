import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/frost_conatiner.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';
import 'package:sales_app_redesign/core/utils/app_extension.dart';
import 'package:sales_app_redesign/features/genral/home/model/product_card_model.dart';

class ProductCard extends StatelessWidget {
  final ProductItem item;
  final VoidCallback onTap;
  final double? width;

  const ProductCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Frost(
        width: width == null ? 170 : 0,
        blur: 18,
        opacity: .14,
        radius: 16,
        frame: Frost.outlineBorder(),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1.07,
                  child: Image.network(
                    height: 150,
                    width: 150,
                    item.imageUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Product name
            (item.name ?? "").textWidget(
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
              color: AppColors.colorWhite,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),

            const SizedBox(height: 2),

            // Product code
            (item.code ?? "").textWidget(
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
              color: AppColors.colorWhite,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}