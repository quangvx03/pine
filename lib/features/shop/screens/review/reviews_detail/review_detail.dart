import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/review/reviews_detail/responsive_screens/review_detail_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/review/reviews_detail/responsive_screens/review_detail_desktop.dart';

class ReviewDetailScreen extends StatelessWidget {
  const ReviewDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final review = Get.arguments;
    final reviewId = Get.parameters['reviewId'];
    return PSiteTemplate(desktop: ReviewDetailDesktopScreen(review: review));
  }
}
