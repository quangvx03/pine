import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/supplier/create_supplier/responsive_screens/create_supplier_desktop.dart';
class CreateSupplierScreen extends StatelessWidget {
  const CreateSupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: CreateSupplierDesktopScreen());
  }
}
