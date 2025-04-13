import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../routes/routes.dart';
import '../widgets/create_category_form.dart';

class CreateCategoryDesktopScreen extends StatelessWidget {
  const CreateCategoryDesktopScreen({super.key});

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
              PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Tạo danh mục', breadcrumbItems: [{ 'label': 'Danh mục', 'path': PRoutes.categories }, 'Tạo danh mục']),
              SizedBox(height: PSizes.spaceBtwSections),

              // Form
              CreateCategoryForm(),
            ],
          ),
        ),
      ),
    );
  }
}
