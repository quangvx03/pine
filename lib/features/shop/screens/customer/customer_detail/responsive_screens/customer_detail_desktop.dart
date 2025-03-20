import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/features/authentication/models/user_model.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../routes/routes.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';

class CustomerDetailDesktopScreen extends StatelessWidget {
  const CustomerDetailDesktopScreen({super.key, required this.customer});

  final UserModel customer;

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
              const PBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                  heading: 'User1',
                  breadcrumbItems: [{ 'label': 'Danh sách người dùng', 'path': PRoutes.customers }, 'Chi tiết']
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Customer Information
                  Expanded(
                      child: Column(
                        children: [
                          // Customer Info
                          CustomerInfo(customer: customer),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Shipping Address
                          const ShippingAddress(),
                        ],
                      )
                  ),
                  const SizedBox(width: PSizes.spaceBtwSections),

                  // Right Side Customer Orders
                  const Expanded(flex: 2, child: CustomerOrders()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
