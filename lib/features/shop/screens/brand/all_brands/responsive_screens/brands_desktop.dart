import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/brand/brand_controller.dart';

import '../../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../table/brand_table.dart';

class BrandsDesktopScreen extends StatelessWidget {
  const BrandsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(heading: 'Thương hiệu', breadcrumbItems: ['Thương hiệu']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Table Body
              // Show Loader
              PRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    PTableHeader(buttonText: 'Thêm thương hiệu',
                        onPressed: () => Get.toNamed(PRoutes.createBrand),
                        searchController: controller.searchTextController,
                        searchOnChanged: (query) => controller.searchQuery(query)),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Table
                    Obx(() {
                      if (controller.isLoading.value) return const PLoaderAnimation();
                      return const BrandTable();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
