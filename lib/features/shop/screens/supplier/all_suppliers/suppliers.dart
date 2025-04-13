import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/coupon/all_coupons/responsive_screens/coupons_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/supplier/all_suppliers/responsive_screens/suppliers_desktop.dart';

import '../../review/all_reviews/responsive_screens/reviews_desktop_screen.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: SuppliersDesktopScreen());
  }
}
