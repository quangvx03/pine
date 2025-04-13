import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/review/review_controller.dart';

import '../../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../table/reviews_table.dart';

class ReviewsDesktopScreen extends StatelessWidget {
  const ReviewsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(heading: 'Đánh giá', breadcrumbItems: ['Đánh giá']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Table Body
              PRoundedContainer(
                child: Column(
                  children: [
                    // Table Header có cả Search và Dropdown lọc sao
                    Row(
                      children: [
                        // Dropdown lọc số sao
                        Obx(() => DropdownButton<int>(
                          value: controller.selectedStar.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedStar.value = value;
                              controller.filterByStar();
                            }
                          },
                          items: [
                            const DropdownMenuItem(value: 0, child: Text("Tất cả")),
                            for (int i = 1; i <= 5; i++)
                              DropdownMenuItem(value: i, child: Text("$i sao")),
                          ],
                        )),

                        const SizedBox(width: PSizes.spaceBtwItems),

                        // Search
                        Expanded(
                          child: PTableHeader(
                            showLeftWidget: false,
                            searchController: controller.searchTextController,
                            searchOnChanged: (query) => controller.searchQuery(query),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Table
                    Obx(() {
                      if (controller.isLoading.value) return const PLoaderAnimation();
                      return const ReviewTable();
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
