import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customers_desktop_screen.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customers_mobile_screen.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customers_tablet_screen.dart';
import 'package:pine_admin_panel/features/shop/screens/order/all_orders/responsive_screens/orders_desktop_screen.dart';
import 'package:pine_admin_panel/features/shop/screens/order/all_orders/responsive_screens/orders_mobile_screen.dart';
import 'package:pine_admin_panel/features/shop/screens/order/all_orders/responsive_screens/orders_tablet_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: OrdersDesktopScreen(), tablet: OrdersTabletScreen(), mobile: OrdersMobileScreen());
  }
}
