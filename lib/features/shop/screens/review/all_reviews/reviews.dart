import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/order/all_orders/responsive_screens/orders_desktop_screen.dart';
import 'package:pine_admin_panel/features/shop/screens/review/all_reviews/responsive_screens/reviews_desktop_screen.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: ReviewsDesktopScreen());
  }
}
