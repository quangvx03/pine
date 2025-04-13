import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../common/widgets/data_table/table_header.dart';
import '../table/products_table.dart';

class ProductsDesktopScreen extends StatelessWidget {
  const ProductsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(heading: 'Sản phẩm', breadcrumbItems: ['Sản phẩm']),
              const SizedBox(height: PSizes.spaceBtwSections),
        
              // Table Body
              Obx(
                () {
                  if (controller.isLoading.value) return const PLoaderAnimation();

                    return PRoundedContainer(
                      child: Column(
                        children: [
                          // Table Header
                          PTableHeader(
                              buttonText: 'Thêm sản phẩm',
                              onPressed: () => Get.toNamed(PRoutes.createProduct),
                            searchOnChanged: (query) => controller.searchQuery(query),
                          ),
                          const SizedBox(height: PSizes.spaceBtwItems),

                          // Table
                          const ProductsTable(),
                        ],
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
