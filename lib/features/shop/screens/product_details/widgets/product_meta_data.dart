import 'package:flutter/material.dart';
import 'package:pine/common/widgets/images/circular_image.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_detail_price_text.dart';
import 'package:pine/common/widgets/texts/product_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
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
    final dark = PHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            /// Sale Tag
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
            const SizedBox(width: PSizes.spaceBtwItems),

            /// Price
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0)
              Text(PHelperFunctions.formatCurrency(product.price),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(decoration: TextDecoration.lineThrough)),
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0)
              const SizedBox(width: PSizes.spaceBtwItems),
            PProductDetailPriceText(
                price: controller.getProductPrice(product), isLarge: true),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 1.5),

        /// Title
         PProductTitleText(title: product.title,),
        // const SizedBox(height: PSizes.spaceBtwItems / 1.5),

        /// Stock Status
        // Row(
        //   children: [
        //     const PProductTitleText(title: 'Trạng thái'),
        //     const SizedBox(width: PSizes.spaceBtwItems),
        //     Text(controller.getProductStockStatus(product.stock),
        //         style: Theme.of(context)
        //             .textTheme
        //             .titleMedium!
        //             .apply(color: PColors.primary)),
        //   ],
        // ),
        // const SizedBox(height: PSizes.spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            PCircularImage(
                image: product.brand != null ? product.brand!.image : '', isNetworkImage: true,
                width: 48,
                height: 48,
                // overlayColor: dark ? PColors.white : PColors.black
            ),
             PBrandTitleWithVerifiedIcon(
                title: product.brand != null ? product.brand!.name : '', brandTextSize: TextSizes.medium),
          ],
        )
      ],
    );
  }
}
//19