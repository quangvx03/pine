import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_mobile.dart';
import 'package:pine_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_tablet.dart';

import '../../../models/category_model.dart';

class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = CategoryModel(id: '', name: '', image: '');
    return PSiteTemplate(
        desktop: EditCategoryDesktopScreen(category: category),
        tablet: EditCategoryTabletScreen(category: category),
        mobile: EditCategoryMobileScreen(category: category));
  }
}
