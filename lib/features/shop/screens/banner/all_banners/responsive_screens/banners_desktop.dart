import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/banner/banner_controller.dart';

import '../../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../table/banner_table.dart';

class BannersDesktopScreen extends StatelessWidget {
  const BannersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(heading: 'Banner', breadcrumbItems: ['Banner']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Table Body
              // Show Loader
              Obx(() {
                  if(controller.isLoading.value) return const PLoaderAnimation();

                   return PRoundedContainer(
                    child: Column(
                      children: [
                        // Table Header
                        PTableHeader(buttonText: 'Thêm banner', onPressed: () => Get.toNamed(PRoutes.createBanner)),
                        SizedBox(height: PSizes.spaceBtwItems),

                        // Table
                        BannersTable(),
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
