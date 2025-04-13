import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/coupon/edit_coupon/responsive_screens/edit_coupon_desktop.dart';

class EditCouponScreen extends StatelessWidget {
  const EditCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coupon = Get.arguments;
    return PSiteTemplate(desktop: EditCouponDesktopScreen(coupon: coupon));
  }
}
