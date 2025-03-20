import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../authentication/models/user_model.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';

class CustomerDetailTabletScreen extends StatelessWidget {
  const CustomerDetailTabletScreen({super.key, required this.customer});

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
              PBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: customer.fullName,
                  breadcrumbItems: const [{ 'label': 'Danh sách người dùng', 'path': PRoutes.customers }, 'Chi tiết']
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
