import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/orders_table.dart';

class OrdersMobileScreen extends StatelessWidget {
  const OrdersMobileScreen({super.key});

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
              const PBreadcrumbsWithHeading(heading: 'Đơn hàng', breadcrumbItems: ['Đơn hàng']),
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
                    OrderTable(),
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
