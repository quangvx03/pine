import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';

import '../../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../table/customer_table.dart';
import '../table/staff_table.dart';

class CustomersDesktopScreen extends StatelessWidget {
  const CustomersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(heading: 'Người dùng', breadcrumbItems: ['Người dùng']),
              const SizedBox(height: PSizes.spaceBtwSections),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.changeCategory('Khách hàng');
                      },
                      child: Text(
                        'Khách hàng',
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.currentCategory.value == 'Khách hàng'
                              ? PColors.primary
                              : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    TextButton(
                      onPressed: () {
                        controller.changeCategory('Nhân viên');
                      },
                      child: Text(
                        'Nhân viên',
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.currentCategory.value == 'Nhân viên'
                              ? PColors.primary
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Table Body
              PRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    Obx(() {
                      return PTableHeader(
                        showLeftWidget: controller.currentCategory.value == 'Nhân viên',
                        buttonText: 'Thêm nhân viên',
                        onPressed: () => Get.toNamed(PRoutes.createStaff),
                        searchController: controller.searchTextController,
                        searchOnChanged: (query) => controller.searchQuery(query),
                      );
                    }),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Table Content
                    Obx(() {
                      if (controller.isLoading.value) return const PLoaderAnimation();
                      if (controller.currentCategory.value == 'Khách hàng') {
                        return const CustomerTable();  // Bảng dành cho Khách hàng
                      } else {
                        return const StaffTable();  // Bảng dành cho Nhân viên
                      }
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


