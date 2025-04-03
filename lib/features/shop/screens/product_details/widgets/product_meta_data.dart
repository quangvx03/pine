import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/images/circular_image.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_detail_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/screens/brand/brand_products.dart';
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

        const SizedBox(height: PSizes.spaceBtwItems / 4),

        /// Brand
        if (product.brand != null)
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.lazyPut(() => BrandController(), fenix: true);
                    Get.to(() => BrandProducts(brand: product.brand!));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PCircularImage(
                        image: product.brand!.image,
                        isNetworkImage: true,
                        width: 48,
                        height: 48,
                      ),
                      const SizedBox(width: PSizes.spaceBtwItems / 2),
                      Flexible(
                        child: PBrandTitleWithVerifiedIcon(
                          title: product.brand!.name,
                          brandTextSize: TextSizes.medium,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: PSizes.spaceBtwItems / 2),
      ],
    );
  }
}
