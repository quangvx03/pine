import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/category/all_categories/responsive_screens/categories_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/category/all_categories/responsive_screens/categories_mobile.dart';
import 'package:pine_admin_panel/features/shop/screens/category/all_categories/responsive_screens/categories_tablet.dart';
import 'package:pine_admin_panel/features/shop/screens/product/all_products/responsive_screens/products_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/product/all_products/responsive_screens/products_mobile.dart';
import 'package:pine_admin_panel/features/shop/screens/product/all_products/responsive_screens/products_tablet.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: ProductsDesktopScreen(), tablet: ProductsTabletScreen(), mobile: ProductsMobileScreen());
  }
}
