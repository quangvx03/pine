import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_mobile.dart';
import 'package:pine_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_tablet.dart';
import 'package:pine_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_mobile.dart';
import 'package:pine_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_tablet.dart';

class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: CreateProductDesktopScreen(), tablet: CreateProductTabletScreen(), mobile: CreateProductMobileScreen());
  }
}
