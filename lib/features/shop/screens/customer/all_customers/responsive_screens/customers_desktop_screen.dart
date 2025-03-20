import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/customer_table.dart';

class CustomersDesktopScreen extends StatelessWidget {
  const CustomersDesktopScreen({super.key});

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
              const PBreadcrumbsWithHeading(heading: 'Người dùng', breadcrumbItems: ['Người dùng']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Table Body
              // Show Loader
              PRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    PTableHeader(showLeftWidget: false),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Table
                    CustomerTable(),
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
