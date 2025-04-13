import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../models/category_model.dart';
import '../widgets/edit_category_form.dart';

class EditCategoryDesktopScreen extends StatelessWidget {
  const EditCategoryDesktopScreen({super.key, required this.category});

  final CategoryModel category;

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
              const PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Cập nhật danh mục', breadcrumbItems: [{ 'label': 'Danh mục', 'path': PRoutes.categories }, 'Cập nhật danh mục']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Form
              EditCategoryForm(category: category),
            ],
          ),
        ),
      ),
    );
  }
}
