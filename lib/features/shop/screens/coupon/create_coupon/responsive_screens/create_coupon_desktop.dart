import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../routes/routes.dart';
import '../widgets/create_coupon_form.dart';

class CreateCouponDesktopScreen extends StatelessWidget {
  const CreateCouponDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Tạo mã giảm giá', breadcrumbItems: [{ 'label': 'Mã giảm giá', 'path': PRoutes.coupons }, 'Tạo mã giảm giá']),
              SizedBox(height: PSizes.spaceBtwSections),

              // Form
              CreateCouponForm(),
            ],
          ),
        ),
      ),
    );
  }
}
