import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/customer_detail/responsive_screens/customer_detail_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/supplier/suppliers_detail/responsive_screens/supplier_detail_desktop.dart';

class SupplierDetailScreen extends StatelessWidget {
  const SupplierDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supplier = Get.arguments;
    final supplierId = Get.parameters['supplierId'];
    return PSiteTemplate(desktop: SupplierDetailDesktopScreen(supplier: supplier),);
  }
}
