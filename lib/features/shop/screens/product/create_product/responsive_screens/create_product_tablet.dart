import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class CreateProductTabletScreen extends StatelessWidget {
  const CreateProductTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Thêm sản phẩm', breadcrumbItems: [{ 'label': 'Danh sách sản phẩm', 'path': PRoutes.products }, 'Thêm sản phẩm']),
              SizedBox(height: PSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
