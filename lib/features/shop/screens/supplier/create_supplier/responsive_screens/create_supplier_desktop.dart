import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../routes/routes.dart';
import '../widgets/create_supplier_form.dart';

class CreateSupplierDesktopScreen extends StatelessWidget {
  const CreateSupplierDesktopScreen({super.key});

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
              PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Tạo đơn nhập hàng', breadcrumbItems: [{ 'label': 'Nhập hàng', 'path': PRoutes.suppliers }, 'Tạo đơn nhập hàng']),
              SizedBox(height: PSizes.spaceBtwSections),

              // Form
              CreateSupplierForm(),
            ],
          ),
        ),
      ),
    );
  }
}
