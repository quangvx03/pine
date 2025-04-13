import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';
import 'package:pine_admin_panel/features/shop/controllers/supplier/supplier_detail_controller.dart';
import 'package:pine_admin_panel/features/shop/models/supplier_model.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../controllers/supplier/supplier_detail_controller.dart';
import '../widgets/supplier_info.dart';
import '../widgets/supplier_orders.dart';

class SupplierDetailDesktopScreen extends StatefulWidget {
  const SupplierDetailDesktopScreen({super.key, required this.supplier});

  final SupplierModel supplier;

  @override
  _SupplierDetailDesktopScreenState createState() => _SupplierDetailDesktopScreenState();
}

class _SupplierDetailDesktopScreenState
    extends State<SupplierDetailDesktopScreen> {
  late SupplierDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SupplierDetailController());
    controller.supplier.value = widget.supplier;
  }

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
              PBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: widget.supplier.name,
                breadcrumbItems: [
                  {'label': 'Danh sách đơn nhập hàng', 'path': PRoutes.suppliers},
                  'Chi tiết'
                ],
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Supplier Information
                  Expanded(
                      child: Column(
                        children: [
                          // Supplier Info
                          SupplierInfo(supplier: widget.supplier),
                          const SizedBox(height: PSizes.spaceBtwSections),
                        ],
                      )),
                  const SizedBox(width: PSizes.spaceBtwSections),

                  // Right Side Supplier Orders
                  const Expanded(flex: 2, child: SupplierProducts()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
