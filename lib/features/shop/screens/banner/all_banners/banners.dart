import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/banner/all_banners/responsive_screens/banners_desktop.dart';
import 'package:pine_admin_panel/features/shop/screens/banner/all_banners/responsive_screens/banners_mobile.dart';
import 'package:pine_admin_panel/features/shop/screens/banner/all_banners/responsive_screens/banners_tablet.dart';

class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: BannersDesktopScreen(), tablet: BannersTabletScreen(), mobile: BannersMobileScreen());
  }
}
