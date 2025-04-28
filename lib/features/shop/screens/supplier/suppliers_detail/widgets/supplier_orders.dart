import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/supplier/supplier_detail_controller.dart';
import '../table/supplier_data_table.dart';

class SupplierProducts extends StatelessWidget {
  const SupplierProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SupplierDetailController.instance;
    controller.getSupplierProducts(controller.supplier.value!.id);

    final currencyFormatter = NumberFormat("#,###", "vi_VN");

    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Obx(() {
        if (controller.productsLoading.value) return const PLoaderAnimation();

        if (controller.filteredSupplierProducts.isEmpty) {
          return PAnimationLoaderWidget(
            text: 'Không có sản phẩm nào',
            animation: PImages.pencilAnimation,
          );
        }

        final totalValue = controller.filteredSupplierProducts.fold(
          0.0,
              (sum, p) => sum + (p.price * p.quantity),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sản phẩm cung cấp',
                    style: Theme.of(context).textTheme.headlineMedium),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: 'Tổng trị giá: '),
                  TextSpan(
                    text: '${currencyFormatter.format(totalValue)}đ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: PColors.primary),
                  ),
                  TextSpan(
                    text:
                    ' cho ${controller.filteredSupplierProducts.length} sản phẩm',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ])),
              ],
            ),

            const SizedBox(height: PSizes.spaceBtwItems),

            TextFormField(
              controller: controller.searchTextController,
              onChanged: (query) => controller.searchProductQuery(query),
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm sản phẩm',
                prefixIcon: Icon(Iconsax.search_normal),
              ),
            ),

            const SizedBox(height: PSizes.spaceBtwSections),

            // Data Table
            const SupplierProductTable(),
          ],
        );
      }),
    );
  }
}

