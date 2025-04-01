import 'package:flutter/material.dart';
import 'package:pine/common/widgets/images/circular_image.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_detail_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PProductMetaData extends StatelessWidget {
  const PProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: PSizes.spaceBtwItems,
          children: [
            /// Sale Tag
            if (product.salePrice > 0 && product.salePrice < product.price)
              PRoundedContainer(
                radius: PSizes.sm,
                backgroundColor: PColors.secondary.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(
                    horizontal: PSizes.sm, vertical: PSizes.xs),
                child: Text('$salePercentage%',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(color: PColors.black)),
              ),

            /// Price
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0 &&
                product.salePrice < product.price)
              Text(PHelperFunctions.formatCurrency(product.price),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(decoration: TextDecoration.lineThrough)),

            // Sử dụng IntrinsicWidth để đảm bảo chiều rộng phù hợp với nội dung
            IntrinsicWidth(
              child: PProductDetailPriceText(
                price: controller.getProductPrice(product),
                isLarge: true,
                // Cho phép hiển thị nhiều dòng nếu cần thiết
                maxLines: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 1.5),

        /// Title
        PProductTitleText(
          title: product.title,
          isDetail: true,
        ),

        /// Brand
        Row(
          children: [
            PCircularImage(
              image: product.brand != null ? product.brand!.image : '',
              isNetworkImage: true,
              width: 48,
              height: 48,
            ),
            const SizedBox(width: PSizes.spaceBtwItems / 2),
            Expanded(
              child: PBrandTitleWithVerifiedIcon(
                title: product.brand != null ? product.brand!.name : '',
                brandTextSize: TextSizes.medium,
                maxLines: 1,
              ),
            )
          ],
        )
      ],
    );
  }
}
