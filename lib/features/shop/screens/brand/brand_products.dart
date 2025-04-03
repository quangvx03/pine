import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/products/sortable/sortable_products.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/brand_model.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    // Tạo controller với tag riêng cho mỗi thương hiệu
    final controller = BrandController.getInstance(brand.id);
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PAppBar(
        title: Text(brand.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Brand Header
            Container(
              width: double.infinity,
              color:
                  dark ? PColors.dark : PColors.primary.withValues(alpha: 0.05),
              child: Column(
                children: [
                  // Logo và thông tin thương hiệu
                  Padding(
                    padding: const EdgeInsets.all(PSizes.defaultSpace),
                    child: Column(
                      children: [
                        // Brand Image
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(PSizes.sm + 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: PColors.primary.withValues(alpha: 0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: brand.image,
                            fit: BoxFit.contain,
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              color: PColors.error,
                            ),
                          ),
                        ),

                        const SizedBox(height: PSizes.spaceBtwItems),

                        // Brand Title - Căn giữa và kích thước lớn hơn
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  brand.name,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: PSizes.xs),
                                child: Icon(
                                  Iconsax.verify5,
                                  color: PColors.primary,
                                  size: PSizes.iconSm, // Icon lớn hơn
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Số lượng sản phẩm - Có thiết kế nổi bật hơn
                        Obx(() {
                          final productCount = controller.brandProducts.length;
                          return Container(
                            margin: const EdgeInsets.only(top: PSizes.sm),
                            padding: const EdgeInsets.symmetric(
                              horizontal: PSizes.md,
                              vertical: PSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: PColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(PSizes.sm),
                            ),
                            child: Text(
                              '$productCount sản phẩm',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: PColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Thanh tiêu đề phần sản phẩm
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: PSizes.defaultSpace,
                      vertical: PSizes.md,
                    ),
                    decoration: BoxDecoration(
                      color: dark ? PColors.darkerGrey : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: dark ? Colors.black : Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tất cả sản phẩm',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Brand Products
            Padding(
              padding: const EdgeInsets.all(PSizes.defaultSpace),
              child: FutureBuilder(
                  future: controller.getBrandProducts(brandId: brand.id),
                  builder: (context, snapshot) {
                    /// Handle Loader, No Record or Error Message
                    const loader = PVerticalProductShimmer();
                    final widget = PCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot, loader: loader);

                    if (widget != null) return widget;

                    /// Record found
                    final brandProducts = snapshot.data!;
                    if (brandProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.box_1,
                              size: 54,
                              color: dark ? PColors.grey : Colors.grey.shade400,
                            ),
                            const SizedBox(height: PSizes.spaceBtwItems),
                            Text(
                              'Không có sản phẩm nào thuộc thương hiệu này!',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return PSortableProducts(products: brandProducts);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
