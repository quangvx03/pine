import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/category_table.dart';

class CategoriesMobileScreen extends StatelessWidget {
  const CategoriesMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(heading: 'Danh mục', breadcrumbItems: ['Danh mục']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Table Body
              // Show Loader
              Obx(() {
                 return PRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      PTableHeader(buttonText: 'Tạo danh mục', onPressed: () => Get.toNamed(PRoutes.createCategory)),
                      const SizedBox(height: PSizes.spaceBtwItems),

                      // Table
                      const CategoryTable(),
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
