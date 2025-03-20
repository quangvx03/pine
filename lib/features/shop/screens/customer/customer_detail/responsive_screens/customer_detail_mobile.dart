import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../authentication/models/user_model.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';

class CustomerDetailMobileScreen extends StatelessWidget {
  const CustomerDetailMobileScreen({super.key, required this.customer});

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
              CustomerInfo(customer: customer),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Shipping Address
              const ShippingAddress(),
              const SizedBox(width: PSizes.spaceBtwSections),

              // Right Side Customer Orders
              const CustomerOrders()
            ],
          ),
        ),
      ),
    );
  }
}
