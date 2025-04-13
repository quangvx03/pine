import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../models/coupon_model.dart';
import '../widgets/edit_coupon_form.dart';

class EditCouponDesktopScreen extends StatelessWidget {
  const EditCouponDesktopScreen({super.key, required this.coupon});

  final CouponModel coupon;

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
              const PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Cập nhật mã giảm giá', breadcrumbItems: [{ 'label': 'Mã giảm giá', 'path': PRoutes.coupons }, 'Cập nhật mã giảm giá']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Form
              EditCouponForm(coupon: coupon),
            ],
          ),
        ),
      ),
    );
  }
}
