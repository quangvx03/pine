import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../controllers/coupon/coupon_controller.dart';
import '../table/coupon_table.dart';

class CouponsDesktopScreen extends StatelessWidget {
  const CouponsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(heading: 'Mã giảm giá', breadcrumbItems: ['Mã giảm giá']),
              const SizedBox(height: PSizes.spaceBtwSections),
        
              // Table Body
              // Show Loader
              PRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      PTableHeader(buttonText: 'Tạo mã giảm giá',
                          onPressed: () => Get.toNamed(PRoutes.createCoupon),
                          searchController: controller.searchTextController,
                          searchOnChanged: (query) => controller.searchQuery(query)
                      ),
                      const SizedBox(height: PSizes.spaceBtwItems),
        
                      // Table
                      Obx(() {
                        if (controller.isLoading.value) return const PLoaderAnimation();
                        return const CouponTable();
                      })

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
